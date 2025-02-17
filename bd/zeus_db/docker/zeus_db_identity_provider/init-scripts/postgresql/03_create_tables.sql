-- ==========================================================
-- 📌 Creación de la tabla `user` en el esquema `idp_identity`
-- ==========================================================
-- 📌 Asegurar que la extensión pgcrypto esté instalada para generar aleatoriedad
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- 📌 Crear función para generar ULID
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
