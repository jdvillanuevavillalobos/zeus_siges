# 🚀 Proyecto de Identity Provider (IdP)

## 💚️ **Fortalezas y Funcionalidades de Nuestra Arquitectura IDP**

---

## 🚀 **1. Gestión de Identidad de Usuarios**

### ✅ **Usuarios y Cuentas**
- ✨ **Registro y Gestión de Usuarios**: Creación, actualización, eliminación y recuperación de cuentas.
- ✨ **Identidades Federadas (SSO - Single Sign-On)**: Integración con Google, Microsoft, GitHub, Apple, Facebook, LinkedIn, Twitter y otros.
- ✨ **Soporte para Cuentas de Servicio**: Cuentas dedicadas para integraciones de sistemas internos y aplicaciones.

---

## 🚀 **2. Seguridad y Autenticación de Alto Nivel**

### ✅ **Mecanismos de Autenticación y Seguridad**
- 🛡️ **Autenticación en 2 Factores (2FA / MFA - Multi-Factor Authentication)**:
  - Soporte para TOTP (Google Authenticator, Authy).
  - WebAuthn (FIDO2) con autenticación biométrica o llave de seguridad.
- 🛡️ **Gestión Segura de Contraseñas**: Políticas avanzadas de contraseñas con requisitos personalizados.
- 🛡️ **Protección contra Ataques de Fuerza Bruta**:
  - Control de intentos fallidos con `failed_login_attempts`.
  - Bloqueo automático de cuentas (`user_lockout_log`).
- 🛡️ **Control de Sesiones Avanzado**:
  - Modo de sesión configurable (`session_mode` para sesiones únicas o múltiples).
  - Revocación remota de sesiones (`is_revoked`).
  - Historial de sesiones (`session_history`).
- 🛡️ **Autenticación Adaptativa**: Detección de accesos inusuales con `auth_log` (nueva IP, nuevo dispositivo, múltiples sesiones simultáneas).
- 🛡️ **Dispositivos Confiables**: Registro y gestión de dispositivos de confianza con `trusted_device`.

---

## 🚀 **3. Gestión de Permisos y Acceso**

### ✅ **Roles, Permisos y Accesos**
- ✨ **Roles y Permisos Dinámicos** (`role`, `permission`, `role_permission`, `user_permission`).
- ✨ **Gestión de Grupos** (`group`, `group_role`, `group_application_role`): Asignación masiva de permisos y roles.
- ✨ **Reglas de Acceso Personalizadas** (`user_access_rules`):
  - Control de acceso basado en IP, ubicación, dispositivo, horario, y más.
- ✨ **Gobierno Centralizado del Menú de Aplicaciones**:
  - Control de acceso a opciones del menú según roles y permisos.

---

## 🚀 **4. Administración de Aplicaciones y OAuth 2.0**

### ✅ **Gestión de Aplicaciones y Tokens**
- 🔑 **Registro de Aplicaciones Externas** (`application`): Control total sobre las aplicaciones que consumen el IdP.
- 🔑 **Autenticación OAuth 2.0 y OpenID Connect**:
  - Generación de tokens seguros (`api_access_tokens`).
  - Soporte para `ACCESS`, `REFRESH` y `SERVICE` tokens.
- 🔑 **Asignación de Roles a Aplicaciones** (`application_role`, `user_application_role`).
- 🔑 **Integraciones Internas y Externas con Tokens de Servicio** (`api_access_tokens`).

---

## 🚀 **5. Auditoría, Monitoreo y Cumplimiento**

### ✅ **Registros y Monitoreo de Seguridad**
- 🔧 **Registro de Eventos de Seguridad** (`security_events`): Monitoreo en tiempo real de intentos sospechosos o ataques.
- 🔧 **Registro de Actividades Críticas** (`audit_log`): Seguimiento de accesos, cambios en cuentas y configuraciones sensibles.
- 🔧 **Alertas de Seguridad en Tiempo Real** (`session_alerts`): Notificaciones de accesos inusuales, intentos fallidos, cambios de contraseña sospechosos, etc.
- 🔧 **Reporte de Autenticaciones y Análisis de Seguridad** (`auth_metrics`, `session_insights`).

---

## 🚀 **6. Escalabilidad, Modularidad y Soporte para Microservicios**

### ✅ **Arquitectura Optimizada**
- ✨ **Esquemas Aislados** (`idp_identity`, `idp_authentication`, `idp_authorization`, `idp_application`, `idp_audit`, `idp_reporting`), permitiendo migraciones y bases de datos distribuidas.
- ✨ **ULID en Lugar de UUID**: IDs optimizados para ordenamiento eficiente y mejor rendimiento en bases de datos grandes.
- ✨ **Índices Optimizados** para mejorar la velocidad en búsquedas y autenticaciones masivas.
- ✨ **Gestión de Logs con Granularidad**: Permite auditoría detallada y cumplimiento con normativas como **GDPR, ISO 27001 y SOC 2**.

