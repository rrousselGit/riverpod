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
        Riverpod has support for multiple providers of the same type; combining
        asynchronous providers; adding providers from anywhere, ...
      </>
    ),
  },
  {
    title: <>Doesn't depend on Flutter</>,
    imageUrl: "img/undraw_programming.svg",
    description: (
      <>
        Create/share/tests providers, with no dependency on Flutter. This
        includes being able to listen to providers without a
        <code>BuildContext</code>.
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
      description="A boilerplate-free and safe way to share state"
    >
      <header className={classnames("hero hero--primary", styles.heroBanner)}>
        <div className="container">
          <h1 className={classnames("hero__title", styles.mainTitle)}>
            <img src="/img/logo.svg" alt="Riverpod logo"></img>
            {siteConfig.title}
          </h1>
          <p className="hero__subtitle">{siteConfig.tagline}</p>
          <div className={styles.buttons}>
            <Link
              className={classnames(
                "button button--outline button--secondary button--lg",
                styles.getStarted
              )}
              to={useBaseUrl("docs/getting_started")}
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

        <section>
          <div className={styles.detailedFeatures}>
            <div class="container">
              <div class="row">
                <div className="col">
                  <h2>Declare shared state from anywhere</h2>
                  <p>
                    No need to jump between your <code>main.dart</code> and your
                    UI files anymore.<br></br>
                    <br></br>
                    Place the code of your shared state where it belongs, be it
                    in a separate package or right next to the Widget that needs
                    it,
                    <strong> without losing testability</strong>.
                  </p>
                </div>
                <div className="col">
                  <img
                    src="img/intro/declare_anywhere.png"
                    alt="Declare your providers anywhere"
                  ></img>
                </div>
              </div>
            </div>
          </div>
          <div className={styles.detailedFeatures}>
            <div class="container">
              <div class="row">
                <div className="col">
                  <img
                    src="img/intro/combining_providers.png"
                    alt="Combining providers"
                  ></img>
                </div>
                <div className="col">
                  <h2>Recompute states/rebuild UI only when needed</h2>
                  <p>
                    We no-longer have to sort/filter lists inside the{" "}
                    <code>build</code>
                    method or have to resort to advanced cache mechanism.
                    <br></br>
                    <br></br>
                    With
                    <code>
                      <a href={useBaseUrl("docs/concepts/combining_providers")}>
                        Provider
                      </a>
                    </code>
                    and
                    <a href={useBaseUrl("docs/concepts/modifiers/family")}>
                      "families"
                    </a>
                    , sort your lists or do HTTP requests only when you{" "}
                    <strong>truly</strong> need it.
                  </p>
                </div>
              </div>
            </div>
          </div>
          <div className={styles.detailedFeatures}>
            <div class="container">
              <div class="row">
                <div className="col">
                  <h2>Safely read providers</h2>
                  Reading a provider will never result in a bad state. If you
                  can write the code needed to read a provider, you will obtain
                  a valid value.
                  <br></br>
                  <br></br>
                  This even applies to asynchronously loaded values. As opposed
                  to with provider, Riverpod allows cleanly handling
                  loading/error cases.
                </div>
                <div className="col">
                  <img
                    src="img/intro/async.png"
                    alt="Asynchronously loaded providers"
                  ></img>
                </div>
              </div>
            </div>
          </div>
          <div className={styles.detailedFeatures}>
            <div class="container">
              <div class="row">
                <div className="col">
                  <img src="img/intro/devtool.png" alt="Devtool support"></img>
                </div>
                <div className="col">
                  <h2>Inspect your state in the devtool</h2>
                  <p>
                    Using Riverpod, your state is visible out of the box inside
                    Flutter's devtool. <br></br> Futhermore, a full-blown
                    state-inspector is in progress.
                  </p>
                </div>
              </div>
            </div>
          </div>
        </section>
      </main>
    </Layout>
  );
}

export default Home;
