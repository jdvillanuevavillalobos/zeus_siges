import { Microfrontend } from '@domain/core/contracts/microfrontend';

/**
 * Configuración de los microfrontends registrados en el contenedor.
 */
export const microfrontends = [
  new Microfrontend(
    'zeus_siges_mf_header',
    'http://localhost:8081/header.js',
    () => true,
    'header'
  ),
  new Microfrontend(
    'zeus_siges_mf_menu',
    'http://localhost:8082/menu.js',
    () => true,
    'menu'
  ),
  new Microfrontend(
    'app1',
    'http://localhost:8083/app1.js',
    (location) => location.pathname.startsWith('/app1'),
    'content'
  ),
  new Microfrontend(
    'app2',
    'http://localhost:8084/app2.js',
    (location) => location.pathname.startsWith('/app2'),
    'content'
  ),
];
