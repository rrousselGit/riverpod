import React from "react";
import styles from "./styles.module.scss";
import CodeBlock from "@theme/CodeBlock";
import useBaseUrl from "@docusaurus/useBaseUrl";

interface IHighlightProps {
  title: string;
  description: string;
  snippet?: string;
  imageUrl?: string;
  direction: "regular" | "reverse";
}

export const Highlight: React.FC<IHighlightProps> = ({
  title,
  description,
  snippet,
  imageUrl,
  direction = "regular",
}) => {
  const imgUrl = useBaseUrl(imageUrl);

  const children = [
    <div className="col">
      <h2>{title}</h2>
      <p>{description}</p>
    </div>,
    <div className="col">
      {!!imageUrl ? (
        <img src={imgUrl} alt={title} />
      ) : (
        <CodeBlock className="language-dart">{snippet}</CodeBlock>
      )}
    </div>,
  ];

  return (
    <div className={styles.detailedFeatures}>
      <div className="container">
        <div className="row">
          {direction === "regular" ? children : children.reverse()}
        </div>
      </div>
    </div>
  );
};
