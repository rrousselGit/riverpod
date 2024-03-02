import React from "react";
import Translate, { translate } from "@docusaurus/Translate";
import { IHighlightProps } from "../components/Highlight";

export const highlights: IHighlightProps[] = [
  {
    imageUrl: "img/highlights/compile.svg",
    title: translate({
      id: "homepage.declarative_title",
      message: "Declarative programming",
    }),
    description: (
      <Translate id="homepage.declarative_body" values={{br: <br/>}} >
        {`Write business logic in a manner similar to Stateless widgets.{br}Have your
        network requests to automatically recompute when necessary and make
        your logic easily reusable/composable/maintainable.`}
      </Translate>
    ),
  },
  {
    imageUrl: "img/highlights/provider.svg",
    title: translate({
      id: "homepage.common_ui_patterns_title",
      message: "Easily implement common UI patterns",
    }),
    description: (
      <Translate id="homepage.common_ui_patterns_body">
        Using Riverpod, common yet complex UI patterns such as "pull to
        refresh"/ "search as we type"/etc... are only a few lines of code away.
      </Translate>
    ),
  },
  {
    imageUrl: "img/highlights/flutter.svg",
    title: translate({
      id: "homepage.tooling_ready_title",
      message: "Tooling ready",
    }),
    description: (
      <Translate id="homepage.tooling_ready_body">
        Riverpod enhances the compiler by having common mistakes be a
        compilation-error. It also provides custom lint rules and refactoring
        options. It even has a command line for generating docs.
      </Translate>
    ),
  },
];
