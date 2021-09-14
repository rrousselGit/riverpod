import React from "react";
import Link from "@docusaurus/Link";
import Translate, { translate } from "@docusaurus/Translate";
import useBaseUrl from "@docusaurus/useBaseUrl";
import CodeBlock from "@theme/CodeBlock";
import Tabs from "@theme/Tabs";
import TabItem from "@theme/TabItem";
import classnames from "classnames";
import SnippetCreate from "!!raw-loader!/static/snippets/create.dart";
import SnippetRead from "!!raw-loader!/static/snippets/read.dart";
import styles from "./styles.module.scss";


export const Banner: React.FC = () => {
  return (
    <header className="hero">
      <div className="container">
        <div className="row">
          <div className={classnames("col", styles.center)}>
            <h1 className="hero__title">
              <Translate id="home.tagline">
                Reactive State-Management and Dependency Injection
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
            <Tabs>
              <TabItem
                default
                value="read"
                label={translate({
                  id: "home.create_provider",
                  message: "Create a Provider",
                })}
              >
                <CodeBlock className="language-dart">{SnippetCreate}</CodeBlock>{" "}
              </TabItem>
              <TabItem
                value="consume"
                label={translate({
                  id: "home.consume_provider",
                  message: "Consume the Provider",
                })}
              >
                <CodeBlock className="language-dart">{SnippetRead}</CodeBlock>
              </TabItem>
            </Tabs>
          </div>
        </div>
      </div>
    </header>
  );
};
