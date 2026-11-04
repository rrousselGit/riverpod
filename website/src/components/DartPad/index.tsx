import * as React from "react";
import { documentTitles } from "../../documents_meta";
import { useDoc } from "@docusaurus/theme-common/internal";

type DartPadProps = {
  id: string;
};

export function DartPad(props: DartPadProps) {
  return (
    <iframe
      src={`https://dartpad.dev/embed-flutter.html?id=${props.id}&run=true`}
      style={{ width: "100%", height: "600px", border: "none" }}
    />
  );
}
