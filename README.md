Welcome to [River_pod]!

This project can be considered as an **experimental** [provider] rewrite.

Long story short:

- Declare your providers are global variables:

  ```dart
  final useMyNotifier = ChangeNotifierProvider((_) {
    return MyNotifier();
  });

  class MyNotifier extends ChangeNotifier {
    int count;
    // TODO: typical ChangeNotifier logic
  }
  ```

* Use them inside your widgets in a compile-time safe way. No runtime exceptions!

  ```dart
  class Example extends HookWidget {
    @override
    Widget build(BuildContext context) {
      final myNotifier = useMyNotifier();
      return Text(myNotifier.count.toString());
    }
  }
  ```

See the [FAQ](#FAQ) if you have questions around what this means for [provider].

# Index

- [TL;DR](#tldr)
- [Motivation](#motivation)
- [Usage](#usage)
- [FAQ](#faq)
  - [Why another project when provider already exists?](#why-another-project-when-provider-already-exists)
  - [Is it safe to use in production?](#is-it-safe-to-use-in-production)
  - [Will this get merged with provider at some point?](#will-this-get-merged-with-provider-at-some-point)
  - [Will provider be deprecated/stop being supported?](#will-provider-be-deprecatedstop-being-supported)

# Motivation

If [provider] is a simplification of [InheritedWidget]s, then [River_pod] is
a reimplementation of [InheritedWidget]s from scratch.

It is very similar to [provider] in principle, but also has major differences
as an attempt to fix the common problems that [provider] face.

[River_pod] has multiple goals. First, it inherits the goals of [provider]:

- Being able to safely create, observe and dispose states without having to worry about
  losing the state on widget rebuild.
- Making our objects visible in Flutter's devtool by default.
- Testable and composable
- Improve the readability of [InheritedWidget]s when we have multiple of them
  (which would naturally lead to a deeply nested widget tree).
- Make apps more scalable with a uni-directional data-flow.

From there, [River_pod] goes a few steps beyond:

- Reading objects is now **compile-safe**. No more runtime exception.
- Makes the [provider] pattern more flexible, which allows supporting commonly
  requested features like:
  - being able to have multiple providers of the same type.
  - disposing the state of a provider when it is no longer used.
  - make a provider private.
- Revamps the syntax to make it simpler
- Makes the pattern independent from Flutter

These are achieved by no-longer using [InheritedWidget]s. Instead, [River_pod]
implements its own mechanism that works in a similar fashion.

# Usage

The way [River_pod] is used depends on the application you are using:

- You are building a Flutter app and don't mind using [flutter_hooks]:\
  You can use the [hooks_river_pod] package.

  This reduces the boilerplate of listening to providers inside widgets.

- You are building a Flutter app, but do not want to use [flutter_hooks]:\
  You can use the [flutter_river_pod] package.

  It has a more verbose syntax (comparable to `Theme.of(context)` vs `StreamBuilder`).
  But feature-wise, it is otherwise identical to [hooks_river_pod].

- Your app **does not** use Flutter:\
  You can use the [river_pod] package.

  It exposes all the non-Flutter-related providers and a way to consume them without widgets.

# FAQ

## Why another project when [provider] already exists?

While [provider] is largely used and well accepted by the community,
it is not perfect either.

People regularly file issues or ask questions about some problems they face, such as:

- Why do I have a `ProviderNotFoundException`?
- How can I make that my state is automatically disposed of when not used anymore?
- How to make a provider that depends on other (potentially complex) providers?

These are legitimate problems, and I believe that something can be improved to fix
those.

The issue is, these problems are deeply rooted in how [provider] works, and
fixing those problems is likely impossible without drastic changes to the
mechanism of [provider].

This _could_ be merged inside [provider] directly, but would be betraying the
[provider] community to do so.\
See [Will this get merged with provider at some point?](#will-this-get-merged-with-provider-at-some-point)
for a deeper explanation.

## Is it safe to use in production?

The project is still experimental, so use it at your own risk.

In theory, it should scale well to large projects. But it is possible that
there are some bugs or missing features.

But I would expect this project to work for most people in its current state

## Will this get merged with [provider] at some point?

No. At least not until it is proven that the community likes [River_pod]
and that it doesn't cause more problems than it solves.

While [provider] and this project have a lot in common, they do have some
major differences. Differences big enough that it would be a large breaking
change for users of [provider] to migrate [River_pod].

Considering that, separating both projects initially sounds like a better
compromise.

## Will [provider] be deprecated/stop being supported?

Not in the short term, no.

This project is still experimental and unpopular. While it is, in a way,
a [provider] 2.0, its worth has yet to be proven.

Until it is certain that [River_pod] is a better way of doing things
and that the community likes it, [provider] will still be maintained.

[provider]: https://github.com/rrousselGit/provider
[river_pod]: https://github.com/rrousselGit/River_pod
[flutter_hooks]: https://github.com/rrousselGit/flutter_hooks
[inheritedwidget]: https://api.flutter.dev/flutter/widgets/InheritedWidget-class.html
[hooks_river_pod]: https://pub.dev/packages/hooks_river_pod
[flutter_river_pod]: https://pub.dev/packages/flutter_river_pod
