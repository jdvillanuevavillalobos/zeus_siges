// src/utils/callbackValidator.ts

// Lista de URLs permitidas para redirección
const allowedUrls = [
    "https://cliente1.app.com/dashboard",
    "https://cliente2.app.com/home",
    "https://miapp.com/perfil",
    "https://localhost:1223/perfil",
  ];
  
  // Función para validar si una URL está en la lista blanca
  export const isValidCallback = (callbackUrl: string): boolean => {
    try {
      const url = new URL(callbackUrl);
      return allowedUrls.includes(url.origin + url.pathname);
    } catch (error) {
      // Si la URL es inválida, devuelve falso
      return false;
    }
  };
  