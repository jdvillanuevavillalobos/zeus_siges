-- ==========================================================
-- 📌 Creación de las tablas y funciones para el esquema `idp_identity`
-- ==========================================================

-- 📌 Asegurar que la extensión pgcrypto esté instalada para generar aleatoriedad
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- 📌 Crear función para generar ULID x esquema
CREATE OR REPLACE FUNCTION idp_identity.generate_ulid()
RETURNS VARCHAR(26) AS $$
DECLARE
    timestamp_part TEXT;
    random_part TEXT;
    ulid TEXT;
BEGIN
    -- 🕒 Obtener el timestamp en milisegundos
    timestamp_part := lpad(to_hex((EXTRACT(EPOCH FROM clock_timestamp()) * 1000)::bigint), 12, '0');
    
    -- 🎲 Generar la parte aleatoria de 10 bytes y convertir a hex
    random_part := encode(gen_random_bytes(10), 'hex');

    -- 🔄 Concatenar timestamp + random para formar ULID
    ulid := upper(timestamp_part || random_part);

    -- 📏 Asegurar que ULID tenga exactamente 26 caracteres (Base32 ULID usa 26)
    RETURN LEFT(ulid, 26);
END;
$$ LANGUAGE plpgsql;

---
CREATE OR REPLACE FUNCTION idp_authentication.generate_ulid()
RETURNS VARCHAR(26) AS $$
DECLARE
    timestamp_part TEXT;
    random_part TEXT;
    ulid TEXT;
BEGIN
    -- 🕒 Obtener el timestamp en milisegundos
    timestamp_part := lpad(to_hex((EXTRACT(EPOCH FROM clock_timestamp()) * 1000)::bigint), 12, '0');
    
    -- 🎲 Generar la parte aleatoria de 10 bytes y convertir a hex
    random_part := encode(gen_random_bytes(10), 'hex');

    -- 🔄 Concatenar timestamp + random para formar ULID
    ulid := upper(timestamp_part || random_part);

    -- 📏 Asegurar que ULID tenga exactamente 26 caracteres (Base32 ULID usa 26)
    RETURN LEFT(ulid, 26);
END;
$$ LANGUAGE plpgsql;
---
CREATE OR REPLACE FUNCTION idp_authorization.generate_ulid()
RETURNS VARCHAR(26) AS $$
DECLARE
    timestamp_part TEXT;
    random_part TEXT;
    ulid TEXT;
BEGIN
    -- 🕒 Obtener el timestamp en milisegundos
    timestamp_part := lpad(to_hex((EXTRACT(EPOCH FROM clock_timestamp()) * 1000)::bigint), 12, '0');
    
    -- 🎲 Generar la parte aleatoria de 10 bytes y convertir a hex
    random_part := encode(gen_random_bytes(10), 'hex');

    -- 🔄 Concatenar timestamp + random para formar ULID
    ulid := upper(timestamp_part || random_part);

    -- 📏 Asegurar que ULID tenga exactamente 26 caracteres (Base32 ULID usa 26)
    RETURN LEFT(ulid, 26);
END;
$$ LANGUAGE plpgsql;
---
CREATE OR REPLACE FUNCTION idp_application.generate_ulid()
RETURNS VARCHAR(26) AS $$
DECLARE
    timestamp_part TEXT;
    random_part TEXT;
    ulid TEXT;
BEGIN
    -- 🕒 Obtener el timestamp en milisegundos
    timestamp_part := lpad(to_hex((EXTRACT(EPOCH FROM clock_timestamp()) * 1000)::bigint), 12, '0');
    
    -- 🎲 Generar la parte aleatoria de 10 bytes y convertir a hex
    random_part := encode(gen_random_bytes(10), 'hex');

    -- 🔄 Concatenar timestamp + random para formar ULID
    ulid := upper(timestamp_part || random_part);

    -- 📏 Asegurar que ULID tenga exactamente 26 caracteres (Base32 ULID usa 26)
    RETURN LEFT(ulid, 26);
END;
$$ LANGUAGE plpgsql;
---
CREATE OR REPLACE FUNCTION idp_audit.generate_ulid()
RETURNS VARCHAR(26) AS $$
DECLARE
    timestamp_part TEXT;
    random_part TEXT;
    ulid TEXT;
BEGIN
    -- 🕒 Obtener el timestamp en milisegundos
    timestamp_part := lpad(to_hex((EXTRACT(EPOCH FROM clock_timestamp()) * 1000)::bigint), 12, '0');
    
    -- 🎲 Generar la parte aleatoria de 10 bytes y convertir a hex
    random_part := encode(gen_random_bytes(10), 'hex');

    -- 🔄 Concatenar timestamp + random para formar ULID
    ulid := upper(timestamp_part || random_part);

    -- 📏 Asegurar que ULID tenga exactamente 26 caracteres (Base32 ULID usa 26)
    RETURN LEFT(ulid, 26);
END;
$$ LANGUAGE plpgsql;
---
CREATE OR REPLACE FUNCTION idp_reporting.generate_ulid()
RETURNS VARCHAR(26) AS $$
DECLARE
    timestamp_part TEXT;
    random_part TEXT;
    ulid TEXT;
BEGIN
    -- 🕒 Obtener el timestamp en milisegundos
    timestamp_part := lpad(to_hex((EXTRACT(EPOCH FROM clock_timestamp()) * 1000)::bigint), 12, '0');
    
    -- 🎲 Generar la parte aleatoria de 10 bytes y convertir a hex
    random_part := encode(gen_random_bytes(10), 'hex');

    -- 🔄 Concatenar timestamp + random para formar ULID
    ulid := upper(timestamp_part || random_part);

    -- 📏 Asegurar que ULID tenga exactamente 26 caracteres (Base32 ULID usa 26)
    RETURN LEFT(ulid, 26);
END;
$$ LANGUAGE plpgsql;

