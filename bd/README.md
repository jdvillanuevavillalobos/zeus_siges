<h1>Proyecto: Configuración de Replicación en PostgreSQL con Docker</h1>

<p>
Este proyecto configura un entorno de replicación en PostgreSQL utilizando Docker y Docker Compose. Incluye un nodo principal y un nodo réplica que funcionan de manera sincronizada o asíncrona según la configuración deseada. Compatible con sistemas Linux y Windows.
</p>

<h2>Características Principales</h2>
<ul>
  <li>Replicación de datos entre nodos principal y réplica en PostgreSQL.</li>
  <li>Configuración modular y personalizable usando Docker Compose.</li>
  <li>Soporte para replicación síncrona o asíncrona.</li>
</ul>

<h2>Requisitos Previos</h2>
<ol>
  <li><strong>Para Linux:</strong>
    <ul>
      <li><a href="https://docs.docker.com/get-docker/">Docker</a></li>
      <li><a href="https://docs.docker.com/compose/install/">Docker Compose</a></li>
      <li>Configurar permisos en los scripts:
        <pre>
chmod +x replica/setup_replica.sh
chmod 644 primary/pg_hba.conf primary/postgresql.conf primary/init.sql
chmod 644 replica/pg_hba.conf replica/postgresql.conf
        </pre>
      </li>
    </ul>
  </li>
  <li><strong>Para Windows:</strong>
    <ul>
      <li><a href="https://docs.docker.com/get-docker/">Docker Desktop</a> instalado.</li>
      <li>Si usas WSL2, asegúrate de configurar los permisos con un editor de texto como Notepad++.</li>
    </ul>
  </li>
</ol>

<h2>Estructura del Proyecto</h2>
<pre>
/bd
|-- docker-compose.yml                # Configuración de servicios Docker
|-- primary/                          # Configuración del nodo principal
|   |-- postgresql.conf               # Configuración principal de PostgreSQL
|   |-- pg_hba.conf                   # Configuración de acceso
|   |-- setup_primary.sh              # Script para inicializar el nodo principal
|   |-- init.sql                      # Datos iniciales para la base de datos
|-- replica/                          # Configuración del nodo réplica
|   |-- postgresql.conf               # Configuración principal de PostgreSQL
|   |-- pg_hba.conf                   # Configuración de acceso
|   |-- setup_replica.sh              # Script para inicializar el nodo réplica
</pre>

<h2>Pasos para Levantar el Entorno</h2>

<h3>1. Crear el Archivo .env</h3>
<p>Configura las variables de entorno en un archivo <code>.env</code>:</p>
<pre>
POSTGRES_USER=admin
POSTGRES_PASSWORD=admin123
POSTGRES_DB=sigeszeus
PRIMARY_PORT=5432
REPLICA_PORT=5433
</pre>

<h3>2. Iniciar los Servicios</h3>
<p>Ejecuta el siguiente comando para levantar el entorno con Docker Compose:</p>
<pre>
docker-compose up -d
</pre>
<p>Esto hará lo siguiente:</p>
<ul>
  <li>Configurar el nodo principal, crear la base de datos, esquemas y datos iniciales.</li>
  <li>Configurar automáticamente el nodo réplica en modo standby.</li>
</ul>

<h3>3. Verificar el Estado de los Contenedores</h3>
<p>Comprueba que los contenedores están corriendo:</p>
<pre>
docker ps
</pre>

<h3>4. Validar la Replicación</h3>
<p>Desde el nodo réplica, verifica que los datos se han replicado correctamente:</p>
<pre>
docker exec -it postgres_replica psql -U admin -d sigeszeus -c "SELECT * FROM replica_prueba.replica;"
</pre>
<p><strong>Resultado esperado:</strong></p>
<pre>
 id | nombre  | apellido
----+---------+---------
  1 | Juan    | Pérez
  2 | Ana     | López
  3 | Carlos  | Gómez
</pre>

<h3>5. Verificar el Estado de la Replicación</h3>
<p>Desde el nodo principal, ejecuta:</p>
<pre>
docker exec -it postgres_primary psql -U admin -c "SELECT * FROM pg_stat_replication;"
</pre>

<h2>Comandos Útiles</h2>
<ul>
  <li>Detener y limpiar el entorno:
    <pre>
docker-compose down -v
    </pre>
  </li>
  <li>Reiniciar el nodo principal después de cambios:
    <pre>
docker-compose restart primary
    </pre>
  </li>
  <li>Validar roles y bases de datos:
    <pre>
docker exec -it postgres_primary psql -U postgres -c "SELECT rolname FROM pg_roles;"
docker exec -it postgres_primary psql -U postgres -c "SELECT datname FROM pg_database;"
    </pre>
  </li>
  <li>Inspeccionar redes de Docker:
    <pre>
docker network ls
    </pre>
  </li>
</ul>

<h2>Personalización</h2>

<h3>Datos Iniciales</h3>
<p>Modifica el archivo <code>primary/init.sql</code> para agregar tus datos iniciales.</p>

<h3>Agregar Más Réplicas</h3>
<p>Edita el archivo <code>docker-compose.yml</code> y copia la configuración del servicio <code>replica</code>. Cambia el puerto y el volumen para evitar conflictos.</p>

<h2>Configuración de Replicación Asíncrona</h2>

<ol>
  <li>Edita el archivo <code>primary/postgresql.conf</code>:
    <pre>
synchronous_standby_names = ''
    </pre>
  </li>
  <li>Reinicia el nodo principal:
    <pre>
docker-compose restart primary
    </pre>
  </li>
  <li>Verifica el estado de la replicación:
    <pre>
docker exec -it postgres_primary psql -U admin -c "SELECT * FROM pg_stat_replication;"
    </pre>
    <p>En la columna <code>sync_state</code>, deberías ver <code>async</code>.</p>
  </li>
</ol>

<h2>Resultado Esperado</h2>

<ul>
  <li><strong>Nodo Principal:</strong> Funciona como la base de datos principal donde se realizan las operaciones de escritura.</li>
  <li><strong>Nodo Réplica:</strong> Sincroniza automáticamente los datos desde el nodo principal.</li>
  <li><strong>Validación:</strong> La replicación refleja los datos en tiempo real entre los nodos.</li>
</ul>

<h2>Creado Por</h2>
<p>
<strong>José David Villanueva Villalobos</strong><br>
<a href="https://www.linkedin.com/in/jose-david-villanueva-villalobos-47283554/" target="_blank">LinkedIn: José David Villanueva Villalobos</a>
</p>
