<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>README - Zeus Siges MF Root</title>
</head>
<body>
  <h1>Zeus Siges MF Root</h1>
  <p>
    <strong>Zeus Siges MF Root</strong> es el contenedor principal del sistema basado en microfrontends, implementado con 
    <strong>Webpack Module Federation</strong> y desarrollado con <strong>React</strong> y <strong>TypeScript</strong>.
    Este proyecto sigue una arquitectura <strong>Hexagonal</strong> junto con principios de <strong>Diseño Orientado a Dominio (DDD)</strong>.
  </p>

  <h2>Tabla de Contenidos</h2>
  <ul>
    <li><a href="#arquitectura-hexagonal-y-ddd">Arquitectura Hexagonal y DDD</a></li>
    <li><a href="#estructura-de-carpetas">Estructura de Carpetas</a></li>
    <li><a href="#requisitos-previos">Requisitos Previos</a></li>
    <li><a href="#instalación">Instalación</a></li>
    <li><a href="#scripts-disponibles">Scripts Disponibles</a></li>
    <li><a href="#configuración">Configuración</a></li>
    <li><a href="#cómo-contribuir">Cómo Contribuir</a></li>
  </ul>

  <h2 id="arquitectura-hexagonal-y-ddd">Arquitectura Hexagonal y DDD</h2>
  <p>
    Este proyecto sigue la arquitectura <strong>Hexagonal</strong>, también conocida como <strong>Ports and Adapters</strong>. 
    Este enfoque asegura que el núcleo de la aplicación (dominio) permanezca independiente de los detalles de infraestructura, como frameworks o servicios externos.
  </p>
  <p>
    En combinación con <strong>Diseño Orientado a Dominio (DDD)</strong>, el proyecto organiza el código en capas:
  </p>
  <ul>
    <li>
      <strong>Dominio:</strong> Contiene las reglas de negocio y modelos principales. Es la capa central del sistema.
      <ul>
        <li><code>src/domain/models/</code></li>
      </ul>
    </li>
    <li>
      <strong>Aplicación:</strong> Maneja la lógica de casos de uso. Actúa como puente entre el dominio y la infraestructura.
      <ul>
        <li><code>src/application/services/</code></li>
      </ul>
    </li>
    <li>
      <strong>Infraestructura:</strong> Contiene implementaciones específicas, como adaptadores y configuraciones.
      <ul>
        <li><code>src/infrastructure/adapters/</code></li>
        <li><code>src/infrastructure/configurations/</code></li>
        <li><code>src/infrastructure/types/</code></li>
      </ul>
    </li>
    <li>
      <strong>Interfaces:</strong> Maneja la interacción con el usuario (UI) y otros sistemas.
      <ul>
        <li><code>src/interfaces/ui/components/</code></li>
        <li><code>src/interfaces/ui/containers/</code></li>
      </ul>
    </li>
    <li>
      <strong>Entrypoint Principal:</strong> Donde se inicia la aplicación.
      <ul>
        <li><code>src/main/</code></li>
      </ul>
    </li>
  </ul>

  <h2 id="estructura-de-carpetas">Estructura de Carpetas</h2>
  <pre>
zeus_siges_mf_root/
├── public/
│   ├── index.html
├── src/
│   ├── application/
│   │   └── services/
│   │       └── RemoteComponentService.ts
│   ├── domain/
│   │   └── models/
│   │       └── RemoteComponent.ts
│   ├── infrastructure/
│   │   ├── adapters/
│   │   │   └── RemoteComponentAdapter.ts
│   │   ├── configurations/
│   │   │   └── ModuleFederationConfig.ts
│   │   └── types/
│   │       └── declares.d.ts
│   ├── interfaces/
│   │   ├── ui/
│   │   │   ├── components/
│   │   │   │   └── RemoteComponent.tsx
│   │   │   └── containers/
│   │   │       └── App.tsx
│   ├── main/
│   │   ├── bootstrap.tsx
│   │   └── index.ts
├── package.json
├── tsconfig.json
├── webpack.config.js
  </pre>

  <h2 id="requisitos-previos">Requisitos Previos</h2>
  <ul>
    <li>Node.js >= 16</li>
    <li>NPM o Yarn</li>
    <li>Editor de texto (recomendado: Visual Studio Code)</li>
  </ul>

  <h2 id="instalación">Instalación</h2>
  <pre>
git clone https://github.com/tu-repositorio/zeus_siges_mf_root.git
cd zeus_siges_mf_root
npm install
  </pre>

  <h2 id="scripts-disponibles">Scripts Disponibles</h2>
  <ul>
    <li><code>npm run start</code>: Inicia el servidor de desarrollo en <code>http://localhost:3000</code>.</li>
    <li><code>npm run build</code>: Genera la aplicación para producción.</li>
    <li><code>npm run lint</code>: Ejecuta ESLint para verificar problemas de código.</li>
    <li><code>npm run format</code>: Formatea el código usando Prettier.</li>
  </ul>

  <h2 id="configuración">Configuración</h2>
  <h3>Webpack Module Federation</h3>
  <p>El archivo <code>src/infrastructure/configurations/ModuleFederationConfig.ts</code> contiene la configuración de los módulos remotos y compartidos.</p>
  <pre>
export const ModuleFederationConfig = {
  remotes: {
    zeus_siges_mf_header: "zeus_siges_mf_header@http://localhost:3001/remoteEntry.js",
  },
};
  </pre>

  <h2 id="cómo-contribuir">Cómo Contribuir</h2>
  <ol>
    <li>Haz un fork del repositorio.</li>
    <li>Crea una rama nueva (<code>git checkout -b feature/nueva-funcionalidad</code>).</li>
    <li>Realiza los cambios necesarios y haz commit (<code>git commit -m "Añade nueva funcionalidad"</code>).</li>
    <li>Sube los cambios a tu rama (<code>git push origin feature/nueva-funcionalidad</code>).</li>
    <li>Abre un Pull Request.</li>
  </ol>

  <p>¡Gracias por contribuir! 🚀</p>
</body>
</html>