-- 📌 Tabla de aplicaciones
CREATE TABLE IF NOT EXISTS idp_application.application (
    application_id VARCHAR(26) PRIMARY KEY DEFAULT idp_application.generate_ulid(), -- Identificador único de la aplicación (ULID)

    -- 📌 Auditoría
    record_status VARCHAR(3) DEFAULT 'ACT' NOT NULL CHECK (record_status IN ('ACT', 'DEL')), -- Estado del registro (ACT=Activo, DEL=Eliminado)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL, -- Fecha de creación del registro
    created_by VARCHAR(128) NOT NULL, -- Usuario que creó el registro
    updated_at TIMESTAMP, -- Última fecha de actualización
    updated_by VARCHAR(128), -- Usuario que realizó la última modificación
    deleted_at TIMESTAMP, -- Fecha de eliminación del registro (soft delete)
    deleted_by VARCHAR(128), -- Usuario que eliminó el registro
    transaction_id VARCHAR(64), -- ID de la transacción asociada (para trazabilidad)

    -- 📌 Datos de la aplicación
    name VARCHAR(255) NOT NULL, -- Nombre de la aplicación
    description TEXT, -- Descripción opcional de la aplicación
    client_id VARCHAR(32) UNIQUE NOT NULL, -- Identificador único para OAuth2
    client_secret TEXT NOT NULL, -- Secreto de autenticación (⚠ Almacenado cifrado)
    redirect_uri TEXT NOT NULL, -- URI de redirección permitida para OAuth2
    token_lifetime INT DEFAULT 3600, -- Tiempo de vida del token en segundos (1 hora por defecto)
    refresh_token_lifetime INT DEFAULT 604800, -- Tiempo de vida del refresh token (7 días por defecto)
    allow_refresh_token BOOLEAN DEFAULT TRUE, -- Indica si la app puede usar refresh tokens
    status SMALLINT DEFAULT 1 CHECK (status IN (0,1)) -- Indica si la aplicación está activa (1=Sí, 0=No)
);

-- 📌 Restricciones y optimización de índices
ALTER TABLE idp_application.application ADD CONSTRAINT uq_application_name UNIQUE (name); -- Restricción de unicidad para el nombre de la aplicación
ALTER TABLE idp_application.application ADD CONSTRAINT uq_application_client_id UNIQUE (client_id); -- Restricción de unicidad para client_id
CREATE INDEX idx_application_status ON idp_application.application(record_status, status); -- Índice para búsquedas rápidas por estado y actividad de la aplicación


-- 📌 Tabla de usuarios
CREATE TABLE IF NOT EXISTS idp_identity.user (
    user_id VARCHAR(26) PRIMARY KEY DEFAULT idp_identity.generate_ulid(), -- Identificador único del usuario (ULID)

    -- 📌 Auditoría
    record_status VARCHAR(3) DEFAULT 'ACT' NOT NULL CHECK (record_status IN ('ACT', 'DEL')), -- Estado del registro (ACT=Activo, DEL=Eliminado)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL, -- Fecha de creación del usuario
    created_by VARCHAR(128) NOT NULL, -- Usuario que creó el registro
    updated_at TIMESTAMP, -- Fecha de la última actualización
    updated_by VARCHAR(128), -- Usuario que realizó la última modificación
    deleted_at TIMESTAMP, -- Fecha de eliminación del usuario
    deleted_by VARCHAR(128), -- Usuario que eliminó el registro
    transaction_id VARCHAR(64), -- ID de la transacción asociada (para trazabilidad)

    -- 📌 Datos del usuario
    username VARCHAR(50) NOT NULL, -- Nombre de usuario único en el sistema
    email VARCHAR(100) NOT NULL, -- Dirección de correo electrónico única del usuario
    is_active SMALLINT DEFAULT 1 CHECK (is_active IN (0,1)) -- Indica si el usuario está activo (1=Sí, 0=No)
);
-- 📌 Restricciones y optimización de índices
ALTER TABLE idp_identity.user ADD CONSTRAINT uq_user_username UNIQUE (username); -- Restricción de unicidad para el nombre de usuario
ALTER TABLE idp_identity.user ADD CONSTRAINT uq_user_email UNIQUE (email); -- Restricción de unicidad para el correo electrónico
CREATE INDEX idx_user_status ON idp_identity.user(record_status, is_active); -- Índice para búsquedas rápidas por estado y actividad del usuario



-- 📌 Tabla de credenciales de usuario (solo autenticación)
CREATE TABLE IF NOT EXISTS idp_identity.user_security (
    user_security_id VARCHAR(26) PRIMARY KEY DEFAULT idp_identity.generate_ulid(), -- Identificador único de credenciales (ULID)

    -- 📌 Auditoría
    record_status VARCHAR(3) DEFAULT 'ACT' NOT NULL CHECK (record_status IN ('ACT', 'DEL')), -- Estado del registro (ACT=Activo, DEL=Eliminado)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL, -- Fecha de creación del registro
    created_by VARCHAR(128) NOT NULL, -- Usuario que creó el registro
    updated_at TIMESTAMP, -- Fecha de la última modificación del registro
    updated_by VARCHAR(128), -- Usuario que realizó la última modificación
    deleted_at TIMESTAMP, -- Fecha de eliminación del registro
    deleted_by VARCHAR(128), -- Usuario que eliminó el registro
    transaction_id VARCHAR(64), -- ID de la transacción asociada (para trazabilidad)

    -- 📌 Credenciales de autenticación
    user_id VARCHAR(26) NOT NULL, -- Identificador del usuario asociado
    password_hash BYTEA NOT NULL, -- Hash de la contraseña del usuario
    password_salt BYTEA, -- Salt utilizado para el hashing de la contraseña (opcional)
    last_password_change TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL, -- Última vez que el usuario cambió la contraseña

    -- 📌 Seguridad adicional
    two_factor_enabled SMALLINT DEFAULT 0 CHECK (two_factor_enabled IN (0,1)), -- Indica si el usuario tiene 2FA activado (0=No, 1=Sí)
    two_factor_secret TEXT, -- Secreto utilizado para generar códigos OTP en 2FA
    session_mode SMALLINT DEFAULT 1 CHECK (session_mode IN (0,1)), -- Modo de sesión (0 = Una sola sesión, 1 = Múltiples sesiones permitidas)
    failed_logins_threshold SMALLINT DEFAULT 5 CHECK (failed_logins_threshold >= 1), -- Máximo de intentos fallidos antes de bloqueo
    force_password_change SMALLINT DEFAULT 0 CHECK (force_password_change IN (0,1)), -- Indica si el usuario debe cambiar la contraseña al iniciar sesión
    mfa_type VARCHAR(20) CHECK (mfa_type IN ('SMS', 'TOTP', 'HARDWARE', 'NONE')), -- Método de 2FA seleccionado por el usuario
    password_expiration_days SMALLINT DEFAULT 90 CHECK (password_expiration_days >= 30) -- Días antes de que la contraseña expire y requiera cambio
);
-- 📌 Claves foráneas y restricciones
ALTER TABLE idp_identity.user_security ADD CONSTRAINT fk_user_security_user 
FOREIGN KEY (user_id) REFERENCES idp_identity.user(user_id) ON DELETE CASCADE; -- Relación con la tabla de usuarios



