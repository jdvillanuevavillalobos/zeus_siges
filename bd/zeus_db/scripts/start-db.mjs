import { exec } from "child_process";
import process from "process";
import path from "path";
import { fileURLToPath } from "url";

// 📌 Obtener el directorio del script (compatible con ES Modules)
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// 📌 Obtener el entorno desde argumentos (dev, test, prod), por defecto "dev"
const env = process.argv[2] || "dev";

// 📌 Comando para levantar `docker-compose`
const command = `docker-compose --env-file ${__dirname}/../config/.env.${env} -f docker/docker-compose.yml -f docker/docker-compose.zeus_db_identity_provider.yml up -d --build`;

console.log(`🚀 Iniciando la base de datos en entorno: ${env}...`);

// 📌 Ejecutar el comando en la terminal
exec(command, (error, stdout, stderr) => {
    if (error) {
        console.error(`❌ Error al iniciar Docker: ${error.message}`);
        return;
    }
    if (stderr) {
        console.error(`⚠ Advertencias: ${stderr}`);
    }
    console.log(`✅ Base de datos iniciada con éxito:\n${stdout}`);
});