---

## 💪️ **🏆 Líder en Identity Providers: Superando a la Competencia**

### ✅ **Ventajas Competitivas**
- 🌟 **Mejor que Okta, Auth0 y Azure AD**: Implementamos funciones avanzadas de seguridad, control de acceso granular y auditoría en tiempo real.
- 🌟 **Autenticación Modular y Extensible**: Permite integraciones con cualquier tipo de aplicación (web, móvil, microservicios, APIs).
- 🌟 **Cumplimiento y Seguridad al Nivel Empresarial**: Soporte para **MFA, WebAuthn, OAuth 2.0, OpenID Connect, auditoría en tiempo real y detección de anomalías**.
- 🌟 **Flexibilidad Total**: Permite adaptación a entornos multiempresa, gestión de múltiples aplicaciones y escalabilidad con bases de datos separadas por módulos.

---

🔥 **Con esta arquitectura, no solo igualamos a los principales Identity Providers del mercado, sino que los superamos con un modelo de seguridad, escalabilidad y control sin precedentes.** 🚀



## 📌 Situación Actual

El proyecto ha sido diseñado para gestionar la autenticación, autorización y auditoría de usuarios en un entorno modular y escalable. Para ello, hemos definido múltiples esquemas con tablas organizadas por procesos específicos:

### **Esquema `idp_identity` (Usuarios y Credenciales)**
- **user** → Información de los usuarios registrados.
- **user_security** → Credenciales y configuraciones de seguridad.
- **user_webauthn** → Gestión de claves FIDO2/WebAuthn.
- **user_federated_identity** → Identidades federadas (OAuth, SAML, etc.).
- **user_backup_codes** → Códigos de respaldo para autenticación 2FA.
- **user_lockout_log** → Bloqueos de cuenta por intentos fallidos.
- **user_security_log** → Historial de cambios en credenciales.
- **user_recovery** → Recuperación de cuentas (reset de contraseña, validaciones).

### **Esquema `idp_authentication` (Sesiones y Seguridad)**
- **user_session** → Gestión de sesiones activas.
- **session_history** → Historial de sesiones.
- **session_alerts** → Alertas de seguridad relacionadas con sesiones.
- **trusted_device** → Dispositivos confiables registrados.
- **auth_log** → Registro de intentos de autenticación.
- **password_policy** → Definición de políticas de contraseñas.
- **api_access_tokens** → Gestión de tokens de acceso para APIs.

### **Esquema `idp_authorization` (Roles y Permisos)**
- **role** → Definición de roles en el sistema.
- **permission** → Lista de permisos específicos.
- **role_permission** → Relación entre roles y permisos.
- **user_permission** → Permisos individuales asignados a usuarios.
- **group** → Definición de grupos de usuarios.
- **group_role** → Relación entre grupos y roles.
- **user_access_rules** → Reglas de acceso personalizadas por usuario.

### **Esquema `idp_application` (Gestión de Aplicaciones)**
- **application** → Registro de aplicaciones en el IdP.
- **application_role** → Roles específicos por aplicación.
- **user_application_role** → Relación usuario-roles en aplicaciones.
- **group_application_role** → Relación grupo-roles en aplicaciones.

### **Esquema `idp_audit` (Auditoría y Seguridad)**
- **audit_log** → Registro de eventos críticos en el sistema.
- **security_events** → Registro de eventos sospechosos o riesgosos.

### **Esquema `idp_reporting` (Métricas y Estadísticas)**
- **auth_metrics** → Estadísticas de autenticaciones exitosas y fallidas.
- **session_insights** → Información detallada de sesiones activas.

---


📌 🚀 Fortalezas de Nuestra Arquitectura
✅ Usuarios y Autenticación
✔ Gestión optimizada de usuarios: La tabla user cuenta con auditoría completa, control de estado (is_active) y atributos clave como email y username, asegurando unicidad y consistencia.
✔ Separación de credenciales: La tabla user_security maneja credenciales de forma segura sin exponerlas en user, alineándose con las mejores prácticas de seguridad.

✅ Seguridad y Autenticación Avanzada
✔ Almacenamiento seguro de contraseñas: Uso de password_hash + password_salt, implementando los estándares más altos de encriptación.
✔ Autenticación en dos factores (2FA): Soporte para TOTP (Google Authenticator, Authy) mediante two_factor_enabled y two_factor_secret.
✔ Control avanzado de sesiones: session_mode permite configurar sesiones únicas o múltiples activas, similar a sistemas líderes como Okta y Azure AD.
✔ Protección contra ataques de fuerza bruta: failed_login_attempts y account_locked_until limitan intentos fallidos y bloquean cuentas temporalmente.
✔ Revocación remota de sesiones: is_revoked permite cerrar sesiones activas desde cualquier dispositivo, mejorando la seguridad.

