-- Crear el usuario replicador si no existe con contraseña MD5
DO
$$
BEGIN
    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'replicator') THEN
        CREATE ROLE replicator WITH REPLICATION LOGIN PASSWORD 'replicator_password';
    ELSE
        ALTER ROLE replicator WITH PASSWORD 'replicator_password';
    END IF;
END
$$;
