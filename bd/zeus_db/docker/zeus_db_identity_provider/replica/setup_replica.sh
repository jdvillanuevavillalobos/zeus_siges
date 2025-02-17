#!/bin/bash
set -e  # Detener el script en caso de error

echo "🔄 Configurando la réplica de PostgreSQL..."

# Definir variables
PRIMARY_IP=${PRIMARY_IP:-postgres_zeus_db_identity_provider}  # Nombre del nodo primario
PRIMARY_PORT=5432  # Puerto del nodo primario
REPLICATION_USER=${REPLICATION_USER:-replicator}  # Usuario de replicación
REPLICATION_PASSWORD=${REPLICATION_PASSWORD:-replicator_password}  # Contraseña de replicación
PGDATA="/var/lib/postgresql/data"  # Directorio de datos de PostgreSQL
RETRIES=30  # Número de intentos de conexión antes de abortar
COUNT=0

# Verificar si la réplica ya está configurada
if [ -f "$PGDATA/standby.signal" ]; then
  echo "✅ La réplica ya está configurada. Iniciando PostgreSQL en modo réplica..."
  exec su postgres -c "postgres -D \"$PGDATA\" -c config_file=/etc/postgresql/postgresql.conf"
  exit 0
fi

# Esperar hasta que el nodo primario esté disponible
echo "📡 Esperando a que el nodo primario ($PRIMARY_IP:$PRIMARY_PORT) esté disponible..."
until PGPASSWORD="$REPLICATION_PASSWORD" pg_isready -h "$PRIMARY_IP" -p "$PRIMARY_PORT" -U "$REPLICATION_USER"; do
  COUNT=$((COUNT + 1))
  if [ "$COUNT" -ge "$RETRIES" ]; then
    echo "❌ El nodo primario no está disponible después de $RETRIES intentos. Abortando..."
    exit 1
  fi
  echo "⏳ Intento $COUNT/$RETRIES: Esperando al nodo primario..."
  sleep 2
done
echo "✅ Nodo primario disponible."

# Verificar si el usuario de replicación puede autenticarse
echo "🔄 Verificando conexión del usuario de replicación..."
if ! PGPASSWORD="$REPLICATION_PASSWORD" psql -h "$PRIMARY_IP" -p "$PRIMARY_PORT" -U "$REPLICATION_USER" -d postgres -c "SELECT now();"; then
  echo "❌ Error de autenticación. Revisa la contraseña y configuración de pg_hba.conf."
  exit 1
fi

# Limpiar el directorio de datos si ya hay datos previos
echo "🗑 Limpiando datos antiguos en la réplica..."
rm -rf "$PGDATA"/*

# Realizar la copia base desde el nodo primario
echo "📦 Iniciando copia base desde el nodo primario ($PRIMARY_IP)..."
if ! PGPASSWORD="$REPLICATION_PASSWORD" pg_basebackup -h "$PRIMARY_IP" -D "$PGDATA" -U "$REPLICATION_USER" -Fp -Xs -P -R; then
  echo "❌ Error en la copia base. Revisa la conexión con el nodo primario."
  exit 1
fi

echo "✅ Copia base completada."

# Crear el archivo `standby.signal` para activar el modo réplica
touch "$PGDATA/standby.signal"

# Ajustar permisos
chown -R postgres:postgres "$PGDATA"
chmod 700 "$PGDATA"

echo "🎉 Réplica configurada correctamente. Iniciando PostgreSQL..."
exec su postgres -c "postgres -D \"$PGDATA\" -c config_file=/etc/postgresql/postgresql.conf"
