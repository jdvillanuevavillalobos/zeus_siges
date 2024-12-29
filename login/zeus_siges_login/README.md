# Zeus SIGES Login Module

<!DOCTYPE html>
<html>
<head>
  <title>Zeus SIGES Login Module</title>
</head>
<body>
  <h1>Zeus SIGES Login Module</h1>
  <p>
    Este módulo implementa la funcionalidad de inicio de sesión para el sistema <strong>Zeus SIGES</strong>. Está diseñado siguiendo el patrón de desarrollo <strong>MVVC (Modelo-Vista-VistaModelo-Controlador)</strong>, 
    asegurando una separación clara de responsabilidades y facilitando el mantenimiento y la escalabilidad.
  </p>

  <h2>🚀 Tecnologías Utilizadas</h2>
  <ul>
    <li><strong>React</strong>: Biblioteca para interfaces de usuario.</li>
    <li><strong>Ant Design</strong>: Framework de UI para componentes.</li>
    <li><strong>Vite</strong>: Herramienta para desarrollo rápido y eficiente.</li>
    <li><strong>TypeScript</strong>: Lenguaje tipado para mejorar la calidad del código.</li>
    <li><strong>Less</strong>: Preprocesador de CSS.</li>
  </ul>

  <h2>📂 Estructura del Proyecto</h2>
  <p>El proyecto está diseñado siguiendo el patrón <strong>MVVC</strong>, organizando las capas de manera clara:</p>
  <pre>
zeus_siges_login
├── public/
│   ├── favicon.ico          # Ícono de la aplicación
│   ├── logo.png             # Logo del sistema
├── src/
│   ├── assets/              # Recursos estáticos (imágenes, fuentes)
│   ├── components/          # Componentes reutilizables
│   │   ├── LoginForm.tsx    # Componente Vista (Formulario de Login)
│   │   ├── LoginForm.less   # Estilos de la Vista
│   ├── configs/             # Configuración global (e.g., temas, API base)
│   │   ├── apiConfig.ts     
│   │   ├── theme.ts    
│   ├── service/             # Servicios para interactuar con APIs
│   │   ├── authService.ts      
│   │   ├── mockApi.ts       # API simulada
│   ├── utils/               # Utilidades generales
│   │   ├── callbackValidator.ts  # Validación de callbacks
│   │   ├── validators.ts    
│   ├── views/               # Componentes de nivel de Vista (e.g., páginas)
│   │   ├── LoginView.tsx 
│   ├── viewmodels/          # VistaModelo (lógica de negocio asociada a la Vista)
│   │   ├── LoginViewModel.ts # Lógica asociada al login
│   ├── stores/              # (Opcional) Gestión de estado global (si necesario)
│   │   ├── authStore.ts        
│   ├── models/              # Modelos (estructura de datos)
│   │   ├── UserModel.ts     # Representación del usuario
│   │   ├── LoginModel.ts    # Representación del login
│   ├── styles/
│   │   ├── global.less      # Estilos globales
│   │   ├── variables.less   # Variables globales de colores y fuentes
│   ├── App.tsx              # Punto de entrada para la Vista principal
│   ├── main.tsx             # Configuración inicial de React
├── package.json             # Configuración de dependencias
├── vite.config.ts           # Configuración de Vite

  </pre>

  <h2>🌈 Paleta de Colores</h2>
  <ul>
    <li><strong>Primary Color:</strong> #2B6777</li>
    <li><strong>Secondary Color:</strong> #52B788</li>
    <li><strong>Background Color:</strong> #F8F9FA</li>
    <li><strong>Form Background:</strong> #FFFFFF</li>
    <li><strong>Text Color:</strong> #1D3557</li>
    <li><strong>Error Color:</strong> #E63946</li>
    <li><strong>Success Color:</strong> #2A9D8F</li>
  </ul>

  <h2>📋 Instalación</h2>
  <ol>
    <li>Clona el repositorio:</li>
    <pre><code>git clone https://github.com/tu-usuario/zeus-siges-login.git</code></pre>
    <li>Instala las dependencias:</li>
    <pre><code>npm install</code></pre>
    <li>Inicia el servidor de desarrollo:</li>
    <pre><code>npm run dev</code></pre>
  </ol>

  <h2>⚙️ Patrón MVVC</h2>
  <p>
    Este proyecto utiliza el patrón <strong>MVVC</strong> para estructurar la lógica y la interacción entre las capas:
  </p>
  <ul>
    <li><strong>Modelo:</strong> Define los datos de la aplicación, como el usuario (<code>UserModel.ts</code>).</li>
    <li><strong>Vista:</strong> Representación visual del formulario de login (<code>LoginForm.tsx</code>).</li>
    <li><strong>VistaModelo:</strong> Gestiona la lógica asociada al login (<code>LoginViewModel.ts</code>).</li>
    <li><strong>Controlador:</strong> Encargado de la interacción con la API de autenticación (<code>AuthController.ts</code>).</li>
  </ul>

  <h2>🛠️ Funcionalidades</h2>
  <ul>
    <li>Formulario de inicio de sesión con validación.</li>
    <li>Integración con API simulada para autenticación.</li>
    <li>Diseño responsive optimizado para dispositivos móviles.</li>
    <li>Soporte para recordar credenciales.</li>
  </ul>

  <h2>📄 Licencia</h2>
  <p>
    Este proyecto está bajo la licencia <strong>MIT</strong>. Siéntete libre de usarlo y modificarlo según tus necesidades.
  </p>
</body>
</html>
