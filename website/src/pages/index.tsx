import React from "react";
import SnippetCreate from "!!raw-loader!/static/snippets/create.dart";
import SnippetRead from "!!raw-loader!/static/snippets/read.dart";
import Link from "@docusaurus/Link";
import Translate, { translate } from "@docusaurus/Translate";
import useBaseUrl from "@docusaurus/useBaseUrl";
import useDocusaurusContext from "@docusaurus/useDocusaurusContext";
import CodeBlock from "@theme/CodeBlock";
import Layout from "@theme/Layout";
import classnames from "classnames";
import { Feature } from "../components/Feature/index";
import { Highlight } from "../components/Highlight";
import { features } from "../data/features";
import { highlights } from "../data/highlights";
import styles from "./styles.module.scss";


export default function Home() {
  const { siteConfig } = useDocusaurusContext();
  return (
    <Layout
      title={siteConfig.tagline}
      description="A boilerplate-free and safe way to share state"
    >
      <header className={classnames("hero hero--primary", styles.heroBanner)}>
        <div className="container">
          <h1 className={classnames("hero__title", styles.mainTitle)}>
            <img src="img/logo.svg" alt="Riverpod logo"></img>
            {siteConfig.title}
          </h1>
          <p className="hero__subtitle">
            <Translate id="home.tagline">
              A Reactive State-Management and Dependency Injection framework
            </Translate>
          </p>
          <div className={styles.buttons}>
            <Link
              className={classnames(
                "button button--outline button--secondary button--lg",
                styles.getStarted
              )}
              to={useBaseUrl("docs/getting_started")}
            >
              <Translate id="home.get_started">Get Started</Translate>
            </Link>
          </div>
          <div className="row">
            <div className="col">
              <CodeBlock
                className="language-dart"
                title={translate({
                  id: "home.create_provider",
                  message: "Create a provider",
                })}
              >
                {SnippetCreate}
              </CodeBlock>
            </div>

            <div className="col">
              <CodeBlock
                className="language-dart"
                title={translate({
                  id: "home.consume_provider",
                  message: "Consume the provider",
                })}
              >
                {SnippetRead}
              </CodeBlock>
            </div>
          </div>
        </div>
      </header>

      <main>

        <section className={styles.features}>
          <div className="container">
            <div className="row">
              {features.map((props, idx) => (
                <Feature key={idx} {...props} />
              ))}
            </div>
          </div>
        </section>

        <section>
          {highlights.map((props, idx) => (
            <Highlight
              key={idx}
              {...props}
              direction={idx % 2 === 0 ? "regular" : "reverse"}
            />
          ))}
        </section>
      </main>
    </Layout>
  );
}
