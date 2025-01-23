import http from "../../utils/http";
import { IRepositorioHolaMundo } from "../../dominio/adaptadores/IRepositorioHolaMundo";
import HolaMundoEntidad, { HolaMundoDatos } from "../../dominio/entidades/HolaMundoEntidad";
import Logger from "../../utils/logger";
import EventBus from "../../utils/EventBus";
import { EVENTOS_MF } from "../../config/eventRegistry";

class RepositorioHolaMundo implements IRepositorioHolaMundo {
  async obtenerMensaje(): Promise<HolaMundoDatos> {
    try {
      Logger.info("🔍 Solicitando mensaje desde API...");
      const response = await http.get<HolaMundoDatos>("/mensaje");
      const entidad = new HolaMundoEntidad(response.data);

      Logger.info("✅ Mensaje recibido correctamente:", entidad.obtenerDatos());
      return entidad.obtenerDatos();
    } catch (error: unknown) {
      Logger.error("❌ Error al obtener mensaje:", error);
      
      const errorMessage = error instanceof Error ? error.message : "Error desconocido";
      const errorData = {
        transaccionId: new Date().getTime().toString(),
        mensaje: "Error al obtener el mensaje",
        descripcion: errorMessage,
        fecha: new Date().toISOString(),
      };

      EventBus.emit(EVENTOS_MF.ERROR_SERVICIO, errorData);
      return new HolaMundoEntidad({ id: -1, mensaje: "⚠ Error al obtener mensaje", autor: "Desconocido", fecha: new Date().toISOString() }).obtenerDatos();
    }
  }
}

export default RepositorioHolaMundo;
