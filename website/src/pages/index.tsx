import React from "react";
import Link from "@docusaurus/Link";
import Translate, { translate } from "@docusaurus/Translate";
import useBaseUrl from "@docusaurus/useBaseUrl";
import useDocusaurusContext from "@docusaurus/useDocusaurusContext";
import Layout from "@theme/Layout";
import classnames from "classnames";
import { Feature } from "../components/Feature/index";
import { features } from "../data/features";
import styles from "./styles.module.scss";
import CodeBlock from "@theme/CodeBlock";
import SnippetAsync from "!!raw-loader!/static/snippets/async.dart";
import SnippetCombine from "!!raw-loader!/static/snippets/combine.dart";
import SnippetCreate from "!!raw-loader!/static/snippets/create.dart";
import SnippetDeclare from "!!raw-loader!/static/snippets/declare.dart";
import SnippetRead from "!!raw-loader!/static/snippets/read.dart";

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
        {features && features.length > 0 && (
          <section className={styles.features}>
            <div className="container">
              <div className="row">
                {features.map((props, idx) => (
                  <Feature key={idx} {...props} />
                ))}
              </div>
            </div>
          </section>
        )}

        <section>
          <div className={styles.detailedFeatures}>
            <div className="container">
              <div className="row">
                <div className="col">
                  <h2>
                    <Translate id="home.shared_state_title">
                      Declare shared state from anywhere
                    </Translate>
                  </h2>
                  <p
                    dangerouslySetInnerHTML={{
                      __html: translate({
                        id: "home.shared_state_body",
                        message: `No need to jump between your <code>main.dart</code> and your UI files
                          anymore.<br>
                          <br>
                          Place the code of your shared state where it belongs, be
                          it in a separate package or right next to the Widget that
                          needs it,
                          <strong> without losing testability</strong>.`,
                        description: "The homepage input placeholder",
                      }),
                    }}
                  ></p>
                </div>
                <div className="col">
                  <CodeBlock className="language-dart">
                    {SnippetDeclare}
                  </CodeBlock>
                </div>
              </div>
            </div>
          </div>
          <div className={styles.detailedFeatures}>
            <div className="container">
              <div className="row">
                <div className="col">
                  <CodeBlock className="language-dart">
                    {SnippetCombine}
                  </CodeBlock>
                </div>
                <div className="col">
                  <h2>
                    <Translate id="home.recompute_title">
                      Recompute states/rebuild UI only when needed
                    </Translate>
                  </h2>
                  <p>
                    <Translate
                      id="home.recompute_body"
                      values={{
                        br: <br></br>,
                        Provider: (
                          <code>
                            <a
                              href={useBaseUrl(
                                "docs/concepts/combining_providers"
                              )}
                            >
                              Provider
                            </a>
                          </code>
                        ),
                        families: (
                          <a
                            href={useBaseUrl("docs/concepts/modifiers/family")}
                          >
                            "families"
                          </a>
                        ),
                        build: <code>build</code>,
                        truly: <strong>truly</strong>,
                      }}
                    >
                      {`We no-longer have to sort/filter lists inside the {build}
                      method or have to resort to advanced cache mechanism.
                      {br}
                      {br}
                      With {Provider} and {families}, sort your lists or do HTTP
                      requests only when you {truly} need it.`}
                    </Translate>
                  </p>
                </div>
              </div>
            </div>
          </div>
          <div className={styles.detailedFeatures}>
            <div className="container">
              <div className="row">
                <div className="col">
                  <h2>
                    <Translate id="home.safe_read_title">
                      Safely read providers
                    </Translate>
                  </h2>
                  <Translate
                    id="home.safe_read_body"
                    values={{
                      br: <br></br>,
                    }}
                  >
                    {`Reading a provider will never result in a bad state. If you
                  can write the code needed to read a provider, you will obtain
                  a valid value.
                  {br}
                  {br}
                  This even applies to asynchronously loaded values. As opposed
                  to with provider, Riverpod allows cleanly handling
                  loading/error cases.`}
                  </Translate>
                </div>
                <div className="col">
                  <CodeBlock className="language-dart">
                    {SnippetAsync}
                  </CodeBlock>
                </div>
              </div>
            </div>
          </div>
          <div className={styles.detailedFeatures}>
            <div className="container">
              <div className="row">
                <div className="col">
                  <img src="img/intro/devtool.png" alt="Devtool support"></img>
                </div>
                <div className="col">
                  <h2>
                    <Translate id="home.devtool_title">
                      Inspect your state in the devtool
                    </Translate>
                  </h2>
                  <Translate
                    id="home.devtool_body"
                    values={{
                      br: <br></br>,
                    }}
                  >
                    {`Using Riverpod, your state is visible out of the box inside
                    Flutter's devtool. {br} Futhermore, a full-blown
                    state-inspector is in progress.`}
                  </Translate>
                  <h2></h2>
                  <p></p>
                </div>
              </div>
            </div>
          </div>
        </section>
      </main>
    </Layout>
  );
}
