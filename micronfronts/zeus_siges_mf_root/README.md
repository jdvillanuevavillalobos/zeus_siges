<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Zeus SIGES - Contenedor Microfrontend</title>
</head>
<body>
  <h1>Zeus SIGES - Contenedor Microfrontend</h1>

  <h2>📖 Descripción</h2>
  <p>
    Este proyecto es el contenedor principal para el sistema <strong>Zeus SIGES</strong>, implementado utilizando
    <strong>microfrontends</strong> con la arquitectura <strong>Clean Architecture + DDD (Domain-Driven Design)</strong>.
    El contenedor gestiona la integración de diferentes microfrontends desarrollados en <strong>React</strong>, y proporciona funcionalidades como manejo de errores, comunicación entre microfrontends y soporte para temas.
  </p>

  <h2>🚀 Características principales</h2>
  <ul>
    <li><strong>Microfrontends</strong>: Registro dinámico y carga segura de microfrontends utilizando <strong>single-spa</strong>.</li>
    <li><strong>Clean Architecture + DDD</strong>: Código modular y escalable que facilita el mantenimiento y las extensiones futuras.</li>
    <li><strong>React</strong>: Framework base para los componentes principales.</li>
    <li><strong>Gestión de errores avanzada</strong>: Interfaces personalizadas para mostrar errores y permitir reintentos.</li>
    <li><strong>Temas</strong>: Soporte para temas claros y oscuros a través de variables CSS.</li>
  </ul>

  <h2>🗂️ Estructura del proyecto</h2>
  <pre>
zeus_siges_mf_root/
├── public/
│   ├── global.css           # Estilos globales compartidos
│   ├── importmap.json       # Mapeo de microfrontends y bibliotecas compartidas
│   └── index.html           # Punto de entrada HTML
├── src/
│   ├── domain/              # Definiciones del núcleo de negocio
│   │   ├── core/            # Contratos y modelos básicos
│   │   └── entities/        # Entidades de negocio (e.g., Theme)
│   ├── application/         # Casos de uso
│   │   └── use-cases/       # Lógica específica del negocio
│   ├── infrastructure/      # Configuración y servicios
│   │   ├── config/          # Configuración de microfrontends
│   │   └── services/        # Servicios como carga de microfrontends y manejo de errores
│   ├── presentation/        # UI y lógica relacionada con la presentación
│   │   ├── components/      # Componentes React
│   │   └── styles/          # Estilos específicos del proyecto
│   ├── index.js             # Punto de entrada del contenedor
│   └── single-spa-config.js # Configuración de single-spa
├── .babelrc                 # Configuración de Babel para JSX y ESNext
├── webpack.config.js        # Configuración de Webpack
├── package.json             # Dependencias y scripts
└── README.md                # Documentación del proyecto
  </pre>

  <h2>🛠️ Instalación</h2>
  <ol>
    <li>
      Clona el repositorio:
      <pre><code>git clone https://github.com/tu-repositorio/zeus_siges_mf_root.git
cd zeus_siges_mf_root</code></pre>
    </li>
    <li>
      Instala las dependencias:
      <pre><code>npm install</code></pre>
    </li>
    <li>
      Crea un archivo <code>.env</code> (opcional) con las variables de entorno necesarias. Ejemplo:
      <pre><code>PUBLIC_PATH=/
PORT=9000</code></pre>
    </li>
    <li>
      Inicia el servidor de desarrollo:
      <pre><code>npm start</code></pre>
    </li>
    <li>
      Abre el navegador en <a href="http://localhost:9000" target="_blank">http://localhost:9000</a>.
    </li>
  </ol>

  <h2>📚 Uso</h2>
  <ol>
    <li><strong>Agregar un nuevo microfrontend:</strong>
      <p>Define la configuración en <code>src/infrastructure/config/microfrontends.js</code>. Ejemplo:</p>
      <pre><code>{
  name: 'nuevo_mf',
  url: 'http://localhost:8085/nuevo-mf.js',
  activeWhen: (location) => location.pathname.startsWith('/nuevo-mf'),
  domElement: 'content',
}</code></pre>
    </li>
    <li><strong>Gestión de temas:</strong>
      <p>Cambia entre temas usando el servicio <code>themeService</code>:</p>
      <pre><code>import { themeService } from '@infrastructure/services/theme-service';
themeService.setTheme('dark');</code></pre>
    </li>
    <li><strong>Manejo de errores:</strong>
      <p>Los errores en la carga de microfrontends se manejan automáticamente mediante el componente <code>ErrorDisplay</code>.</p>
    </li>
  </ol>

  <h2>📦 Scripts disponibles</h2>
  <ul>
    <li><code>npm start</code>: Inicia el servidor de desarrollo con Hot Module Replacement (HMR).</li>
    <li><code>npm build</code>: Genera los archivos optimizados para producción.</li>
    <li><code>npm test</code>: Ejecuta los tests (si están configurados).</li>
  </ul>

  <h2>🔧 Tecnologías utilizadas</h2>
  <ul>
    <li><strong>React 18</strong></li>
    <li><strong>Single-SPA</strong></li>
    <li><strong>Webpack 5</strong></li>
    <li><strong>Babel</strong></li>
    <li><strong>CSS Modules</strong></li>
  </ul>

  <h2>🤝 Contribuciones</h2>
  <ol>
    <li>Haz un fork del repositorio.</li>
    <li>Crea una rama con tu nueva funcionalidad o corrección de errores: <code>git checkout -b feature/nueva-funcionalidad</code>.</li>
    <li>Envía tus cambios: <code>git push origin feature/nueva-funcionalidad</code>.</li>
    <li>Abre un Pull Request.</li>
  </ol>

  <h2>📝 Licencia</h2>
  <p>Este proyecto está licenciado bajo la <a href="LICENSE">Licencia MIT</a>.</p>
</body>
</html>
