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

# Index

- [Motivation](#motivation)
- [Usage](#usage)
- [FAQ](#faq)
  - [Why another project when provider already exists?](#why-another-project-when-provider-already-exists)
  - [Is it safe to use in production?](#is-it-safe-to-use-in-production)
  - [Will this get merged with provider at some point?](#will-this-get-merged-with-provider-at-some-point)
  - [Will provider be deprecated/stop being supported?](#will-provider-be-deprecatedstop-being-supported)

# Motivation

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
- Make apps more scalable with a uni-directional data-flow.

From there, [Riverpod] goes a few steps beyond:

- Reading objects is now **compile-safe**. No more runtime exception.
- Makes the [provider] pattern more flexible, which allows supporting commonly
  requested features like:
  - being able to have multiple providers of the same type.
  - disposing the state of a provider when it is no longer used.
  - make a provider private.
- Simplifying complex object graphs.
- Makes the pattern independent from Flutter

These are achieved by no-longer using [InheritedWidget]s. Instead, [Riverpod]
implements its own mechanism that works in a similar fashion.

# Usage

The way [Riverpod] is used depends on the application you are making.

You can refer to the following table to help you decide which package to use:

| app type                  | package name                                                                       | description                                                                                                                                       |
| ------------------------- | ---------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------- |
| Flutter + [flutter_hooks] | [hooks_riverpod]                                                                   | An improved syntax with less boilerplate for listening providers inside widgets.                                                                  |
| Flutter only              | [flutter_riverpod]                                                                 | A slightly more verbose syntax (comparable to `Theme.of` vs `StreamBuilder`).<br>But feature-wise, it is otherwise identical to [hooks_riverpod]. |
| Dart only (No Flutter)    | [riverpod](https://github.com/rrousselgit/river_pod/tree/master/packages/riverpod) | A version of [Riverpod] striped out of all the classes related to Flutter                                                                         |

# FAQ

## Why another project when [provider] already exists?

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

## Is it safe to use in production?

The project is still experimental, so use it at your own risk.

It applied all the lessons learned from [provider], so I would expect this
project to solve most use-cases.\
But if your project randomly catches fire, you were warned!

## Will this get merged with [provider] at some point?

No. At least not until it is proven that the community likes [Riverpod]
and that it doesn't cause more problems than it solves.

While [provider] and this project have a lot in common, they do have some
major differences. Differences big enough that it would be a large breaking
change for users of [provider] to migrate [Riverpod].

Considering that, separating both projects initially sounds like a better
compromise.

## Will [provider] be deprecated/stop being supported?

Not in the short term, no.

This project is still experimental and unpopular. While it is, in a way,
a [provider] 2.0, its worth has yet to be proven.

Until it is certain that [Riverpod] is a better way of doing things
and that the community likes it, [provider] will still be maintained.

# Roadmap

- evaluate time complexity for all operations
- evaluate space complexity
- future/changenotifier/...providers cannot return null
- Cannot add dependencies during dispatching
- FutureChangeNotifier
- FutureStateNotifier
- AutoDispose
- Selector
- Computed
- Family (StateNotifier vs .value) -> overriding the entire family at once
- SetStateSubscription/SelectorSubscription
- overrideAs AutoDispose
- Dartdoc for all public APIs
- review all public APIs
- README for all packages
- CI
- useProvider(provider.select)
- provider.watchRef?
- Prevent modifying parents from children (provider -> provider)
- Prevent modifying parents from children (widget -> provider)
- DateTime provider
- Make a common interface between ProviderSubscriptions? (So that we can assign Provider to SetStateProvider)
- Should some asserts be changed to exceptions in release?
- Should some exceptions have a custom error?

Marvel example:

- Write tests for everything
- publish it on the web
- handle errors (out of calls/day, no configurations)
- Added to doc

riverpod.dev

- concepts

  - Provider

    - You can think of providers as streams.\
      But providers are readable synchronously and they have
      a built-in way to combine providers with other providers.

      Similarly, the behavior of a provider can be overriden,
      for testing purposes or objects depending on a provider
      more reusable.

- Combining providers
- Filtering rebuilds
- Testing (without flutter, mocking FutureProvider)
- How it works
- The differences between hooks and not hooks
- cookbook configurations that change over time
- state hydratation

Linter:

- When overriding `StateNotifierProvider` on a non-root `ProviderStateOwner`, warn if the `.value` wasn't overriden too.
- Check that when a provider is overridden locally, all of its dependencies are too
- provider.overrideAs(provider) -> provider
- always_specify_name
- name_match_variable
- providers_allow_specifying_name
- extract as class for rebuild optimization
- warn if public classes inside /src are not used but not exported

Devtool:

- entire app state for the root owner
- highlight state changes
- number of widgets that rebuilt in the same frame than the state change
- collapsable state
- editable state (through Freezed/copyWith/state_notifier)
- time travel
- lock further changes
- lock further changes when a specific property changes

[provider]: https://github.com/rrousselGit/provider
[riverpod]: https://github.com/rrousselGit/river_pod
[flutter_hooks]: https://github.com/rrousselGit/flutter_hooks
[inheritedwidget]: https://api.flutter.dev/flutter/widgets/InheritedWidget-class.html
[hooks_riverpod]: https://pub.dev/packages/hooks_riverpod
[flutter_riverpod]: https://pub.dev/packages/flutter_riverpod
