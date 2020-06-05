import React from "react";
import classnames from "classnames";
import Layout from "@theme/Layout";
import Link from "@docusaurus/Link";
import useDocusaurusContext from "@docusaurus/useDocusaurusContext";
import useBaseUrl from "@docusaurus/useBaseUrl";
import styles from "./styles.module.css";

const features = [
  {
    title: <>Compile safe</>,
    imageUrl: "img/undraw_security.svg",
    description: (
      <>
        No more <code>ProviderNotFoundException</code> or forgetting to handle
        loading states. Using Riverpod, if your code compiles, it works.
      </>
    ),
  },
  {
    title: <>Provider, without its limitations</>,
    imageUrl: "img/undraw_friendship.svg",
    description: (
      <>
        Riverpod learned from the flaws of <code>provider</code> to fix its
        issues. Combining asynchronous providers has never been easier.
      </>
    ),
  },
  {
    title: <>Dev tool ready</>,
    imageUrl: "img/undraw_programming.svg",
    description: (
      <>
        Inspect the state of your app, see the history of all changes, and
        modify the state on the fly.
      </>
    ),
  },
];

function Feature({ imageUrl, title, description }) {
  const imgUrl = useBaseUrl(imageUrl);
  return (
    <div className={classnames("col col--4", styles.feature)}>
      {imgUrl && (
        <div className="text--center">
          <img className={styles.featureImage} src={imgUrl} alt={title} />
        </div>
      )}
      <h3>{title}</h3>
      <p>{description}</p>
    </div>
  );
}

function Preview({ imageUrl, title }) {
  const imgUrl = useBaseUrl(imageUrl);
  return (
    <div className="col">
      <h2>{title}</h2>
      <img alt={title} src={imgUrl}></img>
    </div>
  );
}

function Home() {
  const context = useDocusaurusContext();
  const { siteConfig = {} } = context;
  return (
    <Layout
      title={siteConfig.tagline}
      description="Description will go into a meta tag in <head />"
    >
      <header className={classnames("hero hero--primary", styles.heroBanner)}>
        <div className="container">
          <h1 className="hero__title">{siteConfig.title}</h1>
          <p className="hero__subtitle">{siteConfig.tagline}</p>
          <div className={styles.buttons}>
            <Link
              className={classnames(
                "button button--outline button--secondary button--lg",
                styles.getStarted
              )}
              to={useBaseUrl("docs/fundamentals/getting_started")}
            >
              Get Started
            </Link>
          </div>
          <div className="row">
            <Preview
              imageUrl="img/intro/create_provider.png"
              title="Create a provider"
            ></Preview>
            <Preview
              imageUrl="img/intro/read_provider.png"
              title="Consume the provider"
            ></Preview>
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

      </main>
    </Layout>
  );
}

export default Home;
