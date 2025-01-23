import React, { createContext, useContext, ReactNode } from "react";
import ControladorHolaMundo from "../interfaces/controladores/ControladorHolaMundo";
import RepositorioHolaMundo from "../infraestructura/adaptadores/RepositorioHolaMundo";
import { IRepositorioHolaMundo } from "../dominio/adaptadores/IRepositorioHolaMundo";

const repositorioHolaMundo: IRepositorioHolaMundo = new RepositorioHolaMundo();
const controladorHolaMundo = new ControladorHolaMundo(repositorioHolaMundo);

const ControladorHolaMundoContext = createContext<ControladorHolaMundo | null>(null);

export const useControladorHolaMundo = (): ControladorHolaMundo => {
  const context = useContext(ControladorHolaMundoContext);
  if (!context) {
    throw new Error("useControladorHolaMundo debe usarse dentro de un ControladorHolaMundoProvider");
  }
  return context;
};

interface ControladorHolaMundoProviderProps {
  children: ReactNode;
}

export const ControladorHolaMundoProvider: React.FC<ControladorHolaMundoProviderProps> = ({ children }) => {
  return (
    <ControladorHolaMundoContext.Provider value={controladorHolaMundo}>
      {children}
    </ControladorHolaMundoContext.Provider>
  );
};
