#!/bin/bash
set -e

echo "Configurando la réplica de PostgreSQL..."

# Leer variables del entorno con valores predeterminados
PRIMARY_IP=${PRIMARY_IP:-postgres_primary}
PRIMARY_PORT=${PRIMARY_PORT:-5432}
DB_USER=${POSTGRES_USER:-admin}
DB_PASSWORD=${POSTGRES_PASSWORD:-admin123}
REPLICATION_SLOT=${REPLICA_SLOT:-replica_slot}

# Validar conexión con el nodo principal
until pg_isready -h "$PRIMARY_IP" -p "$PRIMARY_PORT" -U "$DB_USER"; do
  echo "Esperando a que el nodo principal esté disponible en $PRIMARY_IP:$PRIMARY_PORT..."
  sleep 2
done

# Configura el archivo .pgpass para la autenticación automática
PGPASS_FILE="/var/lib/postgresql/.pgpass"
echo "$PRIMARY_IP:$PRIMARY_PORT:*:$DB_USER:$DB_PASSWORD" > "$PGPASS_FILE"
chmod 600 "$PGPASS_FILE"
chown postgres:postgres "$PGPASS_FILE"

# Realiza la copia base desde el nodo principal
echo "Iniciando copia base desde el nodo principal ($PRIMARY_IP)..."
pg_basebackup -h "$PRIMARY_IP" -D /var/lib/postgresql/data -U "$DB_USER" -Fp -Xs -P -R || {
  echo "Error: Falló la copia base. Verifica la conexión con el nodo principal."
  exit 1
}

# Configura el uso de slots de replicación
echo "primary_slot_name = '$REPLICATION_SLOT'" >> /var/lib/postgresql/data/postgresql.auto.conf

# Ajusta permisos del directorio de datos
echo "Ajustando permisos del directorio de datos..."
chown -R postgres:postgres /var/lib/postgresql/data
chmod 700 /var/lib/postgresql/data

# Crea el archivo standby.signal para activar el modo réplica
echo "Activando el modo réplica..."
touch /var/lib/postgresql/data/standby.signal
chown postgres:postgres /var/lib/postgresql/data/standby.signal

echo "Réplica configurada correctamente."
