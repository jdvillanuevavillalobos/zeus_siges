# ✅ TODO.md

## Tareas Pendientes

### 🏷️ Infraestructura y Configuración
- [x] **Portabilidad de la BD**  
   - Separación de configuraciones por ambiente usando archivos `.env` dentro de la carpeta `config/` (`.env.dev`, `.env.prod`).  ✅
   - Uso de **Docker Compose** para cargar configuraciones dinámicas mediante `docker-compose.zeus_db_identity_provider.yml`.  ✅
   - **✅ Implementación de volúmenes persistentes (`zeus_db_data`) confirmada y en uso.**  
   - Evaluar el uso de **Docker Secrets o Azure Key Vault** en producción para almacenamiento seguro de credenciales. 🔄 (En análisis)
   
- [x] **Scripts Node.js para Control de la BD**  
   - Implementación de `start-db.mjs` y `stop-db.mjs` para manejar la base de datos de manera agnóstica al sistema operativo. ✅
   - Soporte para múltiples entornos configurables con `.env.dev`, `.env.test` y `.env.prod`. ✅
   
- [ ] **Manejo de Cuentas y Seguridad**  
   - Creación de roles seguros en PostgreSQL (`read_user`, `write_user`, `app_admin`). 🔄
   - Validación de permisos en `pg_hba.conf` para restringir accesos no autorizados. 🔄
   
- [ ] **Automatización y CI/CD**  
   - Validación automática de migraciones con **GitHub Actions** o **GitLab CI/CD**. 🔄
   - Implementación de pruebas automatizadas para validar integridad de datos en cada despliegue. 🔄

### 🌜 Base de Datos
- [ ] Normalizar los esquemas y revisar claves primarias en las tablas. 🔄
- [ ] Agregar índices para mejorar el rendimiento en consultas frecuentes. 🔄
- [ ] Implementar un mecanismo de respaldo automático para `zeus_db_identity_provider`. 🔄
- [ ] Revisar y optimizar `setup_replica.sh` para mejorar compatibilidad y desempeño. 🔄

### 🔄 Docker y Orquestación
- [x] Optimizar `Dockerfile` para reducir el tamaño de la imagen. ✅
- [x] Mejorar la seguridad del contenedor PostgreSQL con configuraciones avanzadas. ✅
- [x] Incluir configuración avanzada de volúmenes y logs en `docker-compose.zeus_db_identity_provider.yml`. ✅

### 📚 Documentación
- [x] Agregar más ejemplos en `README.md` para el uso de la base de datos en distintos entornos. ✅
- [x] Crear una guía de buenas prácticas para futuras migraciones y cambios estructurales. ✅
- [ ] Incluir detalles sobre monitoreo de la replicación en PostgreSQL. 🔄

### 🚀 Próximos Pasos
- [ ] Implementar una estrategia de escalabilidad para PostgreSQL utilizando `pgpool` o `patroni`. 🔄
- [ ] Automatizar la validación de integridad de datos en cada despliegue con scripts personalizados. 🔄
- [ ] Investigar mejoras en performance para la replicación de datos y reducción de latencia. 🔄

---

🔔 **Nota:** Esta lista de tareas se actualizará conforme avancemos en el desarrollo.

