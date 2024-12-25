#!/bin/bash
set -e

echo "Configurando la réplica de PostgreSQL..."

# Leer variables del entorno con valores predeterminados
PRIMARY_IP=${PRIMARY_IP:-postgres_primary}
PRIMARY_PORT=${PRIMARY_PORT:-5432}
DB_USER=${POSTGRES_USER:-admin}
DB_PASSWORD=${POSTGRES_PASSWORD:-admin123}
DB_NAME=${POSTGRES_DB:-sigeszeus}
REPLICATION_SLOT=${REPLICATION_SLOT:-replica_slot}
SYSTEM_USER=${SYSTEM_USER:-postgres}
PGDATA="/var/lib/postgresql/data"
PG_HBA_SOURCE="/etc/postgresql/pg_hba.conf"

# Validar conexión con el nodo principal
echo "Validando la conexión con el nodo principal ($PRIMARY_IP:$PRIMARY_PORT)..."
until pg_isready -h "$PRIMARY_IP" -p "$PRIMARY_PORT" -U "$DB_USER" -d "$DB_NAME"; do
  echo "Esperando a que el nodo principal esté disponible en $PRIMARY_IP:$PRIMARY_PORT..."
  sleep 2
done
echo "El nodo principal está disponible."

# Configura el archivo .pgpass para la autenticación automática
PGPASS_FILE="/var/lib/postgresql/.pgpass"
echo "Configurando el archivo .pgpass para autenticación automática..."
cat > "$PGPASS_FILE" <<EOF
$PRIMARY_IP:$PRIMARY_PORT:*:$DB_USER:$DB_PASSWORD
EOF
chmod 600 "$PGPASS_FILE"
chown postgres:postgres "$PGPASS_FILE"
echo "Archivo .pgpass configurado correctamente."

# Verificar si el directorio de datos está vacío
echo "Verificando el estado del directorio de datos..."
if [ -d "$PGDATA" ] && [ "$(ls -A $PGDATA)" ]; then
  echo "El directorio de datos no está vacío. Limpiándolo..."
  rm -rf "$PGDATA/*"
  echo "Directorio de datos limpio."
else
  echo "El directorio de datos está vacío. Continuando..."
fi

# Realiza la copia base desde el nodo principal
echo "Iniciando copia base desde el nodo principal ($PRIMARY_IP)..."
if pg_basebackup -h "$PRIMARY_IP" -D "$PGDATA" -U "$DB_USER" -Fp -Xs -P -R; then
  echo "Copia base completada con éxito."
else
  echo "Error: Falló la copia base. Verifica la conexión con el nodo principal y las credenciales."
  exit 1
fi

# Sobrescribir archivo pg_hba.conf
echo "Sobrescribiendo el archivo pg_hba.conf con la configuración personalizada..."
cp "$PG_HBA_SOURCE" "$PGDATA/pg_hba.conf"
chown ${SYSTEM_USER}:${SYSTEM_USER} "$PGDATA/pg_hba.conf"
chmod 600 "$PGDATA/pg_hba.conf"
echo "Archivo pg_hba.conf configurado correctamente."

# Configura el uso de slots de replicación
echo "Configurando el slot de replicación '${REPLICATION_SLOT}'..."
if grep -q "primary_slot_name" "$PGDATA/postgresql.auto.conf"; then
  sed -i "s/primary_slot_name = .*/primary_slot_name = '${REPLICATION_SLOT}'/" "$PGDATA/postgresql.auto.conf"
else
  echo "primary_slot_name = '${REPLICATION_SLOT}'" >> "$PGDATA/postgresql.auto.conf"
fi
echo "Slot de replicación configurado correctamente."

# Ajusta permisos del directorio de datos
echo "Ajustando permisos del directorio de datos..."
chown -R ${SYSTEM_USER}:${SYSTEM_USER} "$PGDATA"
chmod 700 "$PGDATA"
echo "Permisos ajustados correctamente."

# Crea el archivo standby.signal para activar el modo réplica
echo "Activando el modo réplica..."
touch "$PGDATA/standby.signal"
chown postgres:postgres "$PGDATA/standby.signal"
echo "Modo réplica activado."

echo "Réplica configurada correctamente."