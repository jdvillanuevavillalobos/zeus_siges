import { exec } from "child_process";
import process from "process";
import path from "path";
import { fileURLToPath } from "url";
import { promisify } from "util";

// 📌 Convertir exec a función async
const execAsync = promisify(exec);

// 📌 Obtener el directorio actual
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// 📌 Definir el entorno
const env = process.argv[2] || "dev";
const backupFile = path.join(__dirname, `../backups/db_backup_${env}.tar.gz`);
const volumeName = "docker_postgres_zeus_db_identity_provider_data";  // Asegurar que es el nombre correcto

async function backupVolume() {
    try {
        console.log(`📦 Realizando backup del volumen Docker en entorno: ${env}...`);
        await execAsync(`docker run --rm -v ${volumeName}:/data -v ${__dirname}/../backups:/backup ubuntu tar czf /backup/db_backup_${env}.tar.gz -C /data .`);
        console.log(`✅ Backup guardado en: ${backupFile}`);
    } catch (error) {
        console.error(`❌ Error al hacer backup del volumen: ${error.message}`);
    }
}

backupVolume();
