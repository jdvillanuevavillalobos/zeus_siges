-- ==========================================================
-- 📌 Creación de la tabla `user` en el esquema `idp_identity`
-- ==========================================================

-- Crear la extensión necesaria para generar ULIDs si no existe
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Crear función para generar ULID en PostgreSQL
CREATE OR REPLACE FUNCTION idp_identity.generate_ulid()
RETURNS VARCHAR(26) AS $$
DECLARE
    ulid VARCHAR(26);
BEGIN
    -- Generar un UUID v4 y convertirlo a Base32 (simulando ULID)
    SELECT encode(uuid_send(uuid_generate_v4()), 'base32') INTO ulid;
    RETURN ulid;
END;
$$ LANGUAGE plpgsql;

-- Crear tabla de usuarios en el esquema `idp_identity`
CREATE TABLE IF NOT EXISTS idp_identity.user (
    user_id VARCHAR(26) PRIMARY KEY DEFAULT idp_identity.generate_ulid(), -- ULID como clave primaria
    record_status VARCHAR(3) DEFAULT 'ACT' NOT NULL CHECK (record_status IN ('ACT', 'DEL')), -- Estado del registro
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL, -- Fecha de creación del usuario
    created_by VARCHAR(255) NOT NULL, -- Usuario que creó el registro
    updated_at TIMESTAMP, -- Fecha de la última actualización
    updated_by VARCHAR(255), -- Usuario que actualizó el registro
    deleted_at TIMESTAMP, -- Fecha de la eliminó el registro
    deleted_by VARCHAR(255), -- Usuario que eliminó el registro
    transaction_id VARCHAR(255), -- ID de la transacción asociada

    -- Datos de usuario
    username VARCHAR(50) UNIQUE NOT NULL, -- Nombre de usuario único
    email VARCHAR(100) UNIQUE NOT NULL, -- Correo electrónico único
    password_hash TEXT NOT NULL, -- Hash de la contraseña
    is_active BOOLEAN DEFAULT TRUE -- Indica si el usuario está activo
);

-- Crear índice para optimizar la búsqueda por username y email
CREATE UNIQUE INDEX idx_user_username ON idp_identity.user(username);
CREATE UNIQUE INDEX idx_user_email ON idp_identity.user(email);
