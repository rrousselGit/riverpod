import React, { ReactNode } from "react";
import { CodeSnippet } from "../CodeSnippet";

export interface IFeatureProps {
  title: string;
  description: ReactNode;
  snippet?: string;
  imageUrl?: string;
  direction?: "normal" | "reverse";
}

export const Feature: React.FC<IFeatureProps> = ({
  title,
  description,
  snippet,
  imageUrl,
  direction = "normal",
}) => {
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
          <CodeSnippet snippet={snippet}></CodeSnippet>
        )}
      </div>
    </div>
  );
};
