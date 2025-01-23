import axios from "axios";
import EventBus from "../utils/EventBus";
import { EVENTOS_MF } from "../config/eventRegistry"; // 🔥 Importar correctamente
import config from "../config/config";

const http = axios.create({
  baseURL: config.API_BASE_URL,
  timeout: 10000,
  headers: {
    "Content-Type": "application/json",
  },
});

// ✅ Interceptor para manejar errores y emitir eventos globales
http.interceptors.response.use(
  (response) => response,
  async (error) => {
    const errorInfo = {
      transaccionId: error.response?.data?.transaccionId ?? "N/A",
      mensaje: "Error en petición HTTP",
      descripcion: error.message,
      fecha: new Date().toISOString(),
    };

    EventBus.emit(EVENTOS_MF.ERROR_SERVICIO, errorInfo); // 🔥 Corrección aquí
    
    return Promise.reject(error);
  }
);

export default http;
