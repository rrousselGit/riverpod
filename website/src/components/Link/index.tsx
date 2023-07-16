import * as React from "react";
import { documentTitles } from "../../../src/documents_meta";
import { useDoc } from "@docusaurus/theme-common/internal";

type LinkProps = {
  documentID: string;
};

export function Link(props: LinkProps) {
  const doc = useDoc();

  const countryCode = doc.metadata.source.startsWith(`@site/i18n/`)
    ? doc.metadata.source.split("/")[2]
    : "en";

  const docTitle = documentTitles[countryCode][props.documentID];

  if (!docTitle) {
    throw new Error(
      `Document title not found for documentID ${props.documentID}`
    );
  }

  return <a href={`/docs/${props.documentID}`}>{docTitle}</a>;
}
