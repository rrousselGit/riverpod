"use client";

import React, { useContext } from "react";
import CodeBlock from "@theme/CodeBlock";
import Tabs from "@theme/Tabs";
import TabItem from "@theme/TabItem";

import {
  CodegenContext,
  FlutterHooksContext,
} from "../../theme/DocPage/Layout";
import useIsBrowser from "@docusaurus/useIsBrowser";

const START_AT = "/* SNIPPET START */";
const END_AT = "/* SNIPPET END */";

const templateRegex = /^\s*\/\/\s*{@template\s(.+?)}/g;
const endTemplateRegex = /^\s*\/\/\s*{@endtemplate}/g;

type TranslationMap = Record<string, string>;

function findFirstLineWithContent(lines: Array<string>) {
  for (let i = 0; i < lines.length; i++) {
    const line = lines[i];

    const isEmpty = line.trim() === "";
    if (isEmpty) continue;

    const leadingSpaceCharCount = line.length - line.trimStart().length;
    return [i, leadingSpaceCharCount];
  }

  throw new Error("No content found in snippet");
}

export function trimSnippet(
  snippet: string,
  translations?: TranslationMap
): string {
  if (!snippet) return;
  let startAtKeyIndex = snippet.indexOf(START_AT);
  // Substring starts after "/* START" + 1 for the newline
  const startAtOffset =
    startAtKeyIndex < 0 ? 0 : startAtKeyIndex + START_AT.length + 1;

  let endAtIndex = snippet.indexOf(END_AT);
  if (endAtIndex < 0) endAtIndex = undefined;

  snippet = snippet.substring(startAtOffset, endAtIndex);

  let currentTemplateKey: string | undefined;

  const lines = snippet.split("\n");
  let [i, leadingSpacesCharCount] = findFirstLineWithContent(lines);

  const transformedLines: Array<string> = [];

  for (; i < lines.length; i++) {
    let line = lines[i];
    if (leadingSpacesCharCount) {
      line = line.substring(leadingSpacesCharCount);
    }

    const templateMatch = templateRegex.exec(line);
    const endTemplateMatch = endTemplateRegex.exec(line);

    if (templateMatch) {
      if (currentTemplateKey) {
        throw new Error(
          `Nested templates are not supported. Template ${currentTemplateKey} is already open (${templateMatch[1]})`
        );
      }

      const templateKey = templateMatch[1];

      const translation = translations?.[templateKey];

      if (translation) {
        // Replace the content if the template is translated, and insert the new content.
        currentTemplateKey = templateKey;
        transformedLines.push(translation);
      }

      // delete the template markup.
      continue;
    }

    if (endTemplateMatch) {
      currentTemplateKey = undefined;
      continue;
    }

    // If inside a translation, delete the untranslated content.
    if (currentTemplateKey) {
      continue;
    }

    transformedLines.push(line);
  }

  return transformedLines.join("\n");
}

interface CodeSnippetProps {
  title?: string;
  snippet: string;
  translations?: TranslationMap;
}

export const CodeSnippet: React.FC<CodeSnippetProps> = ({
  snippet,
  title,
  translations,
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
      <CodeBlock {...other}>{trimSnippet(snippet, translations)}</CodeBlock>
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
  translations?: TranslationMap;
}) {
  const shouldUseTabs =
    !!props.codegen || !!props.hooks || !!props.hooksCodegen;

  const keys: Array<keyof typeof props> = [
    "codegen",
    "hooks",
    "raw",
    "hooksCodegen",
  ];
  for (const codeKey of keys) {
    const code = props[codeKey];
    if (!code) continue;

    for (const otherKey of keys) {
      if (codeKey == otherKey) continue;
      const otherCode = props[otherKey];

      if (otherCode && code == otherCode) {
        throw new Error(
          `Duplicate code found in ${codeKey} and ${otherKey}. Code:\n${code}`
        );
      }
    }
  }

  function block(rawCode: string | Array<string>) {
    const code = Array.isArray(rawCode) ? rawCode.join("\n") : rawCode;

    return (
      <CodeBlock language={props.language} title={props.title}>
        {trimSnippet(code, props.translations)}
      </CodeBlock>
    );
  }

  if (!shouldUseTabs) return block(props.raw);

  function tab(rawCode: string | Array<string> | undefined, label: string) {
    if (!rawCode) return undefined;

    return (
      <TabItem value={label} label={label}>
        {block(rawCode)}
      </TabItem>
    );
  }

  return (
    <Tabs>
      {tab(props.raw, "riverpod")}
      {tab(props.hooks, "riverpod + flutter_hooks")}
      {tab(props.codegen, "riverpod_generator")}
      {tab(props.hooksCodegen, "riverpod_generator + flutter_hooks")}
    </Tabs>
  );
}

export function When(props: {
  hooks?: boolean;
  codegen?: boolean;
  children: string;
}) {
  const [codegen] = useIsBrowser() ? useContext(CodegenContext) : [true];
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
