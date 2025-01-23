import React, { useEffect, useState } from "react";
import { HolaMundoDatos } from "../../dominio/entidades/HolaMundoEntidad";
import EventBus from "../../utils/EventBus";
import { EVENTOS_MF } from "../../config/eventRegistry";

const HolaMundo: React.FC = () => {
  const [mensaje, setMensaje] = useState<HolaMundoDatos | null>(null);

  useEffect(() => {
    console.log("🖥️ `HolaMundo.tsx` se está montando...");
    EventBus.emit(EVENTOS_MF.LOAD);

    const onMensajeRecibido = (data: HolaMundoDatos) => {
      console.log("📩 Evento recibido:", data);
      setMensaje(data);
    };

    const onErrorServicio = (error: any) => {
      console.error("❌ Evento de error recibido:", error);
      alert(
        `🚨 ERROR 🚨\n\nID: ${error.transaccionId}\nMensaje: ${error.mensaje}\nDescripción: ${error.descripcion}\nFecha: ${error.fecha}`
      );
    };

    EventBus.on(EVENTOS_MF.MENSAJE_RECIBIDO, onMensajeRecibido);
    EventBus.on(EVENTOS_MF.ERROR_SERVICIO, onErrorServicio);

    return () => {
      console.log("🛑 Desuscribiéndose de eventos...");
      EventBus.off(EVENTOS_MF.MENSAJE_RECIBIDO, onMensajeRecibido);
      EventBus.off(EVENTOS_MF.ERROR_SERVICIO, onErrorServicio);
    };
  }, []);

  return (
    <div>
      {mensaje ? (
        <>
          <h1>{mensaje.mensaje}</h1>
          <p>Autor: {mensaje.autor}</p>
          <p>Fecha: {mensaje.fecha}</p>
        </>
      ) : (
        <p>Cargando...</p>
      )}
    </div>
  );
};

export default HolaMundo;
