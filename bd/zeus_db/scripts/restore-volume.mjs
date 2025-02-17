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

// 📌 Definir el entorno
const env = process.argv[2] || "dev";
const backupFile = path.join(__dirname, `../backups/db_backup_${env}.tar.gz`);
const volumeName = "docker_postgres_zeus_db_identity_provider_data";  // Asegurar que es el nombre correcto

async function restoreVolume() {
    if (!fs.existsSync(backupFile)) {
        console.log(`⚠ No hay backup disponible para restaurar.`);
        return;
    }

    try {
        console.log(`🔄 Restaurando el volumen Docker en entorno: ${env}...`);
        await execAsync(`docker run --rm -v ${volumeName}:/data -v ${__dirname}/../backups:/backup ubuntu tar xzf /backup/db_backup_${env}.tar.gz -C /data`);
        console.log(`✅ Volumen restaurado correctamente.`);
    } catch (error) {
        console.error(`❌ Error al restaurar el volumen: ${error.message}`);
    }
}

restoreVolume();
