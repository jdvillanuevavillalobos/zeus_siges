import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';

export default defineConfig({
  plugins: [react()],
  css: {
    preprocessorOptions: {
      less: {
        javascriptEnabled: true, // Requerido para Ant Design y Less
      },
    },
  },
  optimizeDeps: {
    include: ['react-is'], // Mantén las optimizaciones existentes
  },
});
