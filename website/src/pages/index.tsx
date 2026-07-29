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

        <section className="features_checklist">
          <div className="features_checklist__container">
            <h2 className="features_checklist__title">
              <Translate id="homepage.features_title">Features</Translate>
            </h2>
            <p className="features_checklist__subtitle">
              <Translate id="homepage.features_subtitle">
                Everything you need to build robust, scalable, and maintainable Dart & Flutter applications.
              </Translate>
            </p>
            <div className="features_checklist__grid">
              {checkBoxes.map((check) => (
                <div className="features_checklist__card" key={check.key}>
                  <div className="features_checklist__icon">
                    <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round">
                      <polyline points="20 6 9 17 4 12" />
                    </svg>
                  </div>
                  <span className="features_checklist__text">
                    <Translate id={`homepage.features_${check.key}`}>{check.value}</Translate>
                  </span>
                </div>
              ))}
            </div>
          </div>
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

        <section className="sponsors_section">
          <div className="sponsors_section__container">
            <h2 className="sponsors_section__title">
              <Translate id="homepage.sponsors_title">Sponsors</Translate>
            </h2>
            <p className="sponsors_section__subtitle">
              <Translate id="homepage.sponsors_subtitle">
                Riverpod is open source software funded by the community and our generous sponsors.
              </Translate>
            </p>
            <div className="sponsors_section__content">
              <a
                href="https://github.com/sponsors/rrousselGit"
                target="_blank"
                rel="noopener noreferrer"
                className="sponsors_section__link"
              >
                <img
                  src="https://raw.githubusercontent.com/rrousselGit/freezed/master/sponsorkit/sponsors.svg"
                  alt="Riverpod Sponsors"
                  className="sponsors_section__img"
                />
              </a>
            </div>
            <div className="sponsors_section__cta_wrap">
              <a
                href="https://github.com/sponsors/rrousselGit"
                target="_blank"
                rel="noopener noreferrer"
                className="sponsors_section__cta"
              >
                <span className="sponsors_section__heart">💖</span>
                <Translate id="homepage.sponsors_cta">Become a Sponsor</Translate>
              </a>
            </div>
          </div>
        </section>
      </main>
    </Layout>
  );
}
