/**
 * Precarga microfrontends críticos.
 */
export function preloadMicrofrontends(microfrontends) {
    microfrontends.forEach((name) => {
      System.import(name).catch((error) =>
        console.warn(`Error precargando "${name}":`, error)
      );
    });
  }
  