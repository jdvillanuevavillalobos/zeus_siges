// src/viewmodels/LoginViewModel.ts
import { useState } from "react";
import { authenticate } from "../services/authService";

export const useLoginViewModel = () => {
  const [loading, setLoading] = useState(false);
  const [errorMessage, setErrorMessage] = useState<string | null>(null);
  const [user, setUser] = useState<any | null>(null);

  const login = async (email: string, password: string, callback: string) => {
    setLoading(true);
    setErrorMessage(null);

    try {
      const response = await authenticate(email, password, callback);
      if (response.success && response.user) {
        setUser(response.user);
        window.location.href = response.redirectUrl!;
      } else {
        setErrorMessage(response.message || "Login failed");
      }
    } catch (error) {
      setErrorMessage("An error occurred. Please try again.");
    } finally {
      setLoading(false);
    }
  };

  return {
    login,
    loading,
    errorMessage,
    user,
  };
};