-- 📌 Registro de Identidades Federadas de Usuario
CREATE TABLE IF NOT EXISTS idp_identity.user_federated_identity (
    federated_id VARCHAR(26) PRIMARY KEY DEFAULT idp_identity.generate_ulid(), -- Identificador único de la identidad federada (ULID)

    -- 📌 Auditoría
    record_status VARCHAR(3) DEFAULT 'ACT' NOT NULL CHECK (record_status IN ('ACT', 'DEL')), -- Estado del registro (ACT=Activo, DEL=Eliminado)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL, -- Fecha de creación del registro
    created_by VARCHAR(128) NOT NULL, -- Usuario o sistema que registró la identidad federada
    updated_at TIMESTAMP, -- Fecha de la última modificación del registro
    updated_by VARCHAR(128), -- Usuario que realizó la última modificación
    deleted_at TIMESTAMP, -- Fecha de eliminación del registro
    deleted_by VARCHAR(128), -- Usuario que eliminó el registro
    transaction_id VARCHAR(64), -- ID de la transacción asociada (para trazabilidad)

    -- 📌 Datos de identidad federada
    user_id VARCHAR(26) NOT NULL, -- Identificador del usuario asociado a la identidad federada
    provider VARCHAR(50) NOT NULL CHECK (provider IN ('GOOGLE', 'MICROSOFT', 'GITHUB', 'APPLE', 'FACEBOOK', 'LINKEDIN', 'TWITTER', 'CUSTOM')), -- Proveedor de identidad
    provider_user_id VARCHAR(255) NOT NULL, -- Identificador único del usuario en el proveedor de identidad
    provider_email VARCHAR(255), -- Correo electrónico registrado con el proveedor
    provider_display_name VARCHAR(255), -- Nombre de usuario según el proveedor
    last_login_at TIMESTAMP, -- Última vez que se autenticó con este proveedor
    access_token TEXT, -- Token de acceso proporcionado por el proveedor (opcional)
    refresh_token TEXT, -- Token de actualización (si aplica)
    expires_at TIMESTAMP -- Fecha de expiración del token de acceso (si aplica)
);
-- 📌 Claves foráneas y restricciones
ALTER TABLE idp_identity.user_federated_identity ADD CONSTRAINT fk_federated_identity_user 
FOREIGN KEY (user_id) REFERENCES idp_identity.user(user_id) ON DELETE CASCADE; -- Relación con la tabla de usuarios
-- 📌 Índices optimizados
CREATE INDEX idx_federated_identity_user ON idp_identity.user_federated_identity(user_id);
CREATE INDEX idx_federated_identity_provider ON idp_identity.user_federated_identity(provider);
CREATE INDEX idx_federated_identity_provider_user ON idp_identity.user_federated_identity(provider_user_id);




-- 📌 Registro de bloqueos de cuenta
CREATE TABLE IF NOT EXISTS idp_identity.user_lockout_log (
    lockout_id VARCHAR(26) PRIMARY KEY DEFAULT idp_identity.generate_ulid(), -- Identificador único del bloqueo de cuenta (ULID)

    -- 📌 Auditoría
    record_status VARCHAR(3) DEFAULT 'ACT' NOT NULL CHECK (record_status IN ('ACT', 'DEL')), -- Estado del registro (ACT=Activo, DEL=Eliminado)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL, -- Fecha de creación del registro
    created_by VARCHAR(128) NOT NULL, -- Usuario o sistema que generó el bloqueo
    updated_at TIMESTAMP, -- Fecha de la última modificación del registro
    updated_by VARCHAR(128), -- Usuario que realizó la última modificación
    deleted_at TIMESTAMP, -- Fecha de eliminación del registro
    deleted_by VARCHAR(128), -- Usuario que eliminó el registro
    transaction_id VARCHAR(64), -- ID de la transacción asociada (para trazabilidad)

    -- 📌 Datos del bloqueo
    user_id VARCHAR(26) NOT NULL, -- Identificador del usuario afectado
    locked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL, -- Fecha y hora en que se bloqueó la cuenta
    unlocked_at TIMESTAMP, -- Fecha y hora en que se desbloqueó la cuenta (si aplica)
    lock_reason TEXT NOT NULL, -- Razón del bloqueo (Ejemplo: "Intentos fallidos excesivos", "Acceso sospechoso", etc.)
    is_permanent SMALLINT DEFAULT 0 CHECK (is_permanent IN (0,1)), -- Indica si el bloqueo es permanente (1 = Sí, 0 = No)
    failed_attempts SMALLINT DEFAULT 0 CHECK (failed_attempts >= 0) -- Número de intentos fallidos que causaron el bloqueo
);
-- 📌 Claves foráneas y restricciones
ALTER TABLE idp_identity.user_lockout_log ADD CONSTRAINT fk_user_lockout_user 
FOREIGN KEY (user_id) REFERENCES idp_identity.user(user_id) ON DELETE CASCADE; -- Relación con la tabla de usuarios
-- 📌 Índices optimizados
CREATE INDEX idx_user_lockout_user ON idp_identity.user_lockout_log(user_id);
CREATE INDEX idx_user_lockout_status ON idp_identity.user_lockout_log(is_permanent);
CREATE INDEX idx_user_lockout_locked_at ON idp_identity.user_lockout_log(locked_at);



