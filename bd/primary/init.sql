-- Crear esquema de prueba
CREATE SCHEMA IF NOT EXISTS replica_prueba;

-- Crear tabla de ejemplo
CREATE TABLE IF NOT EXISTS replica_prueba.replica (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL
);

-- Insertar datos iniciales
INSERT INTO replica_prueba.replica (nombre, apellido)
VALUES ('Juan', 'Pérez'), ('Ana', 'López'), ('Carlos', 'Gómez');
