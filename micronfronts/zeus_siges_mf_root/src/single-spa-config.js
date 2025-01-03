import { registerApplication, start } from 'single-spa';
import { microfrontends } from '@infrastructure/config/microfrontends';
import { safeImport } from '@infrastructure/services/microfrontend-loader';
import { getDomElement } from '@infrastructure/services/dom-helper';

/**
 * Precarga los microfrontends críticos.
 */
function preloadMicrofrontends() {
  ['zeus_siges_mf_header', 'zeus_siges_mf_menu'].forEach((name) =>
    System.import(name).catch((error) =>
      console.warn(`Error precargando "${name}":`, error)
    )
  );
}

/**
 * Registra microfrontends en Single-SPA.
 */
microfrontends.forEach(({ name, url, activeWhen, domElement }) => {
  const element = getDomElement(domElement);
  if (!element) {
    console.warn(`Elemento "${domElement}" no encontrado.`);
    return;
  }

  registerApplication({
    name,
    app: () => safeImport(name, url, element),
    activeWhen,
    customProps: { domElement: element },
  });
});

preloadMicrofrontends();
start();
