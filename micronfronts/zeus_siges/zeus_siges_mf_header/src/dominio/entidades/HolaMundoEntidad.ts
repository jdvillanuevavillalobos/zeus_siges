import { v4 as uuidv4 } from "uuid";

export interface HolaMundoDatos {
  id: number;
  mensaje: string;
  autor: string;
  fecha: string;
  transaccionId?: string;
}

class HolaMundoEntidad {
  private readonly datos: HolaMundoDatos;

  constructor(datos: HolaMundoDatos) {
    this.datos = {
      ...datos,
      transaccionId: datos.transaccionId ?? uuidv4(),
    };
  }

  obtenerMensaje(): string {
    return this.datos.mensaje;
  }

  obtenerDatos(): HolaMundoDatos {
    return { ...this.datos };
  }

  obtenerTransaccionId(): string {
    return this.datos.transaccionId!;
  }

  static crearDesdeJson(json: any): HolaMundoEntidad {
    if (
      typeof json.id !== "number" ||
      typeof json.mensaje !== "string" ||
      typeof json.autor !== "string" ||
      typeof json.fecha !== "string"
    ) {
      throw new Error("Datos inválidos para HolaMundoEntidad");
    }
    return new HolaMundoEntidad(json);
  }
}

export default HolaMundoEntidad;
