import React from "react";
import RemoteComponent from "../components/RemoteComponent";
import { RemoteComponentService } from "../../../application/services/RemoteComponentService";

const App: React.FC = () => {
  const RemoteHelloWorld = RemoteComponentService.loadComponent(
    "zeus_siges_mf_header/HelloWorld"
  );

  return (
    <div>
      <h1>Host Application</h1>
      <RemoteComponent Component={RemoteHelloWorld} />
    </div>
  );
};

export default App;
