import * as React from "react";
import { createRoot } from "react-dom/client";
import HolaMundo from "./interfaces/ui/HolaMundo";
import { ControladorHolaMundoProvider } from "./config/contenedorDI";

console.log("🚀 Bootstrap.tsx está ejecutándose...");

const Aplicacion = () => (
  <ControladorHolaMundoProvider>
    <HolaMundo />
  </ControladorHolaMundoProvider>
);

const rootElement = document.getElementById("root");
if (rootElement) {
  console.log("✅ Encontrado #root en el DOM.");
  createRoot(rootElement).render(<Aplicacion />);
  console.log("📡 Aplicación montada correctamente...");
} else {
  console.error("❌ No se encontró el elemento #root en el DOM.");
}
