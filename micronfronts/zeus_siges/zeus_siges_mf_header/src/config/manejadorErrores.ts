import Logger from "../utils/logger";

export const manejarErrores = async <T>(fn: () => Promise<T>): Promise<T | null> => {
  try {
    return await fn();
  } catch (error) {
    Logger.error("❌ Error capturado en servicio web:", error);
    return null;
  }
};
