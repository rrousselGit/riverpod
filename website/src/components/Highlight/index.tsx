import React, { ReactNode } from "react";
import { CodeSnippet } from "../CodeSnippet";

export interface IHighlightProps {
  title: string;
  description: ReactNode;
  snippet?: string;
  imageUrl?: string;
}

export const Highlight: React.FC<IHighlightProps> = ({
  title,
  description,
  snippet,
  imageUrl,
}) => {
  return (
    <div className="highlight__card">
      <div className="highlight__content">
        <h1>{title}</h1>
        <p>{description}</p>
      </div>
      <div className="highlight__preview">
        {!!imageUrl ? (
          <img src={imageUrl} alt={title} />
        ) : (
          <CodeSnippet>{snippet}</CodeSnippet>
        )}
      </div>
    </div>
  );
};
