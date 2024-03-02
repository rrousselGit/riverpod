"use client";

import React, { Dispatch, SetStateAction, useEffect, useState } from "react";
import Layout from "@theme-original/DocPage/Layout";
import BrowserOnly from "@docusaurus/BrowserOnly";
// import {useDoc} from '@docusaurus/theme-common/internal';
import useIsBrowser from "@docusaurus/useIsBrowser";

// Wrapping <Layout> to add custom contexts available for the entire app.

export default function LayoutWrapper(props) {
  if (!useIsBrowser()) {
    return <Layout {...props} />;
  }

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

function useSavedState(key: string, defaultValue: boolean) {
  let saved = localStorage.getItem(key);
  let value: boolean;
  if (saved === null || saved === undefined) {
    value = defaultValue;
  } else {
    value = saved === "true";
  }
  const state = useState(value);
  useEffect(() => {
    localStorage.setItem(key, state[0].toString());
  }, [state[0]]);
  return state;
}

function Codegen({ children }) {
  const codegen = useSavedState("codegen-checked", true);
  const flutterHooks = useSavedState("flutter-hooks-checked", false);

  return (
    <CodegenContext.Provider value={codegen}>
      <FlutterHooksContext.Provider value={flutterHooks}>
        {children}
      </FlutterHooksContext.Provider>
    </CodegenContext.Provider>
  );
}
