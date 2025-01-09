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
SCRIPT_INIT_DIR="/docker-entrypoint-initdb.d/script_init"  # Directorio para scripts SQL
PGDATA="/var/lib/postgresql/data"
PG_HBA_SOURCE="/etc/postgresql/pg_hba.conf"

# Asegurar que el directorio de datos esté inicializado
if [ ! -f ${PGDATA}/PG_VERSION ]; then
  echo "Directorio de datos vacío. Inicializando con initdb..."
  initdb -D ${PGDATA}
  echo "Directorio de datos inicializado."

  # Copiar archivo pg_hba.conf personalizado después de initdb
  echo "Copiando pg_hba.conf personalizado..."
  cp ${PG_HBA_SOURCE} ${PGDATA}/pg_hba.conf
else
  echo "El directorio de datos ya está inicializado."

  # Sobrescribir archivo pg_hba.conf en reinicios
  echo "Sobrescribiendo pg_hba.conf con configuración personalizada..."
  cp ${PG_HBA_SOURCE} ${PGDATA}/pg_hba.conf
fi

# Ajustar permisos del archivo pg_hba.conf
chown postgres:postgres ${PGDATA}/pg_hba.conf
chmod 600 ${PGDATA}/pg_hba.conf

# Configurar PostgreSQL para la replicación
echo "Configurando PostgreSQL para la replicación..."
cat > ${PGDATA}/postgresql.auto.conf <<EOF
wal_level = replica
max_wal_senders = ${MAX_WAL_SENDERS}
wal_keep_size = ${WAL_KEEP_SIZE}
max_replication_slots = ${MAX_REPLICATION_SLOTS}
synchronous_standby_names = '${SYNCHRONOUS_STANDBY_NAMES}'
EOF

# Iniciar PostgreSQL temporalmente para configuraciones avanzadas
echo "Iniciando PostgreSQL temporalmente para configuraciones avanzadas..."
pg_ctl -D ${PGDATA} -l ${PGDATA}/postgresql.log start

# Crear el usuario si no existe y garantizar roles necesarios
echo "Validando la existencia del usuario '${DB_USER}'..."
psql -U postgres -tc "SELECT 1 FROM pg_roles WHERE rolname = '${DB_USER}';" | grep -q 1 || {
  echo "Creando el usuario '${DB_USER}'..."
  psql -U postgres -c "CREATE ROLE ${DB_USER} LOGIN PASSWORD '${DB_PASSWORD}' SUPERUSER CREATEDB REPLICATION;"
}
echo "Usuario '${DB_USER}' configurado."

# Crear la base de datos si no existe
echo "Validando la existencia de la base de datos '${DB_NAME}'..."
psql -U postgres -tc "SELECT 1 FROM pg_database WHERE datname = '${DB_NAME}';" | grep -q 1 || {
  echo "Creando la base de datos '${DB_NAME}'..."
  psql -U postgres -c "CREATE DATABASE ${DB_NAME} OWNER ${DB_USER};"
}
echo "Base de datos '${DB_NAME}' configurada."

# Ejecutar scripts en script_init si existen
if [ -d "${SCRIPT_INIT_DIR}" ]; then
  echo "Ejecutando scripts en ${SCRIPT_INIT_DIR}..."
  for sql_file in ${SCRIPT_INIT_DIR}/*.sql; do
    if [ -f "$sql_file" ]; then
      echo "Ejecutando $sql_file..."
      psql -U ${DB_USER} -d ${DB_NAME} -f "$sql_file" || {
        echo "Error ejecutando $sql_file. Verifique su contenido."
        exit 1
      }
      echo "$sql_file ejecutado correctamente."
    fi
  done
else
  echo "Directorio ${SCRIPT_INIT_DIR} no encontrado. Saltando ejecución de scripts SQL."
fi

# Crear el slot de replicación
echo "Creando el slot de replicación '${REPLICATION_SLOT}'..."
psql -U postgres -c "SELECT * FROM pg_create_physical_replication_slot('${REPLICATION_SLOT}');" || {
  echo "Advertencia: No se pudo crear el slot de replicación. Es posible que ya exista."
}

# Detener PostgreSQL después de configurarlo
echo "Deteniendo PostgreSQL después de la configuración inicial..."
pg_ctl -D ${PGDATA} stop

echo "Nodo principal configurado correctamente."
