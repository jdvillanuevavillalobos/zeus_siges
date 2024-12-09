#!/bin/bash
set -e

echo "Configurando el nodo principal de PostgreSQL..."

# Leer variables del entorno con valores predeterminados
DB_USER=${POSTGRES_USER:-admin}
DB_PASSWORD=${POSTGRES_PASSWORD:-admin123}
DB_NAME=${POSTGRES_DB:-sigeszeus}
PRIMARY_IP=${PRIMARY_IP:-postgres_primary}
REPLICATION_SLOT=${REPLICA_SLOT:-replica_slot}
MAX_WAL_SIZE=${MAX_WAL_SIZE:-1GB}
WAL_KEEP_SIZE=${WAL_KEEP_SIZE:-64MB}
MAX_WAL_SENDERS=${MAX_WAL_SENDERS:-5}
MAX_REPLICATION_SLOTS=${MAX_REPLICATION_SLOTS:-5}
SYNCHRONOUS_STANDBY_NAMES=${SYNCHRONOUS_STANDBY_NAMES:-''}
SYSTEM_USER=${SYSTEM_USER:-postgres}
INIT_SQL_FILE="/docker-entrypoint-initdb.d/init.sql"

# Asegurar que el directorio de datos esté inicializado
if [ ! -f /var/lib/postgresql/data/PG_VERSION ]; then
  echo "Directorio de datos vacío. Inicializando con initdb..."
  initdb -D /var/lib/postgresql/data
  echo "Directorio de datos inicializado."
else
  echo "El directorio de datos ya está inicializado."
fi

# Ajustar permisos del directorio de datos
echo "Ajustando permisos del directorio de datos..."
chown -R "${SYSTEM_USER}:${SYSTEM_USER}" /var/lib/postgresql/data
chmod 700 /var/lib/postgresql/data

# Configurar PostgreSQL para la replicación
echo "Configurando PostgreSQL para la replicación..."
cat > /var/lib/postgresql/data/postgresql.auto.conf <<EOF
wal_level = replica
max_wal_senders = ${MAX_WAL_SENDERS}
wal_keep_size = ${WAL_KEEP_SIZE}
max_replication_slots = ${MAX_REPLICATION_SLOTS}
synchronous_standby_names = '${SYNCHRONOUS_STANDBY_NAMES}'
EOF

# Iniciar PostgreSQL temporalmente para configuraciones avanzadas
echo "Iniciando PostgreSQL temporalmente para configuraciones avanzadas..."
pg_ctl -D /var/lib/postgresql/data -l /var/lib/postgresql/data/postgresql.log start

# Crear el usuario si no existe
echo "Validando la existencia del usuario '${DB_USER}'..."
psql -U postgres -tc "SELECT 1 FROM pg_roles WHERE rolname = '${DB_USER}';" | grep -q 1 || {
  echo "Creando el usuario '${DB_USER}'..."
  psql -U postgres -c "CREATE ROLE ${DB_USER} LOGIN PASSWORD '${DB_PASSWORD}'; ALTER ROLE ${DB_USER} CREATEDB; ALTER ROLE ${DB_USER} REPLICATION;"
}
echo "Usuario '${DB_USER}' configurado."

# Crear la base de datos si no existe
echo "Validando la existencia de la base de datos '${DB_NAME}'..."
psql -U postgres -tc "SELECT 1 FROM pg_database WHERE datname = '${DB_NAME}';" | grep -q 1 || {
  echo "Creando la base de datos '${DB_NAME}'..."
  psql -U postgres -c "CREATE DATABASE ${DB_NAME} OWNER ${DB_USER};"
}
echo "Base de datos '${DB_NAME}' configurada."

# Ejecutar init.sql si existe
if [ -f "${INIT_SQL_FILE}" ]; then
  echo "Ejecutando el script de inicialización (${INIT_SQL_FILE})..."
  psql -U ${DB_USER} -d ${DB_NAME} -f "${INIT_SQL_FILE}" && echo "init.sql ejecutado correctamente." || \
    echo "Advertencia: No se pudo ejecutar init.sql. Verifique su contenido."
else
  echo "El archivo ${INIT_SQL_FILE} no existe. Saltando ejecución de init.sql."
fi

# Crear el slot de replicación
echo "Creando el slot de replicación '${REPLICATION_SLOT}'..."
psql -U postgres -c "SELECT * FROM pg_create_physical_replication_slot('${REPLICATION_SLOT}');" || {
  echo "Advertencia: No se pudo crear el slot de replicación. Es posible que ya exista."
}

# Detener PostgreSQL después de configurarlo
echo "Deteniendo PostgreSQL después de la configuración inicial..."
pg_ctl -D /var/lib/postgresql/data stop

echo "Nodo principal configurado correctamente."
