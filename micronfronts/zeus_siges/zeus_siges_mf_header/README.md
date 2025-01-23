<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>README - Microfrontend con Arquitectura Hexagonal + DDD + Event-Driven</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            line-height: 1.6;
            max-width: 900px;
            margin: auto;
            padding: 20px;
            background-color: #f4f4f4;
        }
        h1, h2, h3 {
            color: #333;
        }
        code {
            background-color: #eee;
            padding: 2px 5px;
            border-radius: 3px;
            font-size: 14px;
        }
        pre {
            background: #333;
            color: #f8f8f8;
            padding: 10px;
            overflow-x: auto;
            border-radius: 5px;
        }
        .container {
            background: #fff;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
    </style>
</head>
<body>

<div class="container">
    <h1>🚀 Microfrontend con Arquitectura Hexagonal + DDD + Event-Driven</h1>
    <p>Este proyecto implementa un <strong>Microfrontend</strong> con <strong>Arquitectura Hexagonal</strong>, 
    <strong>Domain-Driven Design (DDD)</strong> y <strong>Event-Driven Architecture (EDA)</strong> 
    en <strong>React con TypeScript</strong>.</p>

    <h2>📌 Características Principales</h2>
    <ul>
        <li>✅ Modularidad con <strong>Arquitectura Hexagonal</strong> (Ports & Adapters).</li>
        <li>✅ Uso de <strong>Domain-Driven Design (DDD)</strong> para organizar el código.</li>
        <li>✅ Comunicación basada en <strong>Eventos (Event-Driven Architecture)</strong>.</li>
        <li>✅ Separación de responsabilidades con <strong>Inversión de Dependencias (DI)</strong>.</li>
        <li>✅ Uso de <strong>Microfrontend</strong> compatible con Webpack Module Federation.</li>
    </ul>

    <h2>📁 Estructura del Proyecto</h2>
    <pre>
src/
│── aplicacion/
│   ├── casosDeUso/
│   │   ├── ObtenerMensajeHolaMundo.ts  # Casos de uso
│
│── config/
│   ├── config.ts                       # Configuración global
│   ├── contenedorDI.tsx                 # Inversión de Dependencias
│   ├── eventRegistry.ts                  # Registro central de eventos
│   ├── manejadorErrores.ts               # Manejador de errores
│
│── dominio/
│   ├── adaptadores/
│   │   ├── IRepositorioHolaMundo.ts      # Interface de repositorio
│   ├── entidades/
│   │   ├── HolaMundoEntidad.ts           # Entidad del Dominio
│
│── infraestructura/
│   ├── adaptadores/
│   │   ├── RepositorioHolaMundo.ts       # Implementación del repositorio
│
│── interfaces/
│   ├── controladores/
│   │   ├── ControladorHolaMundo.ts       # Controlador del Microfrontend
│   ├── ui/
│   │   ├── HolaMundo.tsx                 # Componente UI
│
│── utils/
│   ├── EventBus.ts                        # EventBus para eventos globales
│   ├── http.ts                            # Cliente HTTP con Axios
│   ├── logger.ts                          # Logger centralizado
│
│── bootstrap.tsx                          # Archivo principal de la App
│── index.ts                               # Punto de entrada
    </pre>

    <h2>⚙️ Configuración y Ejecución</h2>
    <h3>1️⃣ Instalación</h3>
    <pre><code>npm install</code></pre>

    <h3>2️⃣ Ejecución en modo desarrollo</h3>
    <pre><code>npm run dev</code></pre>

    <h3>3️⃣ Construcción del proyecto</h3>
    <pre><code>npm run build</code></pre>

    <h2>🛠️ Tecnologías Usadas</h2>
    <ul>
        <li>🔹 <strong>React 18</strong></li>
        <li>🔹 <strong>TypeScript</strong></li>
        <li>🔹 <strong>Webpack 5 + Module Federation</strong></li>
        <li>🔹 <strong>EventEmitter</strong> para la gestión de eventos</li>
        <li>🔹 <strong>Axios</strong> para llamadas HTTP</li>
    </ul>

    <h2>🔗 Arquitectura Detallada</h2>
    <h3>🔹 Arquitectura Hexagonal (Ports and Adapters)</h3>
    <p>Separa la lógica de negocio del acceso a datos y la infraestructura. 
    Define <strong>Interfaces</strong> y <strong>Adaptadores</strong> para desacoplar componentes.</p>

    <h3>🔹 Domain-Driven Design (DDD)</h3>
    <p>El código está organizado en <strong>Entidades</strong>, <strong>Casos de Uso</strong> y <strong>Repositorios</strong>.</p>

    <h3>🔹 Event-Driven Architecture (EDA)</h3>
    <p>Se usa <code>EventBus.ts</code> para manejar eventos globales y permitir comunicación desacoplada.</p>

    <h2>📡 Flujo de Datos</h2>
    <ol>
        <li>1️⃣ El componente <code>HolaMundo.tsx</code> emite un evento de carga <code>EVENTOS_MF.LOAD</code>.</li>
        <li>2️⃣ <code>ControladorHolaMundo.ts</code> escucha el evento y ejecuta la lógica de negocio.</li>
        <li>3️⃣ Se obtiene un mensaje desde la API a través de <code>RepositorioHolaMundo.ts</code>.</li>
        <li>4️⃣ Si la API responde correctamente, se emite <code>EVENTOS_MF.MENSAJE_RECIBIDO</code>.</li>
        <li>5️⃣ Si ocurre un error, se emite <code>EVENTOS_MF.ERROR_SERVICIO</code> con los detalles.</li>
    </ol>

    <h2>📡 Eventos Disponibles</h2>
    <table border="1" cellpadding="5" cellspacing="0">
        <tr>
            <th>Evento</th>
            <th>Descripción</th>
        </tr>
        <tr>
            <td><code>EVENTOS_MF.LOAD</code></td>
            <td>Disparado cuando la UI necesita cargar los datos iniciales.</td>
        </tr>
        <tr>
            <td><code>EVENTOS_MF.MENSAJE_RECIBIDO</code></td>
            <td>Disparado cuando la API responde con éxito.</td>
        </tr>
        <tr>
            <td><code>EVENTOS_MF.ERROR_SERVICIO</code></td>
            <td>Disparado cuando ocurre un error en la API.</td>
        </tr>
    </table>

    <h2>📄 Licencia</h2>
    <p>MIT License - Este código es de uso libre.</p>

    <h2>💬 Contacto</h2>
    <p>Para dudas o mejoras, ¡contáctame en <strong>GitHub</strong>! 🚀</p>
</div>

</body>
</html>
