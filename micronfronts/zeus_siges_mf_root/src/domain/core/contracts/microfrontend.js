/**
 * Clase Microfrontend
 * Representa la configuración necesaria para registrar un microfrontend.
 */
export class Microfrontend {
    /**
     * Constructor de Microfrontend.
     * @param {string} name - Nombre único del microfrontend.
     * @param {string} url - URL donde se encuentra el bundle del microfrontend.
     * @param {Function} activeWhen - Función que determina cuándo activar este microfrontend.
     * @param {string} domElement - ID del elemento DOM donde se montará el microfrontend.
     */
    constructor(name, url, activeWhen, domElement) {
      this.name = name;
      this.url = url;
      this.activeWhen = activeWhen;
      this.domElement = domElement;
    }
  }
  