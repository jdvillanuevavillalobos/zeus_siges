// src/service/mockApi.ts

interface User {
    id: number;
    name: string;
    email: string;
    role: string;
  }
  
  interface LoginResponse {
    success: boolean;
    token?: string;
    user?: User;
    message?: string;
    redirectUrl?: string;
  }
  
  // Base de datos simulada
  const mockUsers: User[] = [
    {
      id: 1,
      name: "John Doe",
      email: "john.doe@example.com",
      role: "admin",
    },
    {
      id: 2,
      name: "Jane Smith",
      email: "jane.smith@example.com",
      role: "user",
    },
    {
      id: 3,
      name: "Alice Johnson",
      email: "alice.johnson@example.com",
      role: "user",
    },
  ];
  
  // Credenciales simuladas (email y contraseñas)
  const credentials = {
    "john.doe@example.com": "password123",
    "jane.smith@example.com": "mypassword",
    "alice.johnson@example.com": "alicepass",
  };
  
  // Función para simular el endpoint de login
  export const loginApi = async (
    email: string,
    password: string,
    callbackUrl: string
  ): Promise<LoginResponse> => {
    return new Promise((resolve) => {
      setTimeout(() => {
        const user = mockUsers.find((u) => u.email === email);
        const isValidPassword = credentials[email] === password;
  
        if (user && isValidPassword) {
          resolve({
            success: true,
            token: `mock-token-${user.id}`,
            user: {
              id: user.id,
              name: user.name,
              email: user.email,
              role: user.role,
            },
            redirectUrl: callbackUrl,
          });
        } else {
          resolve({
            success: false,
            message: "Invalid email or password",
          });
        }
      }, 1000); // Simula un retraso de red
    });
  };
  