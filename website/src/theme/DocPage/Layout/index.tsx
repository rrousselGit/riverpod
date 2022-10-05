import React, { Dispatch, SetStateAction, useState } from "react";
import Layout from "@theme-original/DocPage/Layout";

// Wrapping <Layout> to add custom contexts available for the entire app.

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

export const FlutterHooksContext = React.createContext<ContextValue<boolean>>([
  false,
  (_) => {
    throw 42;
  },
]);

function Codegen({ children }) {
  const codegen = useState(true);
  const flutterHooks = useState(false);

  return (
    <CodegenContext.Provider value={codegen}>
      <FlutterHooksContext.Provider value={flutterHooks}>
        {children}
      </FlutterHooksContext.Provider>
    </CodegenContext.Provider>
  );
}
