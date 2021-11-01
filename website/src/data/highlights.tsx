import React from "react";
import Translate, { translate } from "@docusaurus/Translate";
import { IHighlightProps } from "../components/Highlight";

export const highlights: IHighlightProps[] = [
  {
    imageUrl: "img/highlights/compile.svg",
    title: translate({
      id: "homepage.compile_safe_title",
      message: "Compile safe",
    }),
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
    imageUrl: "img/highlights/provider.svg",
    title: translate({
      id: "homepage.unlimited_provider_title",
      message: "Provider, without its limitations",
    }),
    description: (
      <Translate id="homepage.unlimited_provider_body">
        Riverpod is inspired by Provider but solves some of it's key issues such as
        supporting multiple providers of the same type; awaiting asynchronous
        providers; adding providers from anywhere, ...
      </Translate>
    ),
  },
  {
    imageUrl: "img/highlights/flutter.svg",
    title: translate({
      id: "homepage.no_flutter_dependency_title",
      message: "Doesn't depend on Flutter",
    }),
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
