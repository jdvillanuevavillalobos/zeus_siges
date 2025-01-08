import React from "react";
import ReactDOM from "react-dom/client";
import App from "../interfaces/ui/containers/App";

const container = document.getElementById("root");

if (!container) {
  throw new Error("El elemento root no existe en el DOM.");
}

const root = ReactDOM.createRoot(container);
root.render(<App />);
