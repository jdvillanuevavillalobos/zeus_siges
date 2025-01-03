/**
 * Obtiene un elemento del DOM por su ID.
 */
export function getDomElement(domElementId) {
  const element = document.getElementById(domElementId);
  if (!element) {
    console.warn(`Elemento "${domElementId}" no encontrado.`);
    return null;
  }
  return element;
}
