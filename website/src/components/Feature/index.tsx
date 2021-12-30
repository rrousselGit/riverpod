import React, { ReactNode, useMemo } from "react";
import { CodeSnippet } from "../CodeSnippet";

export interface IFeatureProps {
  title: string;
  description: ReactNode;
  snippet?: string;
  imageUrl?: string;
  direction?: "normal" | "reverse";
}

const START_AT = "/* SNIPPET START */";

export const Feature: React.FC<IFeatureProps> = ({
  title,
  description,
  snippet,
  imageUrl,
  direction = "normal",
}) => {
  const trimmedSnippet = useMemo(() => {
    if (!snippet) return;

    const startAtIndex = snippet.indexOf(START_AT);
    if (startAtIndex < 0) return snippet;

    return snippet.substring(startAtIndex + START_AT.length).trim();
  }, [snippet]);

  return (
    <div className={`feature__card feature__card--${direction}`}>
      <div className="feature__content">
        <h1>{title}</h1>
        <p>{description}</p>
      </div>
      <div className="feature__space"></div>
      <div className="feature__preview">
        {imageUrl ? (
          <img src={imageUrl} alt={title} />
        ) : (
          <CodeSnippet>{trimmedSnippet}</CodeSnippet>
        )}
      </div>
    </div>
  );
};
