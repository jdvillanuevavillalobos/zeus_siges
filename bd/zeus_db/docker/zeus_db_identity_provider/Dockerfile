# Usamos la imagen oficial de PostgreSQL 15
FROM postgres:15

# Cambiamos a root temporalmente para modificar permisos
USER root

# Creamos la carpeta si no existe y copiamos los archivos de configuración
RUN mkdir -p /etc/postgresql/

# Copiamos los archivos de configuración
COPY postgresql.conf /etc/postgresql/postgresql.conf
COPY pg_hba.conf /etc/postgresql/pg_hba.conf

# Cambiamos permisos para asegurar que PostgreSQL pueda leerlos
RUN chmod 600 /etc/postgresql/postgresql.conf /etc/postgresql/pg_hba.conf \
    && chown postgres:postgres /etc/postgresql/postgresql.conf /etc/postgresql/pg_hba.conf

# Volvemos a usuario postgres
USER postgres

# Copiamos los scripts de inicialización
COPY init-scripts/ /docker-entrypoint-initdb.d/

# Exponemos el puerto 5432 para conexiones externas
EXPOSE 5432
