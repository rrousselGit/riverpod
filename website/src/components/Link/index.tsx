import * as React from "react";
import { documentTitles } from "../../../src/documents_meta";
import { useDoc } from "@docusaurus/theme-common/internal";

type LinkProps = {
  documentID: string;
  hash?: string;
};

export function Link(props: LinkProps) {
  const doc = useDoc();

  const countryCode = doc.metadata.source.startsWith(`@site/i18n/`)
    ? doc.metadata.source.split("/")[2]
    : "en";

  const prefix = countryCode === "en"
    ? ""
    : `/${countryCode}`;

  const docTitle = documentTitles[countryCode][props.documentID];

  if (!docTitle) {
    throw new Error(
      `Document title not found for documentID ${props.documentID}`
    );
  }

  const trailing = props.hash ? `#${props.hash}` : "";

  return <a href={`${prefix}/docs/${props.documentID}${trailing}`}>{docTitle}</a>;
}
