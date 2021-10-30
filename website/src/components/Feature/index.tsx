import React, { ReactNode } from "react";
import { CodeSnippet } from "../CodeSnippet";

export interface IFeatureProps {
  title: string;
  description: ReactNode;
  snippet?: string;
  imageUrl?: string;
}

export const Feature: React.FC<IFeatureProps> = ({
  title,
  description,
  snippet,
  imageUrl,
}) => {
  return (
    <div className="feature__card">
      <div className="feature__content">
        <h1>{title}</h1>
        <p>{description}</p>
      </div>
      <div className="feature__preview">
        {!!imageUrl ? (
          <img src={imageUrl} alt={title} />
        ) : (
          <CodeSnippet>{snippet}</CodeSnippet>
        )}
      </div>
    </div>
  );
};
