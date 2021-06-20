<p align="center">
<a href="https://github.com/rrousselGit/river_pod/actions"><img src="https://github.com/rrousselGit/river_pod/workflows/Build/badge.svg" alt="Build Status"></a>
<a href="https://codecov.io/gh/rrousselgit/river_pod"><img src="https://codecov.io/gh/rrousselgit/river_pod/branch/master/graph/badge.svg" alt="codecov"></a>
<a href="https://github.com/rrousselgit/river_pod"><img src="https://img.shields.io/github/stars/rrousselgit/river_pod.svg?style=flat&logo=github&colorB=deeppink&label=stars" alt="Star on Github"></a>
<a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/license-MIT-purple.svg" alt="License: MIT"></a>
<a href="https://discord.gg/Bbumvej"><img src="https://img.shields.io/discord/765557403865186374.svg?logo=discord&color=blue" alt="Discord"></a>
<a href="https://www.buymeacoffee.com/remirousselet" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/default-orange.png" alt="Buy Me A Coffee" height="25px"></a>

<p align="center">
<img src="https://github.com/rrousselGit/river_pod/blob/master/resources/icon/Facebook%20Cover%20A.png?raw=true" width="100%" alt="Riverpod" />
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

With the release of the version 0.14.0, the syntax for using `StateNotifierProvider` changed.

See [the migration guide](https://riverpod.dev/docs/migration/0.13.0_to_0.14.0/) for more informations

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

Yes, but with caution.

[Riverpod] recently left its experimental status, but it isn't fully stable either.
The API may change slightly when more features are added, and some use-cases
may not be as simple as they could be.

But overall, you should be able to use [Riverpod] without trouble.

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
