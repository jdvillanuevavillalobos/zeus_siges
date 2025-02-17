# Usamos la imagen oficial de PostgreSQL 15
FROM postgres:15

# Cambiamos a root temporalmente para modificar permisos y actualizar el sistema
USER root

# Actualizamos el sistema operativo e instalamos paquetes mínimos
RUN apt-get update && apt-get upgrade -y \
    && rm -rf /var/lib/apt/lists/*

# Crear carpetas necesarias y copiar configuraciones
RUN mkdir -p /etc/postgresql /backups \
    && chown postgres:postgres /etc/postgresql /backups \
    && chmod 700 /backups

# Copiamos los archivos de configuración
COPY postgresql.conf /etc/postgresql/postgresql.conf
COPY pg_hba.conf /etc/postgresql/pg_hba.conf

# Asegurar permisos correctos en archivos de configuración
RUN chmod 600 /etc/postgresql/postgresql.conf /etc/postgresql/pg_hba.conf \
    && chown postgres:postgres /etc/postgresql/postgresql.conf /etc/postgresql/pg_hba.conf

# Cambiamos al usuario postgres
USER postgres

# Definimos el entorno para que PostgreSQL utilice nuestros archivos de configuración
ENV PGDATA=/var/lib/postgresql/data

# Copiamos los scripts de inicialización
COPY init-scripts/ /docker-entrypoint-initdb.d/

# Exponemos el puerto 5432 para conexiones externas
EXPOSE 5432

# Comando de inicio para forzar el uso del archivo de configuración
CMD ["postgres", "-c", "config_file=/etc/postgresql/postgresql.conf"]
