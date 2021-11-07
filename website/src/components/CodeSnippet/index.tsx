import React, { ReactElement } from "react";
import CodeBlock from "@theme/CodeBlock";

interface CodeSnippetProps {
  title?: string;
  children: string | ReactElement;
}

export const CodeSnippet: React.FC<CodeSnippetProps> = ({
  children,
  title,
}) => {
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
      <CodeBlock>{children.toString().trim()}</CodeBlock>
    </div>
  );
};
