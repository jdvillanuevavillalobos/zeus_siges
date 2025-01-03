import { handleError } from './error-handler';

/**
 * Carga un microfrontend de forma segura.
 */
export async function safeImport(appName, url, domElement) {
  try {
    const response = await fetch(url, { method: 'HEAD' });
    if (!response.ok) {
      throw new Error(`El archivo ${url} no está disponible.`);
    }

    const appModule = await System.import(appName);

    const requiredExports = ['bootstrap', 'mount', 'unmount'];
    const missingExports = requiredExports.filter((exp) => !(exp in appModule));
    if (missingExports.length > 0) {
      throw new Error(
        `El módulo "${appName}" no exporta las funciones requeridas: ${missingExports.join(', ')}.`
      );
    }

    return appModule;
  } catch (error) {
    handleError(appName, domElement, error);
    return {
      bootstrap: () => Promise.resolve(),
      mount: () => Promise.resolve(),
      unmount: () => Promise.resolve(),
    };
  }
}
