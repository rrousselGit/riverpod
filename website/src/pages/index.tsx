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
  { key: "declarative_check", value: "Declarative programming" },
  { key: "network_check", value: "Native network requests support" },
  { key: "error_check", value: "Automatic loading/error handling" },
  { key: "compile_check", value: "Compile safety" },
  { key: "typed_query_check", value: "Type-safe query parameters" },
  { key: "test_check", value: "Test ready" },
  { key: "dart_check", value: "Work in plain Dart (servers/CLI/...)" },
  { key: "combine_check", value: "Easily combinable states" },
  { key: "refresh_check", value: "Built-in support for pull-to-refresh" },
  { key: "lint_check", value: "Custom lint rules" },
  { key: "refactor_check", value: "Built-in refactorings" },
  { key: "hot_reload_check", value: "Hot-reload support" },
  { key: "logger_check", value: "Logging" },
  { key: "socket_check", value: "Websocket support" },
  { key: "graph_check", value: "Documentation generator" },
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
            <Translate
              id="homepage.features_title"
            >
              {`Features`}
            </Translate>
          </h2>
          <ul>
            {checkBoxes.map((check) => (
              <li key={check.key}>
                ✅ <Translate id={`homepage.features_${check.key}`}>{check.value}</Translate>
              </li>
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
