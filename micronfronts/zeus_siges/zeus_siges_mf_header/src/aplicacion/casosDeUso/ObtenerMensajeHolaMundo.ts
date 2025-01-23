import { IRepositorioHolaMundo } from "../../dominio/adaptadores/IRepositorioHolaMundo";
import { HolaMundoDatos } from "../../dominio/entidades/HolaMundoEntidad";

class ObtenerMensajeHolaMundo {
  private repositorio: IRepositorioHolaMundo;

  constructor(repositorio: IRepositorioHolaMundo) {
    this.repositorio = repositorio;
  }

  async ejecutar(): Promise<HolaMundoDatos> {
    return await this.repositorio.obtenerMensaje();
  }
}

export default ObtenerMensajeHolaMundo;
