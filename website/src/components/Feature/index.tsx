import React, { ReactNode } from "react";

export interface IFeatureProps {
  imageUrl: string;
  title: string;
  description: ReactNode;
}

export const Feature: React.FC<IFeatureProps> = ({
  imageUrl,
  title,
  description,
}) => {
  return (
    <div className="col col--6">
      <h1>{title}</h1>
      <p>{description}</p>
    </div>
  );
};
