Welcome to [provider_hooks]!

This project can be considered as an **experimental** [provider] rewrite, with a peer
dependency on [flutter_hooks].

It is very similar to [provider] in principle, but also has major differences
as an attempt to fix the common problem that [provider] faces.

See the [FAQ](#FAQ) if you have questions around what this means for [provider].

# Index

- [TL;DR](#tldr)
- [Motivation](#motivation)
- [FAQ](#faq)
  - [Why another project when provider already exists?](#why-another-project-when-provider-already-exists?)
  - [Is it safe to use in production?](#is-it-safe-to-use-in-production)
  - [Will this get merged with provider at some point?](#will-this-get-merged-with-provider-at-some-point)
  - [Will provider be deprecated/stop being supported?](#will-provider-be-deprecatedstop-being-supported)

# TL;DR

[provider_hooks] has goals similar to [provider]:

Simplifying the management of the different state/services of your app
and how Flutter's widget tree interacts with them while making sure
it is _testable_ and _scallable_.

# Motivation

# All providers

## Variants explanation

### SetState\*Provider

<!--
Allows the function that created the state to emit updates, but in exchange
when combining providers, the value can't be read without a listening mechanism.

Example: [Provider] vs [SetStateProvider]

[Provider] does two things:

- it creates a value that never ever changes, and the value created is not
  "listenable".
- it offers a way to clean-up resources when the provider is destroyed.

[SetStateProvider] inherits the functionalities of [Provider], and adds a
way to change the value exposed.

This, for example, allows to subscribe to a stream and update the exposed
value when a new value is pushed onto the stream.

```dart
final example = SetStateProvider((state) {
  // a stream coming from somewhere (firebase?)
  Stream<int> stream;

  final subscription = stream.listen((value) {
    // changes the value emitted when a new value is pushed to the stream
    state.value = value;
  });

  state.onDispose(() => subscription.cancel());

  // initial value
  return 0;
});
```

The downside of this extra possibility is when creating another provider from this
provider.

Combining a [Provider] into another provider is "easy":

```dart
final someValue = Provider((_) => 42);

// using `provider` into another object
final combiningExample = ProviderBuilder<int>()
  .add(someValue)
  .build((_, someValueState) {
    // Since `someValueState` is a Provider, we can read the value directly
    final value = someValueState.value;

    // do something with the obtained value, doesn't matter
    return value * 2;
  });
```

Being able to do `someValueState.value` is one of the privileges of [Provider].

This privilege disappears with [SetStateProvider], because the value is no-longer
immutable.\
While it may seem limiting, this is to ensure a bug-free experience: Refactoring
from [Provider] to [SetStateProvider] will highlight all the places that likely
need to be updated.

Instead, we need to "listen" to the value.

An alternate implementation of the previous `build` would be:

```dart
.build((_, someValueState) {
  int value;

  // Listens to `someValueState` for changes.
  // `listen` fires immediatly with the current value
  final removeListener = someValueState.listen((newValue) {
    value = newValue;
  });
  // Stop the subscription as we need only the first value
  removeListener();

  // do something with the obtained value, doesn't matter
  return value * 2;
});
```

Which can be simplified into:

```dart
.build((_, someValueState) {
  // We explicitly care only about the very first value and ignore other values
  final value = someValueState.first;

  // do something with the obtained value, doesn't matter
  return value * 2;
});
``` -->

### KeepAlive\*Provider

## Provider family

[Provider] exposes a value that never changes.

Creation:

```dart
final myProvider = Provider((_) => value);
```

Usage:

- `myProvider.read(context);` outside of build
- `myProvider.watch(context);` inside build (because global-keys)
- `myProvider()` (hook)
- `myProvider.select((value) => value.property)` (hook)
- `myProvider.readOwner(owner)`, equivalent to `read` but independent from Flutter
- `myProvider.watchOwner(owner, (value) {})`, equivalent to `myProvider()` but independent from Flutter

|                           | .read | .watch | .call | .readOwner | .watchOwner |
| ------------------------- | ----- | ------ | ----- | ---------- | ----------- |
| Provider                  | yes   | yes    | yes   | yes        | yes         |
| SetStateProvider          | yes   | yes    | yes   | yes        | yes         |
| KeepAliveProvider         | no    | no     | yes   | no         | yes         |
| KeepAliveSetStateProvider | no    | no     | yes   | no         | yes         |

## FutureProvider family

[FutureProvider] exposes a value that is created from a

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

The issue is, these problems are deeply related to how [provider] works, and
fixing those problems is likely impossible without drastic changes to the
mechanism of [provider].

This _could_ be merged inside [provider] directly, but would be betraying the
[provider] community to do so.\
See [Will this get merged with provider at some point?](#will-this-get-merged-with-provider-at-some-point)

## Is it safe to use in production?

The project is still experimental, so use it at your own risk.

In theory, it should scale well to large projects and be easy to maintain.
It is also well tested and I would expect the API to be relatively stable.

But let's face it: The project is still experimental and I can't make
any promises.

## Will this get merged with [provider] at some point?

No. At least not until [flutter_hooks] gets merged into Flutter or becomes
more popular than [provider] itself, which are both unlikely.

While [provider] and this project have a lot in common, they do have some
major differences. Differences big enough that it would be a large breaking
change for users of [provider] to migrate [provider_hooks].

Considering this project relies on [flutter_hooks] to work, and that
[flutter_hooks] is far less popular than [provider] (at least for now),
then I think it would be mean to suddenly require provider users to use
[flutter_hooks].

## Will [provider] be deprecated/stop being supported?

Not in the short term, no.

This project is still experimental and unpopular. While it is, in a way,
a [provider] 2.0, its worth has yet to be proven.

Until it is certain that [provider_hooks] is a better way of doing things
and that the community likes it, I do not want to force people to migrate.

[provider]: https://github.com/rrousselGit/provider
[provider_hooks]: https://github.com/rrousselGit/provider_hooks
[flutter_hooks]: https://github.com/rrousselGit/flutter_hooks

# Roadmap

Provider
FutureProvider
StreamProvider
KeepAliveProvider
KeepAliveFutureProvider
KeepAliveStreamProvider

- [ ] context.read/watch
- [ ] provider.select((value) => value.property)
- [ ] SetState can be overriden with a value
- [ ] Provider
- [ ] ProviderBuilder
  - [ ] KeepAlive
  - [ ] SetState
  - [ ] Future
  - [ ] Stream
- [ ] FutureProvider
- [ ] StreamProvider
- [ ] ChangeNotifierProvider
- [ ] ChangeNotifierProviderBuilder
  - [ ] KeepAlive
  - [ ] SetState
  - [ ] Future
  - [ ] Stream
- [ ] ValueNotifierProvider
- [ ] ValueNotifierProviderBuilder
  - [ ] KeepAlive
  - [ ] SetState
  - [ ] Future
  - [ ] Stream
- [ ] StateNotifierProvider
- [ ] StateNotifierProviderBuilder
  - [ ] KeepAlive
  - [ ] SetState
  - [ ] Future
  - [ ] Stream
