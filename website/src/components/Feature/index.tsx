import React, { ReactNode } from "react";

export interface IFeatureProps {
  title: string;
  description: ReactNode;
}

export const Feature: React.FC<IFeatureProps> = ({ title, description }) => {
  return (
    <div>
      <h1 className="feature__title">{title}</h1>
      <p className="feature__description">{description}</p>
    </div>
  );
};
