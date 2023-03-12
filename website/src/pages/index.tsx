import React from "react";
import useDocusaurusContext from "@docusaurus/useDocusaurusContext";
import Layout from "@theme/Layout";
import { Banner } from "../components/Banner";
import { Feature } from "../components/Feature";
import { Highlight } from "../components/Highlight";
import { features } from "../data/features";
import { highlights } from "../data/highlights";

const checkBoxes = [
  { key: "declarative_check", value: "Declarative programming" },
  { key: "network_check", value: "Native support for network requests" },
  { key: "error_check", value: "Automatic loading/error handling" },
  { key: "conpile_check", value: "Compile safety" },
  { key: "typed_query_check", value: "Type-safe query parameters" },
  { key: "test_check", value: "Test ready" },
  { key: "dart_check", value: "Work in plain Dart (servers/CLI/...)" },
  { key: "combine_check", value: "Easily combinable states" },
  { key: "refresh_check", value: "Built-in support for pull-to-refresh" },
  { key: "lint_check", value: "Custom lint rules" },
  { key: "refactor_check", value: "Built-in refactorings" },
  { key: "hot_reload_check", value: "Hot-reload support" },
  { key: "logger_check", value: "Logger support" },
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

        <section>
          <ul
            style={{
              display: "grid",
              gridTemplateColumns: "repeat(3, 1fr)",
              columnGap: 50,
            }}
          >
            {checkBoxes.map((check) => (
              <li style={{ listStyleType: "none" }} key={check.key}>
                ✅ <strong>{check.value}</strong>
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
