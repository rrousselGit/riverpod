import React from "react";
import Translate, { translate } from "@docusaurus/Translate";
import SnippetAsync from "!!raw-loader!/static/snippets/async.dart";
import SnippetCombine from "!!raw-loader!/static/snippets/combine.dart";
import SnippetDeclare from "!!raw-loader!/static/snippets/declare.dart";
import { IFeatureProps } from "../components/Feature";

export const features: IFeatureProps[] = [
  {
    snippet: SnippetDeclare,
    title: translate({
      id: "home.shared_state_title",
      message: "Declare shared state from anywhere",
    }),

    description: (
      <Translate
        id="home.shared_state_body"
        description="The homepage input placeholder"
        values={{
          main: <code>main.dart</code>,
          br: <br></br>,
        }}
      >
        {`No need to jump between your {main} and your UI files
          anymore. {br}
          Place the code of your shared state where it belongs, be
          it in a separate package or right next to the Widget that
          needs it, without losing testability.`}
      </Translate>
    ),
  },
  {
    snippet: SnippetCombine,
    title: translate({
      id: "home.recompute_title",
      message: "Recompute states/rebuild UI only when needed",
    }),
    description: (
      <Translate
        id="home.recompute_body"
        values={{
          br: <br></br>,
          Provider: (
            <code>
              <a href={"./docs/concepts/combining_providers"}>Provider</a>
            </code>
          ),
          families: <a href={"./docs/concepts/modifiers/family"}>"families"</a>,
          build: <code>build</code>,
          truly: <strong>truly</strong>,
        }}
      >
        {`We no longer have to sort/filter lists inside the {build}
          method or have to resort to advanced cache mechanism. {br} {br}
          With {Provider} and {families}, sort your lists or do HTTP
          requests only when you {truly} need it.`}
      </Translate>
    ),
  },

  {
    snippet: SnippetAsync,
    title: translate({
      id: "home.safe_read_title",
      message: "Safely read providers",
    }),
    description: (
      <Translate
        id="home.safe_read_body"
        values={{
          br: <br></br>,
        }}
      >
        {`Reading a provider will never result in a bad state. If you
          can write the code needed to read a provider, you will obtain
          a valid value. {br} {br}
          This even applies to asynchronously loaded values. As opposed
          to with provider, Riverpod allows cleanly handling
          loading/error cases.`}
      </Translate>
    ),
  },
  {
    imageUrl: "img/intro/devtool.png",
    title: translate({
      id: "home.devtool_title",
      message: " Inspect your state in the devtool",
    }),
    description: (
      <Translate
        id="home.devtool_body"
        values={{
          br: <br></br>,
        }}
      >
        {`Using Riverpod, your state is visible out of the box inside Flutter's devtool. {br}
          Furthermore, a full-blown state-inspector is in progress.`}
      </Translate>
    ),
  },
];
