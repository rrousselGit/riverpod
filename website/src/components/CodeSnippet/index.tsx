import React, { ReactElement } from "react";
import CodeBlock from "@theme/CodeBlock";

const START_AT = "/* SNIPPET START */";

export function trimSnippet(snippet: string): string {
  const startAtIndex = snippet.indexOf(START_AT);
  if (startAtIndex < 0) return snippet;

  return snippet.substring(startAtIndex + START_AT.length).trim();
}

interface CodeSnippetProps {
  title?: string;
  snippet: string;
}

export const CodeSnippet: React.FC<CodeSnippetProps> = ({ snippet, title }) => {
  return (
    <div className="snippet">
      <div className="snippet__title_bar">
        <div className="snippet__dots">
          <div className="snippet__dot"></div>
          <div className="snippet__dot"></div>
          <div className="snippet__dot"></div>
        </div>
        <div className="snippet__title">{title}</div>
      </div>
      <CodeBlock>{trimSnippet(snippet)}</CodeBlock>
    </div>
  );
};
