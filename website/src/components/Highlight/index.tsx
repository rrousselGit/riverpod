import React, { ReactNode } from "react";
import CodeBlock from "@theme/CodeBlock";

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
    <div className="highlight--card padding--xl">
      <div className="container">
        <div className="row">
          <div className="col col--4 center">
            <h1>{title}</h1>
            <p>{description}</p>
          </div>
          <div className="col col--1"></div>
          <div className="col col--7">
            {!!imageUrl ? (
              <img src={imageUrl} alt={title} />
            ) : (
              <CodeBlock>{snippet}</CodeBlock>
            )}
          </div>
        </div>
      </div>
    </div>
  );
};