-- 📌 Tabla de códigos de respaldo (Backup Codes) para autenticación
CREATE TABLE IF NOT EXISTS idp_identity.user_backup_codes (
    user_backup_code_id VARCHAR(26) PRIMARY KEY DEFAULT idp_identity.generate_ulid(), -- Identificador único del código de respaldo (ULID)

    -- 📌 Auditoría
    record_status VARCHAR(3) DEFAULT 'ACT' NOT NULL CHECK (record_status IN ('ACT', 'DEL')), -- Estado del registro (ACT=Activo, DEL=Eliminado)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL, -- Fecha de generación del código de respaldo
    created_by VARCHAR(128) NOT NULL, -- Usuario o sistema que generó el código
    updated_at TIMESTAMP, -- Fecha de la última modificación del registro
    updated_by VARCHAR(128), -- Usuario o sistema que realizó la última modificación
    deleted_at TIMESTAMP, -- Fecha de eliminación del registro
    deleted_by VARCHAR(128), -- Usuario o sistema que eliminó el código
    transaction_id VARCHAR(64), -- ID de la transacción asociada (para trazabilidad)

    -- 📌 Datos de códigos de respaldo
    user_id VARCHAR(26) NOT NULL, -- Identificador del usuario propietario del código
    backup_code BYTEA NOT NULL UNIQUE, -- Código de respaldo encriptado
    is_used SMALLINT DEFAULT 0 CHECK (is_used IN (0,1)), -- Estado del código (0=Disponible, 1=Usado)
    used_at TIMESTAMP, -- Fecha y hora en que el código fue utilizado (si aplica)
    expires_at TIMESTAMP NOT NULL -- Fecha de expiración del código de respaldo
);
-- 📌 Claves foráneas y restricciones
ALTER TABLE idp_identity.user_backup_codes ADD CONSTRAINT fk_user_backup_codes_user 
FOREIGN KEY (user_id) REFERENCES idp_identity.user(user_id) ON DELETE CASCADE; -- Relación con la tabla de usuarios
-- 📌 Índices optimizados
CREATE INDEX idx_user_backup_codes_status ON idp_identity.user_backup_codes(record_status, is_used);
CREATE INDEX idx_user_backup_codes_user ON idp_identity.user_backup_codes(user_id);
CREATE INDEX idx_user_backup_codes_expires ON idp_identity.user_backup_codes(expires_at);



-- 📌 Tabla de autenticación WebAuthn (FIDO2)
CREATE TABLE IF NOT EXISTS idp_identity.user_webauthn (
    user_webauthn_id VARCHAR(26) PRIMARY KEY DEFAULT idp_identity.generate_ulid(), -- Identificador único de la clave WebAuthn (ULID)

    -- 📌 Auditoría
    record_status VARCHAR(3) DEFAULT 'ACT' NOT NULL CHECK (record_status IN ('ACT', 'DEL')), -- Estado del registro (ACT=Activo, DEL=Eliminado)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL, -- Fecha de creación del registro
    created_by VARCHAR(128) NOT NULL, -- Usuario o sistema que creó el registro
    updated_at TIMESTAMP, -- Fecha de la última modificación del registro
    updated_by VARCHAR(128), -- Usuario o sistema que realizó la última modificación
    deleted_at TIMESTAMP, -- Fecha de eliminación del registro
    deleted_by VARCHAR(128), -- Usuario o sistema que eliminó el registro
    transaction_id VARCHAR(64), -- ID de la transacción asociada (para trazabilidad)

    -- 📌 Datos de autenticación WebAuthn
    user_id VARCHAR(26) NOT NULL, -- Identificador del usuario propietario de la clave
    credential_id BYTEA NOT NULL UNIQUE, -- Identificador único de la credencial WebAuthn
    public_key BYTEA NOT NULL, -- Clave pública del dispositivo de autenticación
    attestation_format VARCHAR(50) NOT NULL, -- Formato de atestación (Ejemplo: "packed", "fido-u2f", "none")
    transports VARCHAR(100), -- Métodos de transporte permitidos (Ejemplo: "usb,nfc,ble,internal")
    sign_count BIGINT DEFAULT 0, -- Contador de firmas para prevenir reutilización de credenciales clonadas
    last_used_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL, -- Última vez que la credencial fue utilizada
    is_active SMALLINT DEFAULT 1 CHECK (is_active IN (0,1)) NOT NULL -- Estado de la credencial WebAuthn (1=Activo, 0=Inactivo)
);
-- 📌 Claves foráneas y restricciones
ALTER TABLE idp_identity.user_webauthn ADD CONSTRAINT fk_user_webauthn_user 
FOREIGN KEY (user_id) REFERENCES idp_identity.user(user_id) ON DELETE CASCADE; -- Relación con la tabla de usuarios
-- 📌 Índices optimizados
CREATE INDEX idx_user_webauthn_status ON idp_identity.user_webauthn(record_status, is_active);
CREATE INDEX idx_user_webauthn_user ON idp_identity.user_webauthn(user_id);
CREATE INDEX idx_user_webauthn_last_used ON idp_identity.user_webauthn(last_used_at);




-- 📌 Registro de cambios en credenciales
CREATE TABLE IF NOT EXISTS idp_identity.user_security_log (
    user_security_log_id VARCHAR(26) PRIMARY KEY DEFAULT idp_identity.generate_ulid(), -- Identificador único del cambio en credenciales (ULID)

    -- 📌 Auditoría
    record_status VARCHAR(3) DEFAULT 'ACT' NOT NULL CHECK (record_status IN ('ACT', 'DEL')), -- Estado del registro (ACT=Activo, DEL=Eliminado)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL, -- Fecha de creación del registro
    created_by VARCHAR(128) NOT NULL, -- Usuario que creó el registro
    updated_at TIMESTAMP, -- Fecha de la última modificación del registro
    updated_by VARCHAR(128), -- Usuario que realizó la última modificación
    deleted_at TIMESTAMP, -- Fecha de eliminación del registro
    deleted_by VARCHAR(128), -- Usuario que eliminó el registro
    transaction_id VARCHAR(64), -- ID de la transacción asociada (para trazabilidad)

    -- 📌 Datos de cambios en credenciales
    user_id VARCHAR(26) NOT NULL, -- Identificador del usuario asociado al cambio de credenciales
    change_type VARCHAR(50) NOT NULL CHECK (change_type IN 
        ('PASSWORD_UPDATED', 'PASSWORD_RESET', 'MFA_ENABLED', 'MFA_DISABLED', 'SESSION_MODE_CHANGED', 'ACCOUNT_LOCKED', 'ACCOUNT_UNLOCKED')
    ), -- Tipo de cambio realizado en credenciales
    change_details TEXT, -- Descripción detallada del cambio
    ip_address VARCHAR(45), -- Dirección IP desde donde se realizó el cambio
    user_agent TEXT -- Información del navegador o dispositivo
);
-- 📌 Claves foráneas y restricciones
ALTER TABLE idp_identity.user_security_log ADD CONSTRAINT fk_user_security_log_user 
FOREIGN KEY (user_id) REFERENCES idp_identity.user(user_id) ON DELETE CASCADE; -- Relación con la tabla de usuarios
-- 📌 Índices optimizados
CREATE INDEX idx_user_security_log_user ON idp_identity.user_security_log(user_id); 




