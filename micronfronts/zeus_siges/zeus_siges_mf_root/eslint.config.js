const { FlatESLint } = require("eslint");

module.exports = [
  {
    ignores: ["node_modules", "dist"], // Archivos y directorios a ignorar
    files: ["src/**/*.{ts,tsx,js,jsx}"], // Archivos a analizar
    languageOptions: {
      parser: require("@typescript-eslint/parser"),
      parserOptions: {
        ecmaVersion: "latest",
        sourceType: "module",
        ecmaFeatures: {
          jsx: true,
        },
      },
    },
    plugins: {
      "@typescript-eslint": require("@typescript-eslint/eslint-plugin"),
      react: require("eslint-plugin-react"),
    },
    rules: {
      "react/react-in-jsx-scope": "off",
      "@typescript-eslint/no-unused-vars": "warn",
    },
  },
];
