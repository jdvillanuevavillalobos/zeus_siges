zeus_db/
│── docker/
│   ├── docker-compose.yml                # Maestro (Orquestación global)
│   ├── docker-compose.zeus_db_identity_provider.yml  # Configuración específica para `zeus_db_identity_provider`
│   │── zeus_db_identity_provider/        # Carpeta exclusiva para `zeus_db_identity_provider`
│   │   ├── Dockerfile                     # Dockerfile solo para `zeus_db_identity_provider`
│   │   ├── init-scripts/                  # Scripts de inicialización
│   │   │   ├── postgresql/
│   │   │   │   ├── 01_create_schemas.sql  # Creación del esquema `idp_identity`
│   │   │   │   ├── 02_create_tables.sql   # Creación de la tabla `user`
│── migrations/                            # Migraciones para bases de datos
│   ├── postgresql/
│   │   ├── zeus_db_identity_provider/
│── scripts/                               # Scripts auxiliares en Node.js
│── config/                                # Configuración general
│   ├── .env                               # Variables de entorno
│   ├── config.yml                         # Configuración de BD
│── README.md                              # Documentación

📢 Para levantar la base de datos zeus_db_identity_provider:
docker-compose -f docker/docker-compose.yml -f docker/docker-compose.zeus_db_identity_provider.yml up --build -d

📢 Para verificar que PostgreSQL está corriendo:
docker ps
📢 Para acceder a la base de datos:
docker exec -it postgres_zeus_db_identity_provider psql -U admin -d zeus_db_identity_provider

📢 Para detener y eliminar el contenedor:
docker-compose -f docker/docker-compose.yml -f docker/docker-compose.zeus_db_identity_provider.yml down

📢 Para ver si los scripts de inicialización se ejecutaron correctamente:
SELECT schema_name FROM information_schema.schemata WHERE schema_name = 'idp_identity';

📢 Detener y eliminar los contenedores existentes
docker-compose -f docker/docker-compose.yml -f docker/docker-compose.zeus_db_identity_provider.yml down -v

📢 Reinicia PostgreSQL para aplicar cambios
docker restart postgres_zeus_db_identity_provider