-- 📌 Tabla de recuperación de cuenta
CREATE TABLE IF NOT EXISTS idp_identity.user_recovery (
    user_recovery_id VARCHAR(26) PRIMARY KEY DEFAULT idp_identity.generate_ulid(), -- Identificador único para recuperación de cuenta (ULID)

    -- 📌 Auditoría
    record_status VARCHAR(3) DEFAULT 'ACT' NOT NULL CHECK (record_status IN ('ACT', 'DEL')), -- Estado del registro (ACT=Activo, DEL=Eliminado)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL, -- Fecha de creación del registro de recuperación
    created_by VARCHAR(128) NOT NULL, -- Usuario que creó el registro
    updated_at TIMESTAMP, -- Fecha de la última modificación del registro
    updated_by VARCHAR(128), -- Usuario que realizó la última modificación
    deleted_at TIMESTAMP, -- Fecha de eliminación del registro
    deleted_by VARCHAR(128), -- Usuario que eliminó el registro
    transaction_id VARCHAR(64), -- ID de la transacción asociada (para trazabilidad)

    -- 📌 Datos de recuperación de cuenta
    user_id VARCHAR(26) NOT NULL, -- Identificador del usuario asociado
    email_verified SMALLINT DEFAULT 0 CHECK (email_verified IN (0,1)), -- Indica si el email fue verificado (0=No, 1=Sí)
    verification_token VARCHAR(255) UNIQUE, -- Token de verificación de cuenta
    verification_expires_at TIMESTAMP, -- Fecha y hora de expiración del token de verificación
    password_reset_token VARCHAR(255) UNIQUE, -- Token para restablecimiento de contraseña
    password_reset_expires_at TIMESTAMP -- Fecha y hora de expiración del token de restablecimiento de contraseña
);
-- 📌 Claves foráneas y restricciones
ALTER TABLE idp_identity.user_recovery ADD CONSTRAINT fk_user_recovery_user FOREIGN KEY (user_id) REFERENCES idp_identity.user(user_id) ON DELETE CASCADE; -- Relación con la tabla de usuarios



-- 📌 Tabla de sesiones de usuario
CREATE TABLE IF NOT EXISTS idp_authentication.user_session (
    user_session_id VARCHAR(26) PRIMARY KEY DEFAULT idp_authentication.generate_ulid(), -- Identificador único de la sesión (ULID)

    -- 📌 Auditoría
    record_status VARCHAR(3) DEFAULT 'ACT' NOT NULL CHECK (record_status IN ('ACT', 'DEL')), -- Estado del registro (ACT=Activo, DEL=Eliminado)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL, -- Fecha de creación de la sesión
    created_by VARCHAR(128) NOT NULL, -- Usuario que creó el registro
    updated_at TIMESTAMP, -- Fecha de la última modificación de la sesión
    updated_by VARCHAR(128), -- Usuario que realizó la última modificación
    deleted_at TIMESTAMP, -- Fecha de eliminación de la sesión
    deleted_by VARCHAR(128), -- Usuario que eliminó el registro
    transaction_id VARCHAR(64), -- ID de la transacción asociada (para trazabilidad)

    -- 📌 Datos de sesión
    user_id VARCHAR(26) NOT NULL, -- Identificador del usuario asociado a la sesión
    session_name VARCHAR(100), -- Nombre de la sesión (Ejemplo: "Web Login", "Mobile App")
    session_token TEXT UNIQUE NOT NULL, -- Token de sesión único generado para el usuario
    session_status VARCHAR(10) CHECK (session_status IN ('ACTIVE', 'CLOSED', 'REVOKED')) DEFAULT 'ACTIVE' NOT NULL, -- Estado de la sesión (ACTIVA, CERRADA, REVOCADA)
    failed_login_attempts SMALLINT DEFAULT 0 CHECK (failed_login_attempts >= 0), -- Cantidad de intentos fallidos de inicio de sesión
    account_locked_until TIMESTAMP, -- Fecha hasta la cual la cuenta estará bloqueada (si aplica)
    last_login_at TIMESTAMP, -- Fecha y hora del último inicio de sesión exitoso
    last_login_ip VARCHAR(45), -- Dirección IP utilizada en el último inicio de sesión
    expires_at TIMESTAMP, -- Fecha y hora en que la sesión expira
    is_revoked SMALLINT DEFAULT 0 CHECK (is_revoked IN (0,1)), -- Indica si la sesión ha sido revocada (1=Sí, 0=No)
    force_logout SMALLINT DEFAULT 0 CHECK (force_logout IN (0,1)), -- Si está activado, la sesión será terminada forzosamente en el próximo chequeo
    bound_device VARCHAR(255), -- Identificador del dispositivo asociado a la sesión
    session_location VARCHAR(100), -- Información geográfica de la sesión (Ejemplo: "Perú - Lima")
    user_agent TEXT NOT NULL -- Información sobre el navegador/dispositivo desde el cual se inició sesión
);
-- 📌 Índices optimizados para mejorar rendimiento en consultas de sesión
CREATE INDEX idx_user_session_status ON idp_authentication.user_session(session_status);
CREATE INDEX idx_user_session_last_login ON idp_authentication.user_session(last_login_at);
CREATE INDEX idx_user_session_expires ON idp_authentication.user_session(expires_at);
CREATE INDEX idx_user_session_user ON idp_authentication.user_session(user_id);




