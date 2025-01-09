-- ================================================================
-- Script para la creación de tablas del Microservicio: User Service
-- Este script incluye:
-- 1. Extensiones necesarias.
-- 2. Función para generar ULIDs.
-- 3. Tablas relacionadas: usuarios, perfiles, direcciones, sesiones, MFA.
-- 4. Índices para optimizar consultas.
-- ================================================================

-- ================================================================
-- 1. Extensiones necesarias
-- Estas extensiones permiten generar UUIDs y datos aleatorios seguros.
-- ================================================================
CREATE EXTENSION IF NOT EXISTS "uuid-ossp"; -- Generación de UUIDs
CREATE EXTENSION IF NOT EXISTS "pgcrypto"; -- Soporte para encriptación y generación de bytes aleatorios

-- ================================================================
-- Crear el esquema "seguridad"
-- ================================================================
CREATE SCHEMA IF NOT EXISTS seguridad;

-- ================================================================
-- 2. Función para generar ULIDs
-- ULIDs son identificadores únicos cronológicamente ordenables.
-- ================================================================
CREATE OR REPLACE FUNCTION seguridad.generate_ulid()
RETURNS VARCHAR(26) AS $$
DECLARE
    ts BIGINT;
    random_bytes BYTEA;
    ulid VARCHAR(26);
BEGIN
    -- Obtener la marca de tiempo actual en milisegundos
    ts := (EXTRACT(EPOCH FROM clock_timestamp()) * 1000)::BIGINT;

    -- Generar 10 bytes aleatorios
    random_bytes := gen_random_bytes(10);

    -- Convertir la marca de tiempo y los bytes aleatorios en un ULID
    ulid := encode(
        set_byte(set_byte(set_byte(set_byte(
            '\000000000000000000000000'::BYTEA,
            0, ts >> 40 & 255),
            1, ts >> 32 & 255),
            2, ts >> 24 & 255),
            3, ts >> 16 & 255) || random_bytes,
        'base32');

    RETURN ulid;
END;
$$ LANGUAGE plpgsql;

-- ================================================================
-- 3. Tabla: usuarios
-- Contiene la información básica del usuario necesaria para la autenticación.
-- ================================================================
CREATE TABLE IF NOT EXISTS seguridad.usuarios (
    id VARCHAR(26) DEFAULT seguridad.generate_ulid() PRIMARY KEY, -- Identificador único ULID
    nombre_usuario VARCHAR(255) NOT NULL UNIQUE,       -- Nombre de usuario único
    correo VARCHAR(255) NOT NULL UNIQUE,               -- Correo electrónico único
    contrasena_hash VARCHAR(255) NOT NULL,             -- Contraseña encriptada
    numero_telefono VARCHAR(20),                       -- Número de teléfono (opcional)
    telefono_verificado BOOLEAN DEFAULT FALSE,         -- Si el número está verificado
    correo_verificado BOOLEAN DEFAULT FALSE,           -- Si el correo está verificado
    esta_activo BOOLEAN DEFAULT TRUE,                  -- Estado del usuario (activo/inactivo)
    creado_en TIMESTAMP DEFAULT NOW(),                 -- Fecha de creación
    actualizado_en TIMESTAMP DEFAULT NOW()             -- Última actualización
);

-- ================================================================
-- 4. Tabla: perfiles_usuario
-- Extensión de datos de usuario, como nombre completo y preferencias.
-- ================================================================
CREATE TABLE IF NOT EXISTS seguridad.perfiles_usuario (
    id VARCHAR(26) DEFAULT seguridad.generate_ulid() PRIMARY KEY, -- Identificador único
    usuario_id VARCHAR(26) NOT NULL UNIQUE REFERENCES seguridad.usuarios(id) ON DELETE CASCADE, -- Relación 1:1 con usuarios
    nombre_completo VARCHAR(255),                     -- Nombre completo
    primer_nombre VARCHAR(100),                       -- Primer nombre
    apellido VARCHAR(100),                            -- Apellido
    fecha_nacimiento DATE,                            -- Fecha de nacimiento
    genero VARCHAR(10),                               -- Género (ej.: "masculino", "femenino")
    url_avatar VARCHAR(255),                          -- URL del avatar del perfil
    titulo_profesional VARCHAR(100),                  -- Título profesional
    empresa VARCHAR(100),                             -- Empresa del usuario
    sitio_web VARCHAR(255),                           -- Sitio web personal o profesional
    biografia TEXT,                                   -- Biografía breve
    idioma_preferido VARCHAR(10),                     -- Idioma preferido (ej.: "es", "en")
    zona_horaria VARCHAR(50),                         -- Zona horaria (ej.: "UTC", "America/Mexico_City")
    creado_en TIMESTAMP DEFAULT NOW(),                -- Fecha de creación
    actualizado_en TIMESTAMP DEFAULT NOW()            -- Última actualización
);

