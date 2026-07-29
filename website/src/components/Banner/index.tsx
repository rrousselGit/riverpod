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
      <div className="banner__bg_glow" />
      <div className="banner__content banner__content--text">
        <div className="banner__badge">
          <span className="banner__badge_icon">⚡</span>
          <Translate id="home.badge">
            Modern State Management & Reactive Caching
          </Translate>
        </div>

        <h1 className="banner__logo">
          <img src="img/logo.svg" alt="Riverpod Logo" className="banner__logo_img" />
          <span className="banner__logo_text">{siteConfig.title}</span>
        </h1>

        <h2 className="banner__headline">
          <Translate id="home.tagline">
            A Reactive Caching and Data-binding Framework
          </Translate>
        </h2>

        <p className="banner__subheadline">
          <Translate id="home.subheadline">
            Catch compile-time errors, combine multiple states seamlessly, and test your code without boilerplate.
          </Translate>
        </p>

        <div className="banner__actions">
          <Link className="banner__cta banner__cta--primary" to={useBaseUrl("docs/introduction/getting_started")}>
            <Translate id="home.get_started">Get Started</Translate>
            <span className="banner__cta_arrow">→</span>
          </Link>
          <a
            className="banner__cta banner__cta--secondary"
            href="https://github.com/rrousselGit/riverpod"
            target="_blank"
            rel="noopener noreferrer"
          >
            <svg className="banner__github_icon" viewBox="0 0 24 24" width="20" height="20" fill="currentColor">
              <path d="M12 0C5.37 0 0 5.37 0 12c0 5.31 3.435 9.795 8.205 11.385.6.105.825-.255.825-.57 0-.285-.015-1.23-.015-2.235-3.015.555-3.795-.735-4.035-1.41-.135-.345-.72-1.41-1.23-1.695-.42-.225-1.02-.78-.015-.795.945-.015 1.62.87 1.845 1.23 1.08 1.815 2.805 1.305 3.495.99.105-.78.42-1.305.765-1.605-2.67-.3-5.46-1.335-5.46-5.925 0-1.305.465-2.385 1.23-3.225-.12-.3-.54-1.53.12-3.18 0 0 1.005-.315 3.3 1.23.96-.27 1.98-.405 3-.405s2.04.135 3 .405c2.295-1.56 3.3-1.23 3.3-1.23.66 1.65.24 2.88.12 3.18.765.84 1.23 1.905 1.23 3.225 0 4.605-2.805 5.625-5.475 5.925.435.375.81 1.095.81 2.22 0 1.605-.015 2.895-.015 3.3 0 .315.225.69.825.57A12.02 12.02 0 0024 12c0-6.63-5.37-12-12-12z"/>
            </svg>
            GitHub
          </a>
        </div>
      </div>
      <div className="banner__content banner__content--snippets">
        <CodeSnippet
          title={translate({
            id: "home.create_provider",
            message: "Create a network request",
          })}
          snippet={SnippetCreate}
        />
        <CodeSnippet
          title={translate({
            id: "home.consume_provider",
            message: "Listen to the network request in your UI",
          })}
          snippet={SnippetRead}
        />
      </div>
    </header>
  );
};