-- 📌 Registro de intentos de autenticación
CREATE TABLE IF NOT EXISTS idp_authentication.auth_log (
    auth_log_id VARCHAR(26) PRIMARY KEY DEFAULT idp_authentication.generate_ulid(), -- Identificador único del intento de autenticación (ULID)

    -- 📌 Auditoría
    record_status VARCHAR(3) DEFAULT 'ACT' NOT NULL CHECK (record_status IN ('ACT', 'DEL')), -- Estado del registro (ACT=Activo, DEL=Eliminado)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL, -- Fecha de creación del registro
    created_by VARCHAR(128) NOT NULL, -- Usuario o sistema que generó el intento de autenticación
    updated_at TIMESTAMP, -- Fecha de la última modificación del registro
    updated_by VARCHAR(128), -- Usuario o sistema que realizó la última modificación
    deleted_at TIMESTAMP, -- Fecha de eliminación del registro
    deleted_by VARCHAR(128), -- Usuario o sistema que eliminó el registro
    transaction_id VARCHAR(64), -- ID de la transacción asociada (para trazabilidad)

    -- 📌 Datos de intentos de autenticación
    user_id VARCHAR(26) NOT NULL, -- Identificador del usuario asociado al intento de autenticación
    session_id VARCHAR(26), -- Identificador de la sesión (si aplica)
    ip_address VARCHAR(45) NOT NULL, -- Dirección IP desde la cual se realizó el intento de autenticación
    user_agent TEXT NOT NULL, -- Información del navegador o cliente desde donde se intentó la autenticación
    auth_method VARCHAR(20) CHECK (auth_method IN ('PASSWORD', 'TOTP', 'FIDO2', 'OAUTH', 'SSO')) NOT NULL, -- Método de autenticación usado
    auth_status VARCHAR(10) CHECK (auth_status IN ('SUCCESS', 'FAILED', 'BLOCKED')) NOT NULL, -- Estado del intento de autenticación
    failure_reason TEXT, -- Motivo del fallo si `auth_status = FAILED`
    geo_location VARCHAR(100), -- Información geográfica del usuario (Ejemplo: "México - CDMX")
    risk_level VARCHAR(10) CHECK (risk_level IN ('LOW', 'MEDIUM', 'HIGH')) DEFAULT 'LOW' NOT NULL, -- Nivel de riesgo del intento de autenticación
    is_suspicious SMALLINT DEFAULT 0 CHECK (is_suspicious IN (0,1)) -- Indica si el intento fue detectado como sospechoso (1=Sí, 0=No)
);
-- 📌 Claves foráneas y restricciones
ALTER TABLE idp_authentication.auth_log ADD CONSTRAINT fk_auth_log_session 
FOREIGN KEY (session_id) REFERENCES idp_authentication.user_session(user_session_id) ON DELETE SET NULL; -- Relación con la sesión (si existe)
-- 📌 Índices optimizados para mejorar rendimiento en auditoría y seguridad
CREATE INDEX idx_auth_log_user ON idp_authentication.auth_log(user_id);
CREATE INDEX idx_auth_log_session ON idp_authentication.auth_log(session_id);
CREATE INDEX idx_auth_log_ip ON idp_authentication.auth_log(ip_address);
CREATE INDEX idx_auth_log_status ON idp_authentication.auth_log(auth_status);
CREATE INDEX idx_auth_log_risk ON idp_authentication.auth_log(risk_level);



-- 📌 Registro de dispositivos confiables
CREATE TABLE IF NOT EXISTS idp_authentication.trusted_device (
    trusted_device_id VARCHAR(26) PRIMARY KEY DEFAULT idp_authentication.generate_ulid(), -- Identificador único del dispositivo confiable (ULID)

    -- 📌 Auditoría
    record_status VARCHAR(3) DEFAULT 'ACT' NOT NULL CHECK (record_status IN ('ACT', 'DEL')), -- Estado del registro (ACT=Activo, DEL=Eliminado)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL, -- Fecha de creación del registro
    created_by VARCHAR(128) NOT NULL, -- Usuario que creó el registro
    updated_at TIMESTAMP, -- Fecha de la última modificación del registro
    updated_by VARCHAR(128), -- Usuario que realizó la última modificación
    deleted_at TIMESTAMP, -- Fecha de eliminación del registro
    deleted_by VARCHAR(128), -- Usuario que eliminó el registro
    transaction_id VARCHAR(64), -- ID de la transacción asociada (para trazabilidad)

    -- 📌 Datos de dispositivos confiables
    user_id VARCHAR(26) NOT NULL, -- Identificador del usuario al que pertenece el dispositivo
    device_name VARCHAR(255) NOT NULL, -- Nombre del dispositivo registrado (ejemplo: "Laptop personal", "Teléfono móvil")
    device_fingerprint VARCHAR(255) UNIQUE NOT NULL, -- Identificador único del dispositivo generado por la plataforma
    last_used_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL -- Fecha y hora en que el dispositivo fue utilizado por última vez
);
-- 📌 Índices optimizados
CREATE INDEX idx_trusted_device_user ON idp_authentication.trusted_device(user_id);


-- 📌 Historial de sesiones de usuario
CREATE TABLE IF NOT EXISTS idp_authentication.session_history (
    session_history_id VARCHAR(26) PRIMARY KEY DEFAULT idp_authentication.generate_ulid(), -- Identificador único del historial de sesión (ULID)

    -- 📌 Auditoría
    record_status VARCHAR(3) DEFAULT 'ACT' NOT NULL CHECK (record_status IN ('ACT', 'DEL')), -- Estado del registro (ACT=Activo, DEL=Eliminado)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL, -- Fecha de creación del registro
    created_by VARCHAR(128) NOT NULL, -- Usuario que creó el registro
    updated_at TIMESTAMP, -- Fecha de la última modificación
    updated_by VARCHAR(128), -- Usuario que realizó la última modificación
    deleted_at TIMESTAMP, -- Fecha de eliminación del registro
    deleted_by VARCHAR(128), -- Usuario que eliminó el registro
    transaction_id VARCHAR(64), -- ID de la transacción asociada (para trazabilidad)

    -- 📌 Datos de la sesión
    user_id VARCHAR(26) NOT NULL, -- Identificador del usuario asociado
    session_token TEXT NOT NULL, -- Token de sesión del usuario en ese momento
    session_name VARCHAR(100), -- Nombre de la sesión (Ejemplo: "Web Login", "Mobile App")
    session_status VARCHAR(15) CHECK (session_status IN ('ACTIVE', 'CLOSED', 'REVOKED')), -- Estado de la sesión
    login_at TIMESTAMP NOT NULL, -- Fecha y hora en que inició sesión
    logout_at TIMESTAMP, -- Fecha y hora en que cerró sesión (si aplica)
    logout_reason VARCHAR(20) CHECK (logout_reason IN ('EXPIRATION', 'USER_LOGOUT', 'ADMIN_FORCE', 'OTHER')), -- Motivo de cierre de sesión
    revoked_at TIMESTAMP, -- Fecha y hora en que la sesión fue revocada (si aplica)
    ip_address VARCHAR(45) NOT NULL, -- Dirección IP utilizada en la sesión
    user_agent TEXT NOT NULL, -- Información del navegador o cliente desde donde se inició la sesión
    geo_location VARCHAR(150), -- Ubicación geográfica del usuario en la sesión (Ejemplo: "México - CDMX, Lat:19.4326, Lon:-99.1332")
    device_id VARCHAR(255) -- Identificador del dispositivo desde donde se accedió (opcional)
);
-- 📌 Índices optimizados
CREATE INDEX idx_session_history_user ON idp_authentication.session_history(user_id);
CREATE INDEX idx_session_history_status ON idp_authentication.session_history(session_status);
CREATE INDEX idx_session_history_login ON idp_authentication.session_history(login_at);
CREATE INDEX idx_session_history_logout ON idp_authentication.session_history(logout_at);



