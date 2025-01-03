import React from 'react';
import PropTypes from 'prop-types';

/**
 * Componente para mostrar errores con soporte de reintento.
 *
 * @param {Object} props
 * @param {string} props.appName - Nombre del microfrontend con error.
 * @param {string} props.errorMessage - Mensaje del error.
 * @param {Function} props.onRetry - Función que se ejecuta al hacer clic en "Reintentar".
 */
const ErrorDisplay = ({ appName, errorMessage, onRetry }) => {
  return (
    <div
      style={{
        border: '1px solid red',
        backgroundColor: '#ffeeee',
        padding: '10px',
        borderRadius: '4px',
        textAlign: 'center',
      }}
    >
      <h3>⚠️ Error al cargar "{appName}"</h3>
      <p>{errorMessage}</p>
      <button
        onClick={onRetry}
        style={{
          backgroundColor: '#ff4d4d',
          color: 'white',
          border: 'none',
          padding: '10px 20px',
          borderRadius: '4px',
          cursor: 'pointer',
        }}
      >
        Reintentar
      </button>
    </div>
  );
};

ErrorDisplay.propTypes = {
  appName: PropTypes.string.isRequired,
  errorMessage: PropTypes.string.isRequired,
  onRetry: PropTypes.func.isRequired,
};

export default ErrorDisplay;
