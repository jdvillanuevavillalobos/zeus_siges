import React from "react";

export class RemoteComponentAdapter {
  static load(
    modulePath: string
  ): React.LazyExoticComponent<React.ComponentType> {
    const remoteModules: Record<string, () => Promise<any>> = {
      "zeus_siges_mf_header/HelloWorld": () =>
        import("zeus_siges_mf_header/HelloWorld"),
    };

    if (!remoteModules[modulePath]) {
      throw new Error(`No se encuentra el módulo remoto: ${modulePath}`);
    }

    return React.lazy(remoteModules[modulePath]);
  }
}