-- 📌 Alertas de sesión de usuario
CREATE TABLE IF NOT EXISTS idp_authentication.session_alerts (
    session_alert_id VARCHAR(26) PRIMARY KEY DEFAULT idp_authentication.generate_ulid(), -- Identificador único de la alerta de sesión (ULID)

    -- 📌 Auditoría
    record_status VARCHAR(3) DEFAULT 'ACT' NOT NULL CHECK (record_status IN ('ACT', 'DEL')), -- Estado del registro (ACT=Activo, DEL=Eliminado)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL, -- Fecha de creación del registro
    created_by VARCHAR(128) NOT NULL, -- Usuario que creó el registro
    updated_at TIMESTAMP, -- Fecha de la última modificación del registro
    updated_by VARCHAR(128), -- Usuario que realizó la última modificación
    deleted_at TIMESTAMP, -- Fecha de eliminación del registro
    deleted_by VARCHAR(128), -- Usuario que eliminó el registro
    transaction_id VARCHAR(64), -- ID de la transacción asociada (para trazabilidad)

    -- 📌 Datos de la alerta de sesión
    user_id VARCHAR(26) NOT NULL, -- Identificador del usuario asociado a la alerta
    session_id VARCHAR(26) NOT NULL, -- Identificador de la sesión asociada
    alert_type VARCHAR(50) CHECK (alert_type IN ('NEW_IP', 'NEW_DEVICE', 'MULTI_SESSION', 'ACCOUNT_LOCKED', 'PASSWORD_CHANGE', 'UNAUTHORIZED_ACCESS', 'OTHER')), -- Tipo de alerta
    alert_message VARCHAR(500) NOT NULL, -- Mensaje descriptivo de la alerta generada
    alert_status VARCHAR(15) CHECK (alert_status IN ('PENDING', 'VIEWED', 'RESOLVED')), -- Estado de la alerta
    alert_priority VARCHAR(10) CHECK (alert_priority IN ('LOW', 'MEDIUM', 'HIGH', 'CRITICAL')), -- Prioridad de la alerta
    alert_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL, -- Fecha y hora en que se generó la alerta
    alert_resolved_at TIMESTAMP, -- Fecha y hora en que la alerta fue resuelta (si aplica)
    alert_resolved_by VARCHAR(255) -- Usuario o sistema que resolvió la alerta (si aplica)
);
-- 📌 Claves foráneas y restricciones
ALTER TABLE idp_authentication.session_alerts ADD CONSTRAINT fk_session_alerts_session 
FOREIGN KEY (session_id) REFERENCES idp_authentication.user_session(user_session_id) ON DELETE CASCADE;
-- 📌 Índices optimizados
CREATE INDEX idx_session_alerts_user ON idp_authentication.session_alerts(user_id);
CREATE INDEX idx_session_alerts_session ON idp_authentication.session_alerts(session_id);
CREATE INDEX idx_session_alerts_type ON idp_authentication.session_alerts(alert_type);
CREATE INDEX idx_session_alerts_status ON idp_authentication.session_alerts(alert_status);
CREATE INDEX idx_session_alerts_priority ON idp_authentication.session_alerts(alert_priority);
CREATE INDEX idx_session_alerts_timestamp ON idp_authentication.session_alerts(alert_timestamp);




-- 📌 Tabla de política de contraseñas
CREATE TABLE IF NOT EXISTS idp_authentication.password_policy (
    password_policy_id VARCHAR(26) PRIMARY KEY DEFAULT idp_authentication.generate_ulid(), -- Identificador único de la política de contraseñas (ULID)

    -- 📌 Auditoría
    record_status VARCHAR(3) DEFAULT 'ACT' NOT NULL CHECK (record_status IN ('ACT', 'DEL')), -- Estado del registro (ACT=Activo, DEL=Eliminado)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL, -- Fecha de creación del registro
    created_by VARCHAR(128) NOT NULL, -- Usuario o sistema que creó el registro
    updated_at TIMESTAMP, -- Fecha de la última modificación del registro
    updated_by VARCHAR(128), -- Usuario o sistema que realizó la última modificación
    deleted_at TIMESTAMP, -- Fecha de eliminación del registro
    deleted_by VARCHAR(128), -- Usuario o sistema que eliminó el registro
    transaction_id VARCHAR(64), -- ID de la transacción asociada (para trazabilidad)

    -- 📌 Configuración de la política de contraseñas
    min_length SMALLINT DEFAULT 8 CHECK (min_length >= 6 AND min_length <= 128) NOT NULL, -- Longitud mínima de la contraseña
    max_length SMALLINT DEFAULT 64 CHECK (max_length >= 6 AND max_length <= 128) NOT NULL, -- Longitud máxima de la contraseña
    require_uppercase SMALLINT DEFAULT 1 CHECK (require_uppercase IN (0,1)) NOT NULL, -- Indica si se requiere al menos una letra mayúscula (0=No, 1=Sí)
    require_lowercase SMALLINT DEFAULT 1 CHECK (require_lowercase IN (0,1)) NOT NULL, -- Indica si se requiere al menos una letra minúscula (0=No, 1=Sí)
    require_number SMALLINT DEFAULT 1 CHECK (require_number IN (0,1)) NOT NULL, -- Indica si se requiere al menos un número (0=No, 1=Sí)
    require_special SMALLINT DEFAULT 1 CHECK (require_special IN (0,1)) NOT NULL, -- Indica si se requiere al menos un carácter especial (0=No, 1=Sí)
    max_failed_attempts SMALLINT DEFAULT 5 CHECK (max_failed_attempts >= 1 AND max_failed_attempts <= 10) NOT NULL, -- Número máximo de intentos fallidos antes de bloqueo
    password_expiration_days SMALLINT DEFAULT 90 CHECK (password_expiration_days >= 1 AND password_expiration_days <= 365) NOT NULL, -- Días antes de que la contraseña expire
    password_reuse_history SMALLINT DEFAULT 5 CHECK (password_reuse_history >= 0 AND password_reuse_history <= 20) NOT NULL, -- Número de contraseñas anteriores que no se pueden reutilizar
    enforce_mfa SMALLINT DEFAULT 1 CHECK (enforce_mfa IN (0,1)) NOT NULL, -- Indica si se requiere autenticación multifactor obligatoria (0=No, 1=Sí)
    auto_lock_minutes SMALLINT DEFAULT 15 CHECK (auto_lock_minutes >= 1 AND auto_lock_minutes <= 60) NOT NULL, -- Tiempo en minutos para bloqueo después de intentos fallidos
    reset_link_expiration SMALLINT DEFAULT 30 CHECK (reset_link_expiration >= 1 AND reset_link_expiration <= 1440) NOT NULL -- Tiempo en minutos en que expira el enlace de restablecimiento de contraseña
);
-- 📌 Índices optimizados
CREATE INDEX idx_password_policy_status ON idp_authentication.password_policy(record_status);



