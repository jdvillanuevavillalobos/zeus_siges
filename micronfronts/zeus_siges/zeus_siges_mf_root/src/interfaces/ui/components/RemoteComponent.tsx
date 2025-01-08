import React, { Suspense, LazyExoticComponent } from "react";

interface RemoteComponentProps {
  Component: LazyExoticComponent<React.ComponentType>;
}

const RemoteComponent: React.FC<RemoteComponentProps> = ({ Component }) => (
  <Suspense fallback={<div>Loading Remote Component...</div>}>
    <Component />
  </Suspense>
);

export default RemoteComponent;
