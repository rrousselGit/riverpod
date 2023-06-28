import React, { Dispatch, SetStateAction, useEffect, useState } from "react";
import Layout from "@theme-original/DocPage/Layout";
// import {useDoc} from '@docusaurus/theme-common/internal';

// Wrapping <Layout> to add custom contexts available for the entire app.

export default function LayoutWrapper(props) {
  // const doc = useDoc();
  // console.log('Hello', doc )

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

function getBooleanValue(key:string, defaultValue:boolean):boolean {
  const value = localStorage.getItem(key);
  if (value === null || value === undefined) {
    return defaultValue;
  }
  return value === 'true';
}

function Codegen({ children }) {
  const defaultCodeGen = getBooleanValue('codegen-checked', true)
  const defaultFlutterHooks = getBooleanValue('flutter-hooks-checked', true)

  const codegen = useState(defaultCodeGen);
  const flutterHooks = useState(defaultFlutterHooks);

  useEffect(()=>{
    localStorage.setItem('codegen-checked', codegen[0].toString());
    localStorage.setItem('flutter-hooks-checked', flutterHooks[0].toString());
  },[codegen[0],flutterHooks[0]]);

  return (
    <CodegenContext.Provider value={codegen}>
      <FlutterHooksContext.Provider value={flutterHooks}>
        {children}
      </FlutterHooksContext.Provider>
    </CodegenContext.Provider>
  );
}
