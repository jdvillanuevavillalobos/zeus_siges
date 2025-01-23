import { HolaMundoDatos } from "../entidades/HolaMundoEntidad";

export interface IRepositorioHolaMundo {
  obtenerMensaje(): Promise<HolaMundoDatos>;
}
