import React from "react";
import useBaseUrl from "@docusaurus/useBaseUrl";
import classnames from "classnames";
import styles from "./styles.module.scss";

interface IFeatureProps {
  imageUrl: string;
  title: string;
  description: string;
}

export const Feature: React.FC<IFeatureProps> = ({
  imageUrl,
  title,
  description,
}) => {
  const imgUrl = useBaseUrl(imageUrl);
  return (
    <div className={classnames("col col--4", styles.feature)}>
      {imgUrl && (
        <div className="text--center">
          <img className={styles.featureImage} src={imgUrl} alt={title} />
        </div>
      )}
      <h3>{title}</h3>
      <p>{description}</p>
    </div>
  );
};
