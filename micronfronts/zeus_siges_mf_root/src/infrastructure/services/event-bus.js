/**
 * Sistema de eventos global para comunicación entre microfrontends.
 */
const eventBus = {
    events: {},
  
    /**
     * Suscribe un callback a un evento.
     */
    subscribe(eventName, callback) {
      if (!this.events[eventName]) {
        this.events[eventName] = [];
      }
      this.events[eventName].push(callback);
  
      // Devuelve una función para desuscribirse
      return () => {
        this.events[eventName] = this.events[eventName].filter((cb) => cb !== callback);
      };
    },
  
    /**
     * Publica un evento con datos.
     */
    publish(eventName, data) {
      if (this.events[eventName]) {
        this.events[eventName].forEach((callback) => callback(data));
      }
    },
  };
  
  export default eventBus;
  