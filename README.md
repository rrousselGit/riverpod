<p align="center">
<a href="https://github.com/rrousselGit/riverpod/actions"><img src="https://github.com/rrousselGit/riverpod/workflows/Build/badge.svg" alt="Build Status"></a>
<a href="https://codecov.io/gh/rrousselgit/riverpod"><img src="https://codecov.io/gh/rrousselgit/riverpod/branch/master/graph/badge.svg" alt="codecov"></a>
<a href="https://github.com/rrousselgit/riverpod"><img src="https://img.shields.io/github/stars/rrousselgit/riverpod.svg?style=flat&logo=github&colorB=deeppink&label=stars" alt="Star on Github"></a>
<a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/license-MIT-purple.svg" alt="License: MIT"></a>
<a href="https://discord.gg/Bbumvej"><img src="https://img.shields.io/discord/765557403865186374.svg?logo=discord&color=blue" alt="Discord"></a>

<p align="center">
<a href="https://www.netlify.com">
  <img src="https://www.netlify.com/img/global/badges/netlify-color-accent.svg" alt="Deploys by Netlify" />
</a>
</p>

<p align="center">
<img src="https://github.com/rrousselGit/riverpod/blob/master/resources/icon/Facebook%20Cover%20A.png?raw=true" width="100%" alt="Riverpod" />
</p>

</p>

---

A state-management library that:

- catches programming errors at compile time rather than
  at runtime
- removes nesting for listening/combining objects
- ensures that the code is testable

| riverpod         | [![pub package](https://img.shields.io/pub/v/riverpod.svg?label=riverpod&color=blue)](https://pub.dartlang.org/packages/riverpod)                 |
| ---------------- | ------------------------------------------------------------------------------------------------------------------------------------------------- |
| flutter_riverpod | [![pub package](https://img.shields.io/pub/v/riverpod.svg?label=flutter_riverpod&color=blue)](https://pub.dartlang.org/packages/flutter_riverpod) |
| hooks_riverpod   | [![pub package](https://img.shields.io/pub/v/riverpod.svg?label=hooks_riverpod&color=blue)](https://pub.dartlang.org/packages/hooks_riverpod)     |

Welcome to [Riverpod]!

This project can be considered as a rewrite of [provider] to make improvements
that would be otherwise impossible.

For learning how to use [Riverpod], see its documentation: https://riverpod.dev

Long story short:

- Declare your providers as global variables:

  ```dart
  final counterProvider = StateNotifierProvider((ref) {
    return Counter();
  });

  class Counter extends StateNotifier<int> {
    Counter(): super(0);

    void increment() => state++;
  }
  ```

- Use them inside your widgets in a compile time safe way. No runtime exceptions!

  ```dart
  class Example extends ConsumerWidget {
    @override
    Widget build(BuildContext context, WidgetRef ref) {
      final count = ref.watch(counterProvider);
      return Text(count.toString());
    }
  }
  ```

See the [FAQ](#FAQ) if you have questions about what this means for [provider].

## Migration

With the release of version 1.0.0, the syntax for interacting with providers changed.

See [the migration guide](https://riverpod.dev/docs/migration/0.14.0_to_1.0.0/) for more information

## Index

- [Migration](#migration)
- [Index](#index)
- [Motivation](#motivation)
- [Contributing](#contributing)
- [FAQ](#faq)
  - [Why another project when provider already exists?](#why-another-project-when-provider-already-exists)
  - [Is it safe to use in production?](#is-it-safe-to-use-in-production)
  - [Will this get merged with provider at some point?](#will-this-get-merged-with-provider-at-some-point)
  - [Will provider be deprecated/stop being supported?](#will-provider-be-deprecatedstop-being-supported)
- [Sponsors](#sponsors)

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
- Make apps more scalable with a unidirectional data flow.

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
- Fix typos/grammar mistakes
- Update the documentation / add examples
- Implement new features by making a pull-request

## FAQ

### Why another project when provider already exists?

While [provider] is largely used and well accepted by the community,
it is not perfect either.

People regularly file issues or ask questions about some problems they face, such as:

- Why do I have a `ProviderNotFoundException`?
- How can I automatically dispose my state when not used anymore?
- How to make a provider that depends on other (potentially complex) providers?

These are legitimate problems, and I believe that something can be improved to fix
those.

The issue is, these problems are deeply rooted in how [provider] works, and
fixing those problems is likely impossible without drastic changes to the
mechanism of [provider].

In a way, if [provider] is a candle then [Riverpod] is a lightbulb. They have
very similar usages, but we cannot create a lightbulb by improving our candle.

### Is it safe to use in production?

Yes.

[Riverpod] is stable and actively maintained.

### Will this get merged with provider at some point?

It is possible. Some experiments are being made that could make this
doable. But their outcome isn't clear yet.
(no link to an issue to avoid putting unnecessary pressure on the people
involved)

If those experiments are successful (although unlikely), then Provider
and Riverpod could be fused.

### Will provider be deprecated/stop being supported?

Maybe. 

Provider has numerous flaws that can't quite be fixed. At the same time,
Riverpod has proven to fix many of those.  
As such, deprecating Provider is being considered.

The only inconvenience of Riverpod is the need for a "Consumer",
which Provider doesn't need.
But some alternatives are being investigated to maybe remove this constraint.

Whatever the decision is, a migration tool is planned to help assist
migration from provider to [Riverpod]. Along with whatever other tool necessary to help.

## Sponsors

<p align="center">
  <a href="https://raw.githubusercontent.com/rrousselGit/freezed/master/sponsorkit/sponsors.svg">
    <img src='https://raw.githubusercontent.com/rrousselGit/freezed/master/sponsorkit/sponsors.svg'/>
  </a>
</p>

[provider]: https://github.com/rrousselGit/provider
[riverpod]: https://github.com/rrousselGit/riverpod
[flutter_hooks]: https://github.com/rrousselGit/flutter_hooks
[inheritedwidget]: https://api.flutter.dev/flutter/widgets/InheritedWidget-class.html
[hooks_riverpod]: https://pub.dev/packages/hooks_riverpod
[flutter_riverpod]: https://pub.dev/packages/flutter_riverpod
