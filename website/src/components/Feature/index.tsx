import React, { ReactNode } from "react";
import classnames from "classnames";
import styles from "./styles.module.scss";

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
    <div className={classnames("col col--4")}>
      <div className="text--center">
        <img className={styles.featureImage} src={imageUrl} alt={title} />
      </div>
      <h3>{title}</h3>
      <p>{description}</p>
    </div>
  );
};
