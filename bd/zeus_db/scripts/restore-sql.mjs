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

// 📌 Definir rutas de archivos de backup
const BACKUP_FILE = path.join(__dirname, `../backups/db_backup_${env}.sql`);

// 📌 Verificar si el backup existe
if (!fs.existsSync(BACKUP_FILE)) {
    console.error(`❌ No se encontró el archivo de backup: ${BACKUP_FILE}`);
    process.exit(1);
}

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

// 📌 Comando para restaurar la base de datos en Docker
const command = `docker exec -t postgres_zeus_db_identity_provider pg_restore -U ${DB_USER} -d ${DB_NAME} -F c /backups/db_backup_${env}.sql`;

async function restoreDatabase() {
    try {
        console.log(`🔄 Restaurando la base de datos desde el backup: ${BACKUP_FILE}...`);

        // 📌 Copiar el archivo de backup al contenedor Docker
        await execAsync(`docker cp ${BACKUP_FILE} postgres_zeus_db_identity_provider:/backups/db_backup_${env}.sql`);

        // 📌 Restaurar la base de datos dentro del contenedor
        await execAsync(command);

        console.log(`✅ Restauración completada con éxito.`);
    } catch (error) {
        console.error(`❌ Error al restaurar la base de datos: ${error.message}`);
    }
}

// 📌 Ejecutar la restauración
restoreDatabase();
