import * as React from "react";
import { dartpadExamples } from "../../dartpad_examples";

type DartPadProps =
  | {
      /** A GitHub gist ID. */
      id: string;
    }
  | {
      /**
       * The name of a folder in `examples/`, packed by dartpad_generator.js.
       */
      example: string;
    };

export function DartPad(props: DartPadProps) {
  return (
    <iframe
      src={
        "id" in props
          ? gistUrl(props.id)
          : dartpadUrl(props.example, { embed: true })
      }
      style={{ width: "100%", height: "600px", border: "none" }}
    />
  );
}

function gistUrl(id: string) {
  return `https://dartpad.dev/embed-flutter.html?id=${id}&run=true`;
}

/**
 * The DartPad URL of an example. Docs link to it through the `/dartpad`
 * page (`/dartpad?example=name`), as Markdown links can't call this.
 */
export function dartpadUrl(example: string, { embed }: { embed: boolean }) {
  const archive = dartpadExamples[example];
  if (archive === undefined) {
    throw new Error(
      `Unknown DartPad example "${example}". Run: npm run dartpad_generator`
    );
  }

  const params = new URLSearchParams({
    url: `data:application/gzip;base64,${archive}`,
    root: example,
    file: `${example}/lib/main.dart`,
  });
  if (embed) params.set("embed", "true");
  return `https://preview.dartpad.dev/?${params}`;
}
