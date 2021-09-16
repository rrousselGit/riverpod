import React from "react";
import Link from "@docusaurus/Link";
import Translate, { translate } from "@docusaurus/Translate";
import useDocusaurusContext from "@docusaurus/useDocusaurusContext";
import useBaseUrl from "@docusaurus/useBaseUrl";
import CodeBlock from "@theme/CodeBlock";
import SnippetCreate from "!!raw-loader!/static/snippets/create.dart";
import SnippetRead from "!!raw-loader!/static/snippets/read.dart";

export const Banner: React.FC = () => {
  const { siteConfig } = useDocusaurusContext();

  return (
    <header className="hero banner">
      <div className="container">
        <div className="row">
          <div className="col center">
            <h1 className="logo">
              <img src="img/logo.svg" alt="Riverpod logo"></img>
              {siteConfig.title}
            </h1>

            <h1 className="hero__title">
              <Translate id="home.tagline">
                A Reactive State-Management and Dependency Injection Framework
              </Translate>
            </h1>

            <div>
              <Link
                className="button button--secondary button--lg margin-vert-xl"
                to={useBaseUrl("docs/getting_started")}
              >
                <Translate id="home.get_started">Get Started</Translate>
              </Link>
            </div>
          </div>
          <div className="col">
            <CodeBlock
              title={translate({
                id: "home.create_provider",
                message: "Create a Provider",
              })}
            >
              {SnippetCreate}
            </CodeBlock>
            <CodeBlock
              title={translate({
                id: "home.consume_provider",
                message: "Consume the Provider",
              })}
            >
              {SnippetRead}
            </CodeBlock>
          </div>
        </div>
      </div>
    </header>
  );
};