-- ================================================================
-- 5. Tabla: direcciones_usuario
-- Contiene las direcciones asociadas a un usuario.
-- ================================================================
CREATE TABLE IF NOT EXISTS seguridad.direcciones_usuario (
    id VARCHAR(26) DEFAULT seguridad.generate_ulid() PRIMARY KEY, -- Identificador único
    usuario_id VARCHAR(26) NOT NULL REFERENCES seguridad.usuarios(id) ON DELETE CASCADE, -- Relación con usuarios
    direccion_linea1 VARCHAR(255) NOT NULL,            -- Línea principal de la dirección
    direccion_linea2 VARCHAR(255),                     -- Línea secundaria (opcional)
    ciudad VARCHAR(100) NOT NULL,                      -- Ciudad
    estado VARCHAR(100),                               -- Estado
    codigo_postal VARCHAR(20),                         -- Código postal
    pais VARCHAR(100) NOT NULL,                        -- País
    es_principal BOOLEAN DEFAULT FALSE,                -- Si es la dirección principal
    creado_en TIMESTAMP DEFAULT NOW(),                 -- Fecha de creación
    actualizado_en TIMESTAMP DEFAULT NOW()             -- Última actualización
);

-- ================================================================
-- 6. Tabla: sesiones
-- Registra las sesiones activas del usuario.
-- ================================================================
CREATE TABLE IF NOT EXISTS seguridad.sesiones (
    id VARCHAR(26) DEFAULT seguridad.generate_ulid() PRIMARY KEY, -- Identificador único
    usuario_id VARCHAR(26) NOT NULL REFERENCES seguridad.usuarios(id) ON DELETE CASCADE, -- Relación con usuarios
    token VARCHAR(255) NOT NULL UNIQUE,                 -- Token de sesión (JWT o similar)
    token_refresco VARCHAR(255) NOT NULL UNIQUE,        -- Token de refresco
    direccion_ip VARCHAR(50),                           -- Dirección IP de la sesión
    agente_usuario VARCHAR(255),                        -- Información del dispositivo/navegador
    expira_en TIMESTAMP NOT NULL,                       -- Fecha de expiración del token
    creado_en TIMESTAMP DEFAULT NOW(),                  -- Fecha de creación de la sesión
    actualizado_en TIMESTAMP DEFAULT NOW()              -- Última actualización de la sesión
);

-- ================================================================
-- 7. Tabla: metodos_mfa
-- Métodos de autenticación multifactor configurados por el usuario.
-- ================================================================
CREATE TABLE IF NOT EXISTS seguridad.metodos_mfa (
    id VARCHAR(26) DEFAULT seguridad.generate_ulid() PRIMARY KEY, -- Identificador único
    usuario_id VARCHAR(26) NOT NULL REFERENCES seguridad.usuarios(id) ON DELETE CASCADE, -- Relación con usuarios
    metodo VARCHAR(50) NOT NULL,                        -- Método de MFA (ej.: "totp", "sms")
    datos_metodo TEXT NOT NULL,                         -- Datos relacionados con el método (encriptados)
    esta_activo BOOLEAN DEFAULT TRUE,                   -- Si el método está activo
    creado_en TIMESTAMP DEFAULT NOW(),                  -- Fecha de creación
    actualizado_en TIMESTAMP DEFAULT NOW()              -- Última actualización
);

-- ================================================================
-- 8. Índices recomendados
-- Estos índices optimizan consultas frecuentes.
-- ================================================================
-- Índices en usuarios
CREATE INDEX IF NOT EXISTS idx_usuarios_correo ON seguridad.usuarios(correo);
CREATE INDEX IF NOT EXISTS idx_usuarios_telefono ON seguridad.usuarios(numero_telefono);

-- Índices en tablas relacionadas
CREATE INDEX IF NOT EXISTS idx_perfiles_usuario_usuario_id ON seguridad.perfiles_usuario(usuario_id);
CREATE INDEX IF NOT EXISTS idx_direcciones_usuario_usuario_id ON seguridad.direcciones_usuario(usuario_id);
CREATE INDEX IF NOT EXISTS idx_sesiones_usuario_id ON seguridad.sesiones(usuario_id);
CREATE INDEX IF NOT EXISTS idx_metodos_mfa_usuario_id ON seguridad.metodos_mfa(usuario_id);

-- ================================================================
-- Fin del script
-- ================================================================
