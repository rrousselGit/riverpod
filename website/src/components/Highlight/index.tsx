import React, { ReactNode } from "react";

export interface IHighlightProps {
  imageUrl: string;
  title: string;
  description: ReactNode;
}

export const Highlight: React.FC<IHighlightProps> = ({
  imageUrl,
  title,
  description,
}) => {
  return (
    <div className="highlight">
      <img className="highlight__illustration" src={imageUrl} alt={title} />
      <h2 className="highlight__title">{title}</h2>
      <p className="highlight__description">{description}</p>
    </div>
  );
};