-- 📌 Registro de Tokens de Acceso para APIs
CREATE TABLE IF NOT EXISTS idp_authentication.api_access_tokens (
    api_token_id VARCHAR(26) PRIMARY KEY DEFAULT idp_authentication.generate_ulid(), -- Identificador único del token de API (ULID)

    -- 📌 Auditoría
    record_status VARCHAR(3) DEFAULT 'ACT' NOT NULL CHECK (record_status IN ('ACT', 'DEL')), -- Estado del registro (ACT=Activo, DEL=Eliminado)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL, -- Fecha de creación del registro
    created_by VARCHAR(128) NOT NULL, -- Usuario o sistema que generó el token
    updated_at TIMESTAMP, -- Fecha de la última modificación del token
    updated_by VARCHAR(128), -- Usuario o sistema que realizó la última modificación
    deleted_at TIMESTAMP, -- Fecha de eliminación del token
    deleted_by VARCHAR(128), -- Usuario o sistema que eliminó el token
    transaction_id VARCHAR(64), -- ID de la transacción asociada (para trazabilidad)

    -- 📌 Datos del Token de API
    user_id VARCHAR(26) NOT NULL, -- Identificador del usuario al que pertenece el token
    token_hash TEXT NOT NULL, -- Hash del token para evitar almacenamiento en texto plano
    token_type VARCHAR(20) NOT NULL CHECK (token_type IN ('ACCESS', 'REFRESH', 'SERVICE')), -- Tipo de token
    scopes TEXT NOT NULL, -- Permisos y alcance del token en formato JSON (Ejemplo: "{'read': true, 'write': false}")
    expires_at TIMESTAMP NOT NULL, -- Fecha y hora en que el token expira
    last_used_at TIMESTAMP, -- Última vez que el token fue utilizado
    is_revoked SMALLINT DEFAULT 0 CHECK (is_revoked IN (0,1)) -- Indica si el token ha sido revocado (1=Sí, 0=No)
);
-- 📌 Índices optimizados
CREATE INDEX idx_api_access_tokens_user ON idp_authentication.api_access_tokens(user_id);
CREATE INDEX idx_api_access_tokens_type ON idp_authentication.api_access_tokens(token_type);
CREATE INDEX idx_api_access_tokens_expires ON idp_authentication.api_access_tokens(expires_at);
CREATE INDEX idx_api_access_tokens_revoked ON idp_authentication.api_access_tokens(is_revoked);



-- 📌 Tabla de reglas de acceso para usuarios
CREATE TABLE IF NOT EXISTS idp_authorization.user_access_rules (
    user_access_rule_id VARCHAR(26) PRIMARY KEY DEFAULT idp_identity.generate_ulid(), -- Identificador único de la regla de acceso (ULID)

    -- 📌 Auditoría
    record_status VARCHAR(3) DEFAULT 'ACT' NOT NULL CHECK (record_status IN ('ACT', 'DEL')), -- Estado del registro (ACT=Activo, DEL=Eliminado)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL, -- Fecha de creación de la regla
    created_by VARCHAR(128) NOT NULL, -- Usuario o sistema que creó la regla
    updated_at TIMESTAMP, -- Fecha de la última modificación de la regla
    updated_by VARCHAR(128), -- Usuario o sistema que realizó la última modificación
    deleted_at TIMESTAMP, -- Fecha de eliminación de la regla
    deleted_by VARCHAR(128), -- Usuario o sistema que eliminó la regla
    transaction_id VARCHAR(64), -- ID de la transacción asociada (para trazabilidad)

    -- 📌 Datos de reglas de acceso
    user_id VARCHAR(26) NOT NULL, -- Identificador del usuario asociado a la regla
    rule_type VARCHAR(20) CHECK (rule_type IN ('ALLOW', 'DENY')) NOT NULL, -- Tipo de regla (ALLOW=Permitir, DENY=Denegar)
    rule_scope VARCHAR(50) CHECK (rule_scope IN ('IP', 'LOCATION', 'DEVICE', 'TIME', 'NETWORK', 'OTHER')) NOT NULL, -- Ámbito de la regla
    rule_value VARCHAR(255) NOT NULL, -- Valor específico de la regla (Ejemplo: "192.168.1.1", "Perú - Lima", "Windows 10")
    rule_expiration TIMESTAMP, -- Fecha de expiración de la regla (si aplica)
    is_temporary SMALLINT DEFAULT 0 CHECK (is_temporary IN (0,1)), -- Indica si la regla es temporal (1=Sí, 0=No)
    last_applied_at TIMESTAMP -- Última vez que se aplicó esta regla (para auditoría)
);
-- 📌 Índices optimizados
CREATE INDEX idx_user_access_rules_status ON idp_authorization.user_access_rules(record_status, is_temporary);
CREATE INDEX idx_user_access_rules_user ON idp_authorization.user_access_rules(user_id);
CREATE INDEX idx_user_access_rules_expiration ON idp_authorization.user_access_rules(rule_expiration);

