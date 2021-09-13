import React from "react";
import classnames from "classnames";
import Layout from "@theme/Layout";
import Link from "@docusaurus/Link";
import useDocusaurusContext from "@docusaurus/useDocusaurusContext";
import useBaseUrl from "@docusaurus/useBaseUrl";
import styles from "./styles.module.scss";
import Translate, { translate } from "@docusaurus/Translate";

const features = [
  {
    title: <Translate id="homepage.compile_safe_title">Compile safe</Translate>,
    imageUrl: "img/undraw_security.svg",
    description: (
      <Translate
        id="homepage.compile_safe_body"
        values={{ ProviderNotFound: <code>ProviderNotFoundException</code> }}
      >
        {`No more {ProviderNotFound} or forgetting to handle loading
        states. Using Riverpod, if your code compiles, it works.`}
      </Translate>
    ),
  },
  {
    title: (
      <Translate id="homepage.unlimited_provider_title">
        Provider, without its limitations
      </Translate>
    ),
    imageUrl: "img/undraw_friendship.svg",
    description: (
      <Translate id="homepage.unlimited_provider_body">
        Riverpod is inspired by Provider but solves some of it's key issues such as
        supporting multiple providers of the same type; awaiting asynchronous
        providers; adding providers from anywhere, ...
      </Translate>
    ),
  },
  {
    title: (
      <Translate id="homepage.no_flutter_dependency_title">
        Doesn't depend on Flutter
      </Translate>
    ),
    imageUrl: "img/undraw_programming.svg",
    description: (
      <Translate
        id="homepage.no_flutter_dependency_body"
        values={{ BuildContext: <code>BuildContext</code> }}
      >
        {`Create/share/tests providers, with no dependency on Flutter. This
        includes being able to listen to providers without a
        {BuildContext}.`}
      </Translate>
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
            <Preview
              // https://carbon.now.sh/?bg=rgba%28171%2C184%2C195%2C0%29&t=material&wt=none&l=dart&ds=true&dsyoff=20px&dsblur=68px&wc=false&wa=true&pv=0px&ph=0px&ln=false&fl=1&fm=Hack&fs=14px&lh=133%25&si=false&es=2x&wm=false&code=final%2520counterProvider%2520%253D%2520StateNotifierProvider%253CCounter%252C%2520int%253E%28%28ref%29%2520%257B%250A%2520%2520return%2520Counter%28%29%253B%250A%257D%29%253B%250A%250Aclass%2520Counter%2520extends%2520StateNotifier%253Cint%253E%2520%257B%250A%2520%2520Counter%28%29%253A%2520super%280%29%253B%250A%2520%2520%250A%2520%2520void%2520increment%28%29%2520%253D%253E%2520state%252B%252B%253B%250A%257D
              imageUrl="img/intro/create_provider.png"
              title={
                <Translate id="home.create_provider">
                  Create a provider
                </Translate>
              }
            ></Preview>
            <Preview
              // https://carbon.now.sh/?bg=rgba%28171%2C184%2C195%2C0%29&t=material&wt=none&l=dart&ds=true&dsyoff=20px&dsblur=68px&wc=false&wa=true&pv=0px&ph=0px&ln=false&fl=1&fm=Hack&fs=14px&lh=133%25&si=false&es=2x&wm=false&code=class%2520Home%2520extends%2520ConsumerWidget%2520%257B%250A%2520%2520%2540override%250A%2520%2520Widget%2520build%28BuildContext%2520context%252C%2520WidgetRef%2520ref%29%2520%257B%250A%2520%2520%2520%2520final%2520count%2520%253D%2520ref.watch%28counterProvider%29%253B%250A%2520%2520%2520%2520%250A%2520%2520%2520%2520return%2520Text%28%27%2524count%27%29%253B%250A%2520%2520%257D%250A%257D
              imageUrl="img/intro/read_provider.png"
              title={
                <Translate id="home.consume_provider">
                  Consume the provider
                </Translate>
              }
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
                  <img
                    src={translate({
                      id: "declare_anywhere_img",
                      // https://carbon.now.sh/?bg=rgba%28171%2C184%2C195%2C0%29&t=material&wt=none&l=dart&ds=true&dsyoff=20px&dsblur=68px&wc=false&wa=true&pv=0px&ph=0px&ln=false&fl=1&fm=Hack&fs=14px&lh=133%25&si=false&es=2x&wm=false&code=%252F%252F%2520A%2520shared%2520state%2520that%2520can%2520be%2520accessed%2520by%2520multiple%250A%252F%252F%2520objects%2520at%2520the%2520same%2520time%250Afinal%2520countProvider%2520%253D%2520StateProvider%28%28ref%29%2520%253D%253E%25200%29%253B%250A%250A%252F%252F%2520Comsumes%2520the%2520shared%2520state%2520and%2520rebuild%2520when%2520it%2520changes%250Aclass%2520Title%2520extends%2520ConsumerWidget%2520%257B%250A%2520%2520%2540override%250A%2520%2520Widget%2520build%28BuildContext%2520context%252C%2520WidgetRef%2520ref%29%2520%257B%250A%2520%2520%2520%2520final%2520count%2520%253D%2520ref.watch%28countProvider%29.state%253B%250A%2520%2520%2520%2520return%2520Text%28%27%2524count%27%29%253B%250A%2520%2520%257D%250A%257D
                      message: "img/intro/declare_anywhere.png",
                    })}
                    alt="Declare your providers anywhere"
                  ></img>
                </div>
              </div>
            </div>
          </div>
          <div className={styles.detailedFeatures}>
            <div className="container">
              <div className="row">
                <div className="col">
                  <img
                    src="img/intro/combining_providers.png"
                    alt="Combining providers"
                  ></img>
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
                  <img
                    // https://carbon.now.sh/?bg=rgba%28171%2C184%2C195%2C0%29&t=material&wt=none&l=dart&ds=true&dsyoff=20px&dsblur=68px&wc=false&wa=true&pv=0px&ph=0px&ln=false&fl=1&fm=Hack&fs=14px&lh=133%25&si=false&es=2x&wm=false&code=%252F%252F%2520Parse%2520a%2520file%2520without%2520having%2520to%2520deal%2520with%2520errors%250Afinal%2520configurationsProvider%2520%253D%2520FutureProvider%28%28ref%29%2520async%2520%257B%250A%2520%2520final%2520json%2520%253D%2520await%2520File.fromUri%28Uri.parse%28%27configs.json%27%29%29%250A%2520%2520%2520%2520.readAsString%28%29%253B%250A%2520%250A%2520%2520return%2520Configurations.fromJson%28json%29%253B%250A%257D%29%253B%250A%250Aclass%2520Example%2520extends%2520ConsumerWidget%2520%257B%250A%2520%2520%2540override%250A%2520%2520Widget%2520build%28BuildContext%2520context%252C%2520WidgetRef%2520ref%29%2520%257B%250A%2520%2520%2520%2520final%2520configs%2520%253D%2520ref.watch%28configurationsProvider%29%253B%250A%2520%2520%2520%2520%250A%2520%2520%2520%2520%252F%252F%2520Use%2520Riverpod%27s%2520built-in%2520support%250A%2520%2520%2520%2520%252F%252F%2520for%2520error%252Floading%2520states%2520using%2520%2522when%2522%253A%250A%2520%2520%2520%2520return%2520configs.when%28%250A%2520%2520%2520%2520%2520%2520%252F%252F%2520Currently%2520reading%2520the%2520file%250A%2520%2520%2520%2520%2520%2520loading%253A%2520%28_%29%2520%253D%253E%2520const%2520CircularProgressIndicator%28%29%252C%250A%2520%2520%2520%2520%2520%2520%252F%252F%2520If%2520the%2520configurations%2520failed%2520to%2520parse%250A%2520%2520%2520%2520%2520%2520error%253A%2520%28err%252C%2520stack%252C%2520_%29%2520%253D%253E%2520Text%28%27Error%2520%2524err%27%29%252C%250A%2520%2520%2520%2520%2520%2520data%253A%2520%28configs%29%2520%253D%253E%2520Text%28%27data%253A%2520%2524%257Bconfigs.host%257D%27%29%252C%250A%2520%2520%2520%2520%29%253B%250A%2520%2520%257D%250A%257D
                    src={translate({
                      id: "home.async_img",
                      message: "img/intro/async.png",
                    })}
                    alt="Asynchronously loaded providers"
                  ></img>
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

export default Home;
