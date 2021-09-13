import React from "react";
import Translate from "@docusaurus/Translate";

export const features = [
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
