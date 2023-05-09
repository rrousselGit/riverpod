import React from "react";
import useDocusaurusContext from "@docusaurus/useDocusaurusContext";
import Layout from "@theme/Layout";
import { Banner } from "../components/Banner";
import { Feature } from "../components/Feature";
import { Highlight } from "../components/Highlight";
import { features } from "../data/features";
import { highlights } from "../data/highlights";
import Translate from "@docusaurus/Translate";

const checkBoxes = [
  {
    key: "homepage.features_declarative_check",
    value: <Translate>Declarative programming</Translate>,
  },
  {
    key: "homepage.features_network_check",
    value: <Translate>Native network requests support</Translate>,
  },
  {
    key: "homepage.features_error_check",
    value: <Translate>Automatic loading/error handling</Translate>,
  },
  {
    key: "homepage.features_compile_check",
    value: <Translate>Compile safety</Translate>,
  },
  {
    key: "homepage.features_typed_query_check",
    value: <Translate>Type-safe query parameters</Translate>,
  },
  {
    key: "homepage.features_test_check",
    value: <Translate>Test ready</Translate>,
  },
  {
    key: "homepage.features_dart_check",
    value: <Translate>Work in plain Dart (servers/CLI/...)</Translate>,
  },
  {
    key: "homepage.features_combine_check",
    value: <Translate>Easily combinable states</Translate>,
  },
  {
    key: "homepage.features_refresh_check",
    value: <Translate>Built-in support for pull-to-refresh</Translate>,
  },
  {
    key: "homepage.features_lint_check",
    value: <Translate>Custom lint rules</Translate>,
  },
  {
    key: "homepage.features_refactor_check",
    value: <Translate>Built-in refactorings</Translate>,
  },
  {
    key: "homepage.features_hot_reload_check",
    value: <Translate>Hot-reload support</Translate>,
  },
  {
    key: "homepage.features_logger_check",
    value: <Translate>Logging</Translate>,
  },
  {
    key: "homepage.features_socket_check",
    value: <Translate>Websocket support</Translate>,
  },
  {
    key: "homepage.features_graph_check",
    value: <Translate>Documentation generator</Translate>,
  },
];

export default function Home() {
  const { siteConfig } = useDocusaurusContext();
  return (
    <Layout
      title={siteConfig.tagline}
      // Description for search engines
      description={siteConfig.tagline}
    >
      <Banner />

      <main>
        <section>
          <div className="highlight__container">
            {highlights.map((props, index) => (
              <Highlight key={`highlight-${index}`} {...props} />
            ))}
          </div>
        </section>

        <section className="features">
          <h2>
            <Translate id="homepage.features_title">{`Features`}</Translate>
          </h2>
          {
            // TIPS: TEXT LABELS MUST BE STATIC
            // MORE INFO at https://docusaurus.io/docs/i18n/tutorial
          }
          <ul>
            {checkBoxes.map((check) => (
              <li key={check.key}>✅ {check.value}</li>
            ))}
          </ul>
        </section>

        <section>
          {features.map((props, index) => (
            <Feature
              key={`feature-${index}`}
              {...props}
              direction={index % 2 == 0 ? "normal" : "reverse"}
            />
          ))}
        </section>
      </main>
    </Layout>
  );
}
