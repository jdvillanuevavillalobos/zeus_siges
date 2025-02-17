import { exec } from "child_process";
import process from "process";
import path from "path";
import { fileURLToPath } from "url";

// 📌 Obtener el directorio del script (compatible con ES Modules)
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// 📌 Obtener el entorno desde argumentos (dev, test, prod), por defecto "dev"
const env = process.argv[2] || "dev";
const forceRemove = process.argv.includes("--force"); // 🔥 Si se usa `--force`, borra volúmenes
const resetConfig = process.argv.includes("--reset-config"); // 🔥 Si se usa `--reset-config`, borra solo configs

// 📌 Comando base para detener Docker
let command = `docker-compose --env-file ${__dirname}/../config/.env.${env} -f docker/docker-compose.yml -f docker/docker-compose.zeus_db_identity_provider.yml down ${forceRemove ? "-v" : ""}`;

console.log(`🛑 Apagando la base de datos en entorno: ${env}...`);
if (forceRemove) {
    console.log("⚠ Eliminando volúmenes de datos...");
} else if (resetConfig) {
    console.log("⚠ Restableciendo archivos de configuración sin eliminar datos...");
}

// 📌 Ejecutar el comando en la terminal
exec(command, (error, stdout, stderr) => {
    if (error) {
        console.error(`❌ Error al detener Docker: ${error.message}`);
        return;
    }
    if (stderr) {
        console.error(`⚠ Advertencias: ${stderr}`);
    }
    console.log(`✅ Base de datos detenida con éxito:\n${stdout}`);

    // 🔥 Si se activó `--reset-config`, eliminar solo archivos de configuración en el volumen
    if (resetConfig) {
        const resetCommand = `
            docker run --rm -v postgres_zeus_db_identity_provider_data:/var/lib/postgresql/data alpine sh -c "
            rm -f /var/lib/postgresql/data/postgresql.conf /var/lib/postgresql/data/pg_hba.conf"
        `;
        exec(resetCommand, (error, stdout, stderr) => {
            if (error) {
                console.error(`❌ Error al restablecer configuraciones: ${error.message}`);
                return;
            }
            if (stderr) {
                console.error(`⚠ Advertencias: ${stderr}`);
            }
            console.log("✅ Archivos de configuración restablecidos. Levanta la BD para aplicar cambios.");
        });
    }
});
