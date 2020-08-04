[![pub package](https://img.shields.io/pub/v/riverpod.svg?label=riverpod)](https://pub.dartlang.org/packages/riverpod)
[![pub package](https://img.shields.io/pub/v/riverpod.svg?label=flutter_riverpod)](https://pub.dartlang.org/packages/flutter_riverpod)
[![pub package](https://img.shields.io/pub/v/riverpod.svg?label=hooks_riverpod)](https://pub.dartlang.org/packages/hooks_riverpod)

[![Build Status](https://github.com/rrousselGit/river_pod/workflows/Build/badge.svg)](https://github.com/rrousselGit/river_pod/actions) [![codecov](https://codecov.io/gh/rrousselGit/river_pod/branch/master/graph/badge.svg)](https://codecov.io/gh/rrousselGit/river_pod)
<style>.bmc-button img{height: 20px !important;width: 20px !important;margin-bottom: 1px !important;box-shadow: none !important;border: none !important;vertical-align: middle !important;}.bmc-button{padding: 0px 15px 0px 10px !important;line-height: 18px !important;height:20px !important;text-decoration: none !important;display:inline-flex !important;color:#ffffff !important;background-color:#FF813F !important;border-radius: 5px !important;border: 1px solid transparent !important;padding: 1px 8px 1px 8px !important;font-size: 20px !important;letter-spacing:0.6px !important;box-shadow: 0px 1px 2px rgba(190, 190, 190, 0.5) !important;-webkit-box-shadow: 0px 1px 2px 2px rgba(190, 190, 190, 0.5) !important;margin: 0 auto !important;font-family:'Cookie', cursive !important;-webkit-box-sizing: border-box !important;box-sizing: border-box !important;}.bmc-button:hover, .bmc-button:active, .bmc-button:focus {-webkit-box-shadow: 0px 1px 2px 2px rgba(190, 190, 190, 0.5) !important;text-decoration: none !important;box-shadow: 0px 1px 2px 2px rgba(190, 190, 190, 0.5) !important;opacity: 0.85 !important;color:#ffffff !important;}</style><link href="https://fonts.googleapis.com/css?family=Cookie" rel="stylesheet"><a class="bmc-button" target="_blank" href="https://www.buymeacoffee.com/remirousselet"><img src="https://cdn.buymeacoffee.com/buttons/bmc-new-btn-logo.svg" alt="Buy me a Pizza"><span style="margin-left:5px;font-size:20px !important;">Buy me a Pizza</span></a>

# Black Lives Matter. [Support the Equal Justice Initiative.](https://support.eji.org/give/153413/#!/donation/checkout)

Welcome to [Riverpod]!

This project can be considered as an **experimental** [provider] rewrite.

For learning how to use [Riverpod], see its documentation: https://riverpod.dev

Long story short:

- Declare your providers as global variables:

  ```dart
  final myNotifierProvider = ChangeNotifierProvider((_) {
    return MyNotifier();
  });

  class MyNotifier extends ChangeNotifier {
    int count;
    // TODO: typical ChangeNotifier logic
  }
  ```

- Use them inside your widgets in a compile-time safe way. No runtime exceptions!

  ```dart
  class Example extends HookWidget {
    @override
    Widget build(BuildContext context) {
      final count = useProvider(myNotifierProvider);
      return Text(count.toString());
    }
  }
  ```

See the [FAQ](#FAQ) if you have questions around what this means for [provider].

## Index

- [Motivation](#motivation)
- [FAQ](#faq)
  - [Why another project when provider already exists?](#why-another-project-when-provider-already-exists)
  - [Is it safe to use in production?](#is-it-safe-to-use-in-production)
  - [Will this get merged with provider at some point?](#will-this-get-merged-with-provider-at-some-point)
  - [Will provider be deprecated/stop being supported?](#will-provider-be-deprecatedstop-being-supported)

## Motivation

If [provider] is a simplification of [InheritedWidget]s, then [Riverpod] is
a reimplementation of [InheritedWidget]s from scratch.

It is very similar to [provider] in principle, but also has major differences
as an attempt to fix the common problems that [provider] face.

[Riverpod] has multiple goals. First, it inherits the goals of [provider]:

- Being able to safely create, observe and dispose states without having to worry about
  losing the state on widget rebuild.
- Making our objects visible in Flutter's devtool by default.
- Testable and composable
- Improve the readability of [InheritedWidget]s when we have multiple of them
  (which would naturally lead to a deeply nested widget tree).
- Make apps more scalable with a unidirectional data-flow.

From there, [Riverpod] goes a few steps beyond:

- Reading objects is now **compile-safe**. No more runtime exception.
- It makes the [provider] pattern more flexible, which allows supporting commonly
  requested features like:
  - Being able to have multiple providers of the same type.
  - Disposing the state of a provider when it is no longer used.
  - Have computed states
  - Making a provider private.
- Simplifies complex object graphs. It is easier to depend on asynchronous state.
- Makes the pattern independent from Flutter

These are achieved by no longer using [InheritedWidget]s. Instead, [Riverpod]
implements its own mechanism that works in a similar fashion.

For learning how to use [Riverpod], see its documentation: https://riverpod.dev

## Contributing

Contributions are welcomed!

Here is a curated list of how you can help:

- Report bugs and scenarios that are difficult to implement
- Report parts of the documentation that are unclear
- Update the documentation / add examples
- Implement new features by making a pull-request

## FAQ

### Why another project when [provider] already exists?

While [provider] is largely used and well accepted by the community,
it is not perfect either.

People regularly file issues or ask questions about some problems they face, such as:

- Why do I have a `ProviderNotFoundException`?
- How can I make that my state automatically disposed of when not used anymore?
- How to make a provider that depends on other (potentially complex) providers?

These are legitimate problems, and I believe that something can be improved to fix
those.

The issue is, these problems are deeply rooted in how [provider] works, and
fixing those problems is likely impossible without drastic changes to the
mechanism of [provider].

In a way, if [provider] is a candle then [Riverpod] is a lightbulb. They have
very similar usages, but we cannot create a lightbulb by improving our candle.

### Is it safe to use in production?

The project is still experimental, so use it at your own risk.

It applied all the lessons learned from [provider], so I would expect this
project to solve most use-cases.\
But if your project randomly catches fire, you were warned!

### Will this get merged with [provider] at some point?

No. At least not until it is proven that the community likes [Riverpod]
and that it doesn't cause more problems than it solves.

While [provider] and this project have a lot in common, they do have some
major differences. Differences big enough that it would be a large breaking
change for users of [provider] to migrate [Riverpod].

Considering that, separating both projects initially sounds like a better
compromise.

### Will [provider] be deprecated/stop being supported?

Not in the short term, no.

This project is still experimental and unpopular. While it is, in a way,
a [provider] 2.0, its worth has yet to be proven.

Until it is certain that [Riverpod] is a better way of doing things
and that the community likes it, [provider] will still be maintained.

[provider]: https://github.com/rrousselGit/provider
[riverpod]: https://github.com/rrousselGit/river_pod
[flutter_hooks]: https://github.com/rrousselGit/flutter_hooks
[inheritedwidget]: https://api.flutter.dev/flutter/widgets/InheritedWidget-class.html
[hooks_riverpod]: https://pub.dev/packages/hooks_riverpod
[flutter_riverpod]: https://pub.dev/packages/flutter_riverpod
