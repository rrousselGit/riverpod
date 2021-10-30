import React, { ReactNode } from "react";

export interface IHighlightProps {
  title: string;
  description: ReactNode;
}

export const Highlight: React.FC<IHighlightProps> = ({ title, description }) => {
  return (
    <div>
      <h1 className="highlight__title">{title}</h1>
      <p className="highlight__description">{description}</p>
    </div>
  );
};
