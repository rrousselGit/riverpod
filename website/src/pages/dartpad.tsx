import React from "react";
import Layout from "@theme/Layout";
import { useLocation } from "@docusaurus/router";
import { dartpadUrl } from "../components/DartPad";
import { dartpadExamples } from "../dartpad_examples";

// Redirects `/dartpad?example=name` to DartPad, opened on examples/name.
export default function DartPadRedirect() {
  const example = new URLSearchParams(useLocation().search).get("example");
  const url =
    example !== null && example in dartpadExamples
      ? dartpadUrl(example, { embed: false })
      : null;

  React.useEffect(() => {
    if (url !== null) window.location.replace(url);
  }, [url]);

  return (
    <Layout title="DartPad" noFooter>
      <main className="container margin-vert--xl">
        {url === null ? (
          <p>Unknown DartPad example.</p>
        ) : (
          <p>
            Opening <a href={url}>DartPad</a>…
          </p>
        )}
      </main>
    </Layout>
  );
}
