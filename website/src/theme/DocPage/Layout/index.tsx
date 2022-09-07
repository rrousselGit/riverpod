import React, { Dispatch, SetStateAction, useState } from "react";
import Layout from "@theme-original/DocPage/Layout";

export default function LayoutWrapper(props) {
  return (
    <Codegen>
      <Layout {...props} />
    </Codegen>
  );
}

export type ContextValue<S> = [S, Dispatch<SetStateAction<S>>];

export const CodegenContext = React.createContext<ContextValue<boolean>>([
  false,
  (_) => {
    throw 42;
  },
]);

function Codegen({ children }) {
  const codegen = useState(true);

  return (
    <CodegenContext.Provider value={codegen}>
      {children}
    </CodegenContext.Provider>
  );
}
