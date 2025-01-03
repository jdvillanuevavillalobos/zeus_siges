import { registerApplication } from 'single-spa';

/**
 * Registra un microfrontend en Single-SPA.
 */
export function registerMicrofrontends(microfrontends, loader) {
  microfrontends.forEach(({ name, url, activeWhen, domElement }) => {
    registerApplication({
      name,
      app: () => loader(name, url, domElement),
      activeWhen,
    });
  });
}
