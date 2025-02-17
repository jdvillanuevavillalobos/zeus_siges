# 📌 CHANGELOG.md

## Zeus DB - Registro de Cambios

### 📅 [2025-02-16] - Última actualización

#### 🔥 Nueva funcionalidad
- Implementación de `docker-compose.zeus_db_identity_provider.yml` para orquestación específica de `zeus_db_identity_provider`.
- Se agregaron scripts de inicialización en `init-scripts/postgresql/`.
- Configuración de `pg_hba.conf` y `postgresql.conf` en `zeus_db_identity_provider`.
- Se añadió `setup_replica.sh` en `replica/` para configurar la replicación.
- **NUEVO:** Implementación de `start-db.mjs` y `stop-db.mjs` en `scripts/` para manejar la base de datos de manera agnóstica al sistema operativo.
- **NUEVO:** Soporte para entornos configurables con `.env.dev`, `.env.test` y `.env.prod`.

#### 🐛 Corrección de errores
- Se ajustó la sintaxis en `02_create_schemas.sql` para evitar errores de ejecución.
- Se corrigió la configuración de PostgreSQL para habilitar la replicación sin conflictos.
- **FIX:** Se corrigió el path de los archivos `.env` para que `docker-compose` los detecte correctamente.

#### 🚀 Mejoras
- Documentación actualizada en `README.md` con nuevos comandos útiles.
- Se mejoró la organización de `migrations/postgresql/zeus_db_identity_provider/` para futuras migraciones.
- **MEJORA:** Se implementó el uso de `env_file` en `docker-compose.zeus_db_identity_provider.yml` para mayor flexibilidad.
- **MEJORA:** Se optimizó la configuración de volúmenes y permisos en `Dockerfile`.

#### 🔄 Cambios en configuración
- Se añadió `.env` y `config.yml` para una configuración más flexible de variables de entorno.
- **ACTUALIZACIÓN:** Se eliminó `config.yml` ya que la configuración ahora es manejada exclusivamente mediante archivos `.env`.
- **ACTUALIZACIÓN:** Se ajustó `docker-compose.override.yml` para no sobreescribir manualmente variables de entorno.

---

Este registro de cambios asegura que la evolución de **Zeus DB** sea clara y documentada correctamente. 🚀

