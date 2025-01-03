/**
 * Servicio para manejar temas de la aplicación.
 */
let currentTheme = 'light';

export const themeService = {
  setTheme(theme) {
    currentTheme = theme;
    document.documentElement.setAttribute('data-theme', theme);
  },
  getTheme() {
    return currentTheme;
  },
};
