// src/service/authService.ts
import { loginApi } from "./mockApi";
import { isValidCallback } from "../utils/callbackValidator";

export const authenticate = async (
  email: string,
  password: string,
  callbackUrl: string
) => {
  // Validar el callback antes de llamar al mockApi
  const safeCallbackUrl = isValidCallback(callbackUrl) ? callbackUrl : "/";

  // Llamar al API simulada con el callback validado
  return await loginApi(email, password, safeCallbackUrl);
};
