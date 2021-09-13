import React from "react";
import useBaseUrl from "@docusaurus/useBaseUrl";

interface IPreviewProps {
  imageUrl: string;
  title: string;
}

export const Preview: React.FC<IPreviewProps> = ({ imageUrl, title }) => {
  const imgUrl = useBaseUrl(imageUrl);
  return (
    <div className="col">
      <h2>{title}</h2>
      <img alt={title} src={imgUrl}></img>
    </div>
  );
};
