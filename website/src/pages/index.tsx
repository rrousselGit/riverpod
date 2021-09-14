import React from "react";
import useDocusaurusContext from "@docusaurus/useDocusaurusContext";
import Layout from "@theme/Layout";
import { Banner } from "../components/Banner";
import { Feature } from "../components/Feature/index";
import { Highlight } from "../components/Highlight";
import { features } from "../data/features";
import { highlights } from "../data/highlights";

export default function Home() {
  const { siteConfig } = useDocusaurusContext();
  return (
    <Layout
      title={siteConfig.tagline}
      description="A boilerplate-free and safe way to share state"
    >
      <Banner />

      <main>
        <section>
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
