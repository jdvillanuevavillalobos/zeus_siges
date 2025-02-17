# Zeus DB - Configuración y Estructura

Este repositorio contiene la configuración de la base de datos **Zeus DB**, incluyendo la orquestación con **Docker**, la estructura de **migraciones**, **scripts de inicialización** y **configuración de réplicas**.

---

## 📌 Estructura del Proyecto

```
zeus_db
├── estructura.txt                            # Archivo con la estructura del proyecto
├── README.md                                 # Documentación del proyecto
├── CHANGELOG.md                              # Documentación de cambios del proyecto
├── TODO.md                                   # Tareas pendientes del proyecto
│
├── config/                                   # Archivos de configuración
│   ├── .env.dev                              # Variables de entorno para desarrollo
│   ├── .env.test                             # Variables de entorno para pruebas
│   ├── .env.prod                             # Variables de entorno para producción
│
├── docker/                                   # Configuración de Docker y orquestación
│   ├── docker-compose.yml                    # Archivo maestro de orquestación
│   ├── docker-compose.zeus_db_identity_provider.yml # Configuración específica para `zeus_db_identity_provider`
│   │
│   ├── zeus_db_identity_provider/            # Configuración del servicio PostgreSQL principal
│   │   ├── Dockerfile                        # Dockerfile para la base de datos principal
│   │   ├── pg_hba.conf                       # Configuración de accesos (host-based authentication)
│   │   ├── postgresql.conf                   # Configuración del servidor PostgreSQL
│   │   ├── init-scripts/                     # Scripts de inicialización de la base de datos
│   │   │   ├── postgresql/
│   │   │   │   ├── 01_create_replication_user.sql  # Creación del usuario de replicación
│   │   │   │   ├── 02_create_schemas.sql          # Creación de esquemas en la base de datos
│   │   │   │   ├── 03_create_tables.sql           # Creación de tablas en los esquemas
│   │   │
│   │   ├── replica/                            # Configuración de la base de datos réplica
│   │   │   ├── pg_hba.conf                      # Configuración de accesos para la réplica
│   │   │   ├── postgresql.conf                  # Configuración específica para la réplica
│   │   │   ├── setup_replica.sh                 # Script para inicializar la replicación
│
├── migrations/                                # Migraciones para la base de datos
│   ├── postgresql/
│   │   ├── zeus_db_identity_provider/         # Migraciones específicas de `zeus_db_identity_provider`
│
├── scripts/                                   # Scripts auxiliares para gestión de la base de datos
│   ├── start-db.mjs                           # Script en Node.js para iniciar la base de datos
│   ├── stop-db.mjs                            # Script en Node.js para apagar la base de datos
```

---

## 🚀 Guía de Uso

### 🔹 Generar la estructura del proyecto en un archivo

```sh
tree /F /A > estructura.txt
```

---

### 🔹 Generar estructura del proyecto con contenido (excluyendo .md)

Para listar todos los archivos del proyecto y guardar su contenido en `estructura_contenido.txt`, excluyendo los archivos `.md`, ejecuta el siguiente comando en PowerShell:

```powershell
# Eliminar el archivo anterior si existe
Remove-Item -Path estructura_contenido.txt -ErrorAction SilentlyContinue

# Generar la estructura del proyecto y guardarla en UTF-8 sin BOM
Get-ChildItem -Path . -Recurse -File | Where-Object { $_.Extension -notin @(".md", ".log") } | ForEach-Object {
    Write-Host "Procesando: $($_.FullName)" -ForegroundColor Green
    "==== $($_.FullName) ====" | Out-File -Append estructura_contenido.txt -Encoding utf8
    Get-Content $_.FullName | Out-File -Append estructura_contenido.txt -Encoding utf8
}

Write-Host "Archivo estructura_contenido.txt generado correctamente en UTF-8." -ForegroundColor Cyan
```

---

### 🔹 Levantar la Base de Datos

```sh
node scripts/start-db.mjs dev
```

Para otros entornos:
```sh
node scripts/start-db.mjs test
node scripts/start-db.mjs prod
```

Si prefieres usar `docker-compose` manualmente:
```sh
docker-compose --env-file ./config/.env.dev -f docker/docker-compose.yml -f docker/docker-compose.zeus_db_identity_provider.yml up --build -d
```

---
### 🔹 Solo detener la BD sin eliminar nada (seguro)

```sh
node scripts/stop-db.mjs dev
```
---
### 🔹 Restablecer la configuración sin perder datos

```sh
node scripts/stop-db.mjs dev --reset-config

```
---
### 🔹 Forzar la eliminación de datos y configuración (⚠ PERMANENTE)

```sh
node scripts/stop-db.mjs dev --force

```
---

### 🔹 Acceder a la Base de Datos

```sh
docker exec -it postgres_zeus_db_identity_provider psql -U admin -d zeus_db_identity_provider
```

---

### 🔹 Reiniciar PostgreSQL para Aplicar Cambios

```sh
docker restart postgres_zeus_db_identity_provider
```

---

### 🔹 Ver Logs de la Réplica

```sh
docker logs postgres_zeus_db_identity_provider_replica
```

--- 

### 🔹 Backup del volumen

```sh
node scripts/backup-volume.mjs dev
```
---
### 🔹 Restaurar volumen

```sh
node scripts/restore-volume.mjs dev
```
Luego, levanta PostgreSQL nuevamente:
```sh
node scripts/start-db.mjs dev

```
--- 

### 🔹 Backup  sql

```sh
node scripts/backup-sql.mjs dev
```
---
## 📌 Notas Importantes

- **PostgreSQL está configurado con replicación** para garantizar redundancia y disponibilidad.
- **El usuario de replicación** se encuentra en `01_create_replication_user.sql` y debe estar correctamente configurado en `pg_hba.conf`.
- **Las configuraciones personalizadas** para PostgreSQL están en `postgresql.conf`, las cuales se cargan al iniciar el servicio.
- **El esquema principal es `idp_identity`**, donde se encuentran las tablas del sistema de identidad.

---

Este documento garantiza que cualquier desarrollador o el **agente de IA** puedan entender la estructura actual y los pasos para trabajar con la base de datos **Zeus DB**. 🚀

