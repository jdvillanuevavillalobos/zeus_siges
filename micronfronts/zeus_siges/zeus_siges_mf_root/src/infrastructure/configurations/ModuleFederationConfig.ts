const ModuleFederationConfig = {
  remotes: {
    zeus_siges_mf_header:
      "zeus_siges_mf_header@http://localhost:3001/remoteEntry.js",
  },
};

module.exports = ModuleFederationConfig;
