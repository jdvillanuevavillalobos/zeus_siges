import React from 'react';
import ReactDOM from 'react-dom';
import ErrorDisplay from '../../presentation/components/ErrorDisplay'; // Asegúrate de que esta ruta sea correcta

/**
 * Maneja errores al cargar microfrontends.
 *
 * @param {string} appName - Nombre del microfrontend.
 * @param {HTMLElement} domElement - Contenedor donde se renderiza el microfrontend.
 * @param {Error} error - Objeto de error capturado.
 */
export function handleError(appName, domElement, error) {
  console.error(`Error en ${appName}:`, error);

  if (domElement) {
    // Renderiza el componente ErrorDisplay en el contenedor
    ReactDOM.render(
      <ErrorDisplay
        appName={appName}
        errorMessage={error.message}
        onRetry={() => {
          console.log(`Reintentando cargar ${appName}...`);
          // Desmontar el componente de error antes de reintentar
          ReactDOM.unmountComponentAtNode(domElement);
          System.import(appName).catch((retryError) => {
            console.error(`Reintento fallido para ${appName}:`, retryError);
            handleError(appName, domElement, retryError); // Muestra el error nuevamente si el reintento falla
          });
        }}
      />,
      domElement
    );
  }
}
