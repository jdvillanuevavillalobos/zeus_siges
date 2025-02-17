import { exec } from "child_process";
import process from "process";
import path from "path";
import { fileURLToPath } from "url";
import fs from "fs";
import { promisify } from "util";

// 📌 Convertir exec a función async
const execAsync = promisify(exec);

// 📌 Obtener el directorio actual
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// 📌 Definir el entorno (dev, test, prod)
const env = process.argv[2] || "dev";

// 📌 Cargar variables desde el archivo `.env`
const envFilePath = path.join(__dirname, `../config/.env.${env}`);
if (!fs.existsSync(envFilePath)) {
    console.error(`❌ No se encontró el archivo de configuración: ${envFilePath}`);
    process.exit(1);
}

// 📌 Leer el archivo `.env` y extraer credenciales de PostgreSQL
const envVars = fs.readFileSync(envFilePath, "utf-8").split("\n")
    .filter(line => line.includes("="))
    .map(line => line.trim().split("="))
    .reduce((acc, [key, value]) => ({ ...acc, [key]: value.replace(/['"]+/g, "") }), {});

// 📌 Definir variables de PostgreSQL
const DB_NAME = envVars.DB_NAME || "zeus_db_identity_provider";
const DB_USER = envVars.DB_USER || "admin";
const DB_HOST = envVars.DB_HOST || "localhost";
const DB_PORT = envVars.DB_PORT || "5433";  // Puerto 5433 (según tu configuración)
const BACKUP_DIR = path.join(__dirname, "../backups");
const BACKUP_FILE = path.join(BACKUP_DIR, `db_backup_${env}.sql`);

// 📌 Crear el directorio de backups si no existe
if (!fs.existsSync(BACKUP_DIR)) {
    fs.mkdirSync(BACKUP_DIR, { recursive: true });
}

// 📌 Comando `pg_dump` para generar el backup en SQL
const command = `docker exec -t postgres_zeus_db_identity_provider pg_dump -U ${DB_USER} -h ${DB_HOST} -p ${DB_PORT} -d ${DB_NAME} -F c -f /backups/db_backup_${env}.sql`;

async function backupDatabase() {
    try {
        console.log(`📦 Generando backup SQL de la base de datos en entorno: ${env}...`);

        // 📌 Ejecutar el backup dentro del contenedor Docker
        await execAsync(`docker exec -t postgres_zeus_db_identity_provider pg_dump -U ${DB_USER} -d ${DB_NAME} -F c -f /backups/db_backup_${env}.sql`);
        
        // 📌 Copiar el archivo desde el contenedor al host
        await execAsync(`docker cp postgres_zeus_db_identity_provider:/backups/db_backup_${env}.sql ${BACKUP_FILE}`);

        console.log(`✅ Backup completado: ${BACKUP_FILE}`);
    } catch (error) {
        console.error(`❌ Error al generar el backup: ${error.message}`);
    }
}

// 📌 Ejecutar el backup
backupDatabase();
