import ObtenerMensajeHolaMundo from "../../aplicacion/casosDeUso/ObtenerMensajeHolaMundo";
import { IRepositorioHolaMundo } from "../../dominio/adaptadores/IRepositorioHolaMundo";
import EventBus from "../../utils/EventBus";
import { EVENTOS_MF } from "../../config/eventRegistry";
import Logger from "../../utils/logger";

class ControladorHolaMundo {
  private obtenerMensajeHolaMundo: ObtenerMensajeHolaMundo;

  constructor(repositorio: IRepositorioHolaMundo) {
    this.obtenerMensajeHolaMundo = new ObtenerMensajeHolaMundo(repositorio);
    this.cargarMensaje = this.cargarMensaje.bind(this);

    EventBus.off(EVENTOS_MF.LOAD, this.cargarMensaje);
    EventBus.on(EVENTOS_MF.LOAD, this.cargarMensaje);
  }

  private async cargarMensaje() {
    try {
      Logger.info("📡 Cargando mensaje desde `ControladorHolaMundo`...");
      const mensaje = await this.obtenerMensajeHolaMundo.ejecutar();
      EventBus.emit(EVENTOS_MF.MENSAJE_RECIBIDO, mensaje);
    } catch (error: unknown) {
      Logger.error("❌ Error al obtener el mensaje:", error);
      const errorMessage = error instanceof Error ? error.message : "Error desconocido";

      EventBus.emit(EVENTOS_MF.ERROR_SERVICIO, {
        transaccionId: new Date().getTime().toString(),
        mensaje: "Error al obtener el mensaje",
        descripcion: errorMessage,
        fecha: new Date().toISOString(),
      });
    }
  }
}

export default ControladorHolaMundo;
