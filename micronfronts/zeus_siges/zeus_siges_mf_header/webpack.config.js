const HtmlWebpackPlugin = require("html-webpack-plugin");
const ModuleFederationPlugin = require("webpack").container.ModuleFederationPlugin;
const path = require("path");
const Dotenv = require("dotenv-webpack");

module.exports = {
  mode: "development",
  entry: "./src/index.ts",  
  output: {
    publicPath: "http://localhost:3001/",
  },
  devServer: {
    port: 3001,
    static: path.join(__dirname, "public"),
    hot: true,
  },
  plugins: [
    new ModuleFederationPlugin({
      name: "zeus_siges_mf_header",
      filename: "remoteEntry.js",
      exposes: {
       "./HolaMundo": "./src/interfaces/ui/HolaMundo.tsx",  
      },
      shared: {
        react: { singleton: true, requiredVersion: "^18.3.1" },
        "react-dom": { singleton: true, requiredVersion: "^18.3.1" },
      },
    }),
    new HtmlWebpackPlugin({
      template: "./public/index.html",
    }),
    new Dotenv(),
  ],
  module: {
    rules: [
      {
        test: /\.[jt]sx?$/,  
        exclude: /node_modules/,
        use: {
          loader: "babel-loader",
          options: {
            presets: ["@babel/preset-env", "@babel/preset-react", "@babel/preset-typescript"]
          }
        },
      },
    ],
  },
  resolve: {
    extensions: [".ts", ".tsx", ".js", ".jsx"],  
  },
};
