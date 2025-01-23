class Logger {
    static info(message: string, data?: any) {
      console.info(`ℹ️ [INFO]: ${message}`, data || "");
    }
  
    static warn(message: string, data?: any) {
      console.warn(`⚠️ [WARN]: ${message}`, data || "");
    }
  
    static error(message: string, error?: any) {
      console.error(`❌ [ERROR]: ${message}`, error || "");
    }
  }
  
  export default Logger;
  