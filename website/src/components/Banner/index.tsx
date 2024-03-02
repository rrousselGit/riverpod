import React from "react";
import Link from "@docusaurus/Link";
import Translate, { translate } from "@docusaurus/Translate";
import useDocusaurusContext from "@docusaurus/useDocusaurusContext";
import useBaseUrl from "@docusaurus/useBaseUrl";
import { CodeSnippet } from "../CodeSnippet";
import SnippetCreate from "!!raw-loader!/static/snippets/create.dart";
import SnippetRead from "!!raw-loader!/static/snippets/read.dart";

export const Banner: React.FC = () => {
  const { siteConfig } = useDocusaurusContext();

  return (
    <header className="banner">
      <div className="banner__content">
        <h1 className="banner__logo">
          <img src="img/logo.svg" alt="Riverpod" />
          {siteConfig.title}
        </h1>

        <h1 className="banner__headline">
          <Translate id="home.tagline">
            A Reactive Caching and Data-binding Framework
          </Translate>
        </h1>

        <div>
          <Link className="banner__cta" to={useBaseUrl("docs/introduction/getting_started")}>
            <Translate id="home.get_started">Get Started</Translate>
          </Link>
        </div>
      </div>
      <div className="banner__content">
        <CodeSnippet
          title={translate({
            id: "home.create_provider",
            message: "Create a network request",
          })}
          snippet={SnippetCreate}
        ></CodeSnippet>
        <CodeSnippet
          title={translate({
            id: "home.consume_provider",
            message: "Listen to the network request in your UI",
          })}
          snippet={SnippetRead}
        ></CodeSnippet>
      </div>
    </header>
  );
};
