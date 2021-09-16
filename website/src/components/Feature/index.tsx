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
    <div className="col col--4">
      <div className="text--center">
        <img className="featureImage" src={imageUrl} alt={title} />
      </div>
      <h3>{title}</h3>
      <p>{description}</p>
    </div>
  );
};