✅ Gestión de Recuperación y Seguridad
✔ Registro detallado de intentos de autenticación: La tabla auth_log almacena IPs, agentes de usuario y métodos de autenticación.
✔ Recuperación de cuenta segura: user_recovery gestiona verificaciones de email y restablecimiento de contraseña con tokens de expiración.
✔ Registro de cambios en credenciales: user_security_log monitorea modificaciones sospechosas y cambios críticos en cuentas.
✔ Dispositivos confiables y control de acceso: trusted_device permite registrar equipos confiables para mejorar seguridad sin afectar la experiencia del usuario.

✅ Auditoría y Trazabilidad Completa
✔ Auditoría estandarizada: Todas las tablas incluyen campos de control (record_status, created_at, created_by, etc.) garantizando trazabilidad.
✔ Trazabilidad de transacciones: transaction_id en todas las tablas permite reconstrucción detallada de eventos y operaciones.

✅ Escalabilidad y Alto Rendimiento
✔ ULID en lugar de UUID: Mejora el rendimiento en bases de datos grandes y optimiza el ordenamiento de registros.
✔ Índices optimizados: idx_user_status, idx_auth_log_ip, idx_session_alerts_type, entre otros, mejoran la velocidad de consultas críticas.
✔ Diseño modular y extensible: Claves foráneas (FK) definidas con ALTER TABLE, permitiendo flexibilidad en arquitecturas escalables.


# 📌 Proximos pasos: NUEVAS TABLAS Y MODIFICACIONES

## **🔹 1️⃣ En `idp_authorization` (Control de Accesos y Políticas Dinámicas)**

| **Tabla**                        | **Estado**  | **Función**  |
|-----------------------------------|------------|--------------|
| `role`                           | ✅ Nueva   | Define roles dentro del sistema. |
| `permission`                     | ✅ Nueva   | Lista de permisos específicos asignables. |
| `role_permission`                 | ✅ Nueva   | Relación entre roles y permisos. |
| `user_permission`                 | ✅ Nueva   | Relación entre usuarios y permisos individuales. |
| `group`                          | ✅ Nueva   | Grupos de usuarios para asignaciones masivas. |
| `group_role`                      | ✅ Nueva   | Asignación de roles a grupos. |
| `dynamic_access_policies`         | ✅ Nueva   | Políticas dinámicas basadas en reglas de negocio (Ejemplo: Acceso solo desde ciertos países). |
| `time_restricted_roles`           | ✅ Nueva   | Roles con validez temporal (Ejemplo: Acceso solo de 8 AM a 5 PM). |

---

## **🔹 2️⃣ En `idp_application` (Gestión de Aplicaciones y Marketplace)**

| **Tabla**                        | **Estado**  | **Función**  |
|-----------------------------------|------------|--------------|
| `application`                     | ✅ Nueva   | Registro de aplicaciones en el IdP. |
| `application_role`                 | ✅ Nueva   | Roles específicos de cada aplicación. |
| `user_application_role`            | ✅ Nueva   | Relación entre usuarios y roles de aplicaciones. |
| `group_application_role`           | ✅ Nueva   | Relación entre grupos y roles de aplicaciones. |
| `application_permissions`         | ✅ Nueva   | Permisos específicos dentro de cada aplicación (más granular que los roles). |
| `application_api_keys`             | ✅ Nueva   | Soporte para API Keys en vez de OAuth2. |

---

## **🔹 3️⃣ En `idp_audit` (Monitoreo, Seguridad y AI)**

| **Tabla**                        | **Estado**  | **Función**  |
|-----------------------------------|------------|--------------|
| `audit_log`                       | ✅ Nueva   | Registro de eventos importantes en el sistema. |
| `security_events`                  | ✅ Nueva   | Registro de eventos de seguridad (intentos de fraude, ataques, etc.). |
| `risk_score_log`                  | ✅ Nueva   | Algoritmo que califica intentos de login y sesiones con un "nivel de riesgo". |
| `security_incident_log`           | ✅ Nueva   | Detección de fraudes y ataques sospechosos. |

---

## **🔹 4️⃣ En `idp_reporting` (Analítica y Machine Learning)**

| **Tabla**                        | **Estado**  | **Función**  |
|-----------------------------------|------------|--------------|
| `auth_metrics`                    | ✅ Nueva   | Estadísticas sobre autenticaciones exitosas y fallidas. |
| `session_insights`                | ✅ Nueva   | Análisis detallado de sesiones activas. |
| `fraud_predictions`               | ✅ Nueva   | Predicción de intentos de fraude basados en patrones previos. |
| `behavioral_analytics`            | ✅ Nueva   | Análisis de comportamiento del usuario en el sistema. |

---