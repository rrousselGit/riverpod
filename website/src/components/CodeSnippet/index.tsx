"use client";

import React, { ReactElement, useContext, useEffect, useState } from "react";
import CodeBlock from "@theme/CodeBlock";
import {
  CodegenContext,
  FlutterHooksContext,
} from "../../theme/DocPage/Layout";
import useIsBrowser from '@docusaurus/useIsBrowser';

const START_AT = "/* SNIPPET START */";
const END_AT = "/* SNIPPET END */";

export function trimSnippet(snippet: string): string {
  if (!snippet) return;
  const startAtIndex = snippet.indexOf(START_AT);
  if (startAtIndex < 0) return snippet;

  let endAtIndex = snippet.indexOf(END_AT);
  if (endAtIndex < 0) endAtIndex = undefined;

  // Substring starts after "/* START" + 1 for the newline
  snippet = snippet.substring(startAtIndex + START_AT.length + 1, endAtIndex);

  const leadingSpaces = snippet.match(/^\s+/);
  if (leadingSpaces) {
    const leadingSpaceCount = leadingSpaces[0].length;
    snippet = snippet
      .split("\n")
      .map((line) =>
        line.startsWith(leadingSpaces[0])
          ? line.substring(leadingSpaceCount)
          : line
      )
      .join("\n");
  }

  return snippet;
}

interface CodeSnippetProps {
  title?: string;
  snippet: string;
}

export const CodeSnippet: React.FC<CodeSnippetProps> = ({
  snippet,
  title,
  ...other
}) => {
  return (
    <div className={`snippet`}>
      <div className="snippet__title_bar">
        <div className="snippet__dots">
          <div className="snippet__dot"></div>
          <div className="snippet__dot"></div>
          <div className="snippet__dot"></div>
        </div>
        <div className="snippet__title">{title}</div>
      </div>
      <CodeBlock {...other}>{trimSnippet(snippet)}</CodeBlock>
    </div>
  );
};

export function AutoSnippet(props: {
  title?: string;
  language?: string;
  codegen?: string | Array<string>;
  hooksCodegen?: string | Array<string>;
  raw: string | Array<string>;
  hooks?: string | Array<string>;
}) {
  const [codegen] = useIsBrowser()
    ? useContext(CodegenContext)
    : [true];
  const [hooksEnabled] = useIsBrowser()
    ? useContext(FlutterHooksContext)
    : [false];

  let snippet: string | Array<string>;
  if (codegen && hooksEnabled) {
    snippet = props.hooksCodegen;
  }
  if (codegen) {
    snippet ??= props.codegen;
  }
  if (!codegen && hooksEnabled) {
    snippet ??= props.hooks;
  }
  snippet ??= props.raw;

  const code = Array.isArray(snippet) ? snippet.join("\n") : snippet;

  return (
    <CodeBlock language={props.language} title={props.title}>
      {trimSnippet(code)}
    </CodeBlock>
  );
}

export function When(props: {
  hooks?: boolean;
  codegen?: boolean;
  children: string;
}) {
  const [codegen] = useIsBrowser()
    ? useContext(CodegenContext)
    : [true];
  const [hooksEnabled] = useIsBrowser()
    ? useContext(FlutterHooksContext)
    : [false];

  if (
    (props.codegen == undefined || props.codegen == codegen) &&
    (props.hooks == undefined || props.hooks == hooksEnabled)
  ) {
    return props.children;
  }

  return <></>;
}
