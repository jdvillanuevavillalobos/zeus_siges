import { EventEmitter } from "events";
import { EVENTOS_MF } from "../config/eventRegistry";
import Logger from "./logger";

/**
 * Clase centralizada para la gestión de eventos.
 */
class EventBusClass extends EventEmitter {
  private eventListeners: Map<string, Set<(...args: any[]) => void>> = new Map();

  on(event: string, listener: (...args: any[]) => void): this {
    if (!this.eventListeners.has(event)) {
      this.eventListeners.set(event, new Set());
    }
    this.eventListeners.get(event)?.add(listener);
    Logger.info(`🟢 Evento registrado: ${event}`);
    return super.on(event, listener);
  }

  off(event: string, listener: (...args: any[]) => void): this {
    if (this.eventListeners.has(event)) {
      this.eventListeners.get(event)?.delete(listener);
      Logger.info(`🛑 Evento removido: ${event}`);
    }
    return super.off(event, listener);
  }

  emit(event: string, ...args: any[]): boolean {
    Logger.info(`📢 Emitiendo evento: ${event}`, args);
    return super.emit(event, ...args);
  }

  getListeners(event: string): number {
    return this.eventListeners.get(event)?.size || 0;
  }

  listRegisteredEvents(): void {
    Logger.info("📋 Eventos registrados:", Array.from(this.eventListeners.keys()));
  }
}

const EventBus = new EventBusClass();

export { EVENTOS_MF }; // 🔥 Los eventos se importan desde `eventRegistry.ts`
export default EventBus;
