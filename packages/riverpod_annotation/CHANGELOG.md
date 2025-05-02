## Unreleased build

Removed dead code

## 3.0.0-dev.13 - 2025-05-01

- `riverpod` upgraded to `3.0.0-dev.13`

## 3.0.0-dev.12 - 2025-04-30

Say hello to Riverpod 3.0.0!  
This major version is a transition version, to unblock the development of the project.
It is quite possible that a 4.0.0 will be released relatively soon in the future, so keep
that in mind when migrating.

Here are some highlights about this version:

- Offline and mutation support, as experimental features
- Automatic retry support
- Pause/resume support
- Simplification of various aspects of the API (such as fusing `AutoDisposeNotifier`/`Notifier`)
- Added a `Ref.mounted` to simplify dealing with provider disposal
- Improved testing with the new `ProviderContainer.test()` and the ability to
  mock a Notifier's `build` method without mocking the whole object using `provider.overrideWithBuild(...)`

**Note about experimental features**:  
Anything imported with `package:riverpod/experimental/....dart` are not stable features.
They may be modified in breaking ways without a major version. Use with care!

### Full change list

- **Breaking** various `package:riverpod` objects are no-longer exported.
  If you wish to use providers by hand, you will have to separately import
  `package:riverpod/riverpod.dart`.
- **Breaking**: `ChangeNotifierProvider`, `StateProvider` and `StateNotifierProvider`
  are moved out of `package:hooks_riverpod/hooks_riverpod.dart` to
  `package:hooks_riverpod/legacy.dart`.
- **Breaking**: All providers now use `==` to compare previous/new values and filter
  updates.
  If you want to revert to the old behavior, you can override `updateShouldNotify` inside
  Notifiers.
- **Breaking**: ProviderListenable.addListener is deleted and now internal-only.
  A simpler alternative will be added in the future.
- **Breaking**: ProviderObserver methods have been updated to take a `ProviderObserverContext` parameter.
  This replaces the old `provider`+`container` parameters, and contains extra
  information.
- **Breaking**: Removed all `Ref` subclasses (such `FutureProviderRef`).
  Use `Ref` directly instead.
  For `FutureProviderRef.future`, migrate to using an `AsyncNotifier`.
- **Breaking** All ref and notifier methods besides "mounted" now throw if used after getting disposed.
- **Breaking**: `StateProvider` and `StateNotifierProvider`
  are moved out of `package:flutter_riverpod/flutter_riverpod.dart` to
  `package:flutter_riverpod/legacy.dart`.
- **Breaking** Some internal utils are no-longer exported.
- **Breaking** `AsyncValue.value` now returns `null` during errors.
- **Breaking** removed `AsyncValue.valueOrNull` (use `.value` instead).
- `Stream/FutureProvider.overrideWithValue` was added back.
- **Breaking**: `Notifier` and variants are now recreated whenever the provider
  rebuilds. This enables using `Ref.mounted` to check dispose.
- **Breaking**: `StreamProvider` now pauses its `StreamSubscription` when
  the provider is not actively listened.
- **Breaking**: Calling ref.watch multiple times calls ref.onListen every-times.
- **Breaking**: A provider is now considered "paused" if all
  of its listeners are also paused. So if a provider `A` is watched _only_ by a provider `B`, and `B` is currently unused,
  then `A` will be paused.
- **Breaking**: When an asynchronous provider rebuilds, it doesn't immediately stops
  listening to its previous providers. Instead, those subscriptions are removed when the rebuild completes.  
  This impacts how "auto-dispose" behaves. See https://github.com/rrousselGit/riverpod/issues/1253
- Added `@mutation` support.
  Mutations are a way to enable your UI to easily listen to the status of side-effects.
  See the documentation of `@mutation` for further information.
- Made `@Riverpod` final
- Added `@Dependencies([...])`, for lint purposes.
  This is similar to `@Riverpod(dependencies: [...])`, but is applied on
  non-provider objects that may use a scoped provider.
- Added support for `@Riverpod(retry: ...)`
- Failing providers are now automatically retried after a delay.
  The delay can be optionally configured.
- Allow using Ref synchronously after a provider has been invalidated.
  This avoids mounted exceptions when doing multiple operations in a quick succession.
- Instead of `Provider.autoDispose()` and `Provider.autoDispose.family()`, it is now possible to write `Provider(isAutoDispose: true)` and `Provider.family(isAutoDispose: true)`.
- Fix `StreamProvider` not cancelling the `StreamSubscription` if the stream is never emitted any value.
- All `Ref` life-cycles (such as `Ref.onDispose`) and `Notifier.listenSelf`
  now return a function to remove the listener.
- Added methods to `ProviderObserver` for listening to "mutations".
  Mutations are a new code-generation-only feature. See riverpod_generator's changelog
  for more information.
- Added `Ref.listen(..., weak: true)`.
  When specifying `weak: true`, the listener will not cause the provider to be
  initialized. This is useful when wanting to react to changes to a provider,
  but not trigger a network request if not necessary.
- `AsyncValue` now has an optional `progress` field.
  This can be set by providers to allow the UI to show a custom progress logic.
- An error is now thrown when trying to override a provider twice in the same
  `ProviderContainer`.
- Disposing a `ProviderContainer` now disposes of all of its sub `ProviderContainers` too.
- Added `ProviderSubscription.pause()`/`.resume()`.
  This enables temporarily stopping the subscription to a provider, without it possibly loosing its state when using `autoDispose`.
- Added `ProviderContainer.test()`. This is a custom constructor for testing
  purpose. It is meant to replace the `createContainer` utility.
- Added `NotifierProvider.overrideWithBuild`, to override `Notifier.build` without
  overriding methods of the notifier.
- `Ref.mounted` has been added. It can now be used to check if a provider
  was disposed.
- When a provider is rebuilt, a new `Ref` is now created. This avoids
  issues where an old build of a provider is still performing work.
- Updated `AsyncValue` documentations to use pattern matching.
- Added support for `Ref/ProviderContainer.invalidate(provider, asReload: true)`
- Failing providers are now automatically retried after a delay.
  The delay can be optionally configured.
- Fixed a bug when overriding a specific provider of a `family`, combined with `dependencies: [family]`

## 3.0.0-dev.3 - 2023-11-27

- `riverpod` upgraded to `3.0.0-dev.3`

## 3.0.0-dev.2 - 2023-11-20

- `riverpod` upgraded to `3.0.0-dev.2`

## 3.0.0-dev.1 - 2023-11-20

- `riverpod` upgraded to `3.0.0-dev.1`

## 3.0.0-dev.0 - 2023-10-29

- `riverpod` upgraded to `3.0.0-dev.0`

## 2.6.1 - 2024-10-22

- `riverpod` upgraded to `2.6.1`

## 2.6.0 - 2024-10-20

- `riverpod` upgraded to `2.6.0`

## 2.5.3 - 2024-10-12

- `riverpod` upgraded to `2.5.3`

## 2.3.5 - 2024-03-10

- `riverpod` upgraded to `2.5.1`

## 2.3.4 - 2024-02-03

- Improved `@Riverpod(dependencies: [...])` documentation.

## 2.3.3 - 2023-11-27

- `riverpod` upgraded to `2.4.9`

## 2.3.2 - 2023-11-20

- `riverpod` upgraded to `2.4.8`

## 2.3.1 - 2023-11-20

- `riverpod` upgraded to `2.4.7`

## 2.3.1 - 2023-11-13

- `riverpod` upgraded to `2.4.6`

## 2.3.0 - 2023-10-28

- Exported internal `FamilyOverride` API, for use in generated code.

## 2.2.1 - 2023-10-15

- `riverpod` upgraded to `2.4.4`

## 2.2.0 - 2023-10-06

- Exports `@internal` from `pkg:meta` for the code-generator to use.

## 2.1.6 - 2023-09-27

- `riverpod` upgraded to `2.4.1`

## 2.1.5 - 2023-09-04

- `riverpod` upgraded to `2.4.0`

## 2.1.4 - 2023-08-28

- `riverpod` upgraded to `2.3.10`

## 2.1.3 - 2023-08-28

- `riverpod` upgraded to `2.3.8`

## 2.1.2 - 2023-08-16

- `riverpod` upgraded to `2.3.7`

## 2.1.1 - 2023-04-24

- `riverpod` upgraded to `2.3.6`

## 2.1.0 - 2023-04-18

- Added support for `Raw` typedef in the return value of providers.
  This can be used to disable the conversion of Futures/Streams into AsyncValues
  ```dart
  @riverpod
  Raw<Future<int>> myProvider(...) async => ...;
  ...
  // returns a Future<int> instead of AsyncValue<int>
  Future<int> value = ref.watch(myProvider);
  ```

## 2.0.4 - 2023-04-07

- `riverpod` upgraded to `2.3.4`

## 2.0.3 - 2023-04-06

- `riverpod` upgraded to `2.3.3`

## 2.0.2 - 2023-03-13

- `riverpod` upgraded to `2.3.2`

## 2.0.1 - 2023-03-09

- `riverpod` upgraded to `2.3.1`

## 2.0.0

- Export necessary utilities for providers returning a Stream.
- Upgraded riverpod dependency

## 1.2.1

Bump minimum Riverpod version

## 1.2.0

- It is now possible to specify `@Riverpod(dependencies: [...])` to scope providers
- Marked `@Riverpod` as `@sealed`

## 1.1.1

Upgrade Riverpod to latest

## 1.1.0

Upgrade Riverpod to latest

## 1.0.6

Upgrade Riverpod to latest

## 1.0.5

Upgrade Riverpod to latest

## 1.0.4

Export more missing types

## 1.0.3

Export missing types

## 1.0.2

- Update a dependency to the latest release.

## 1.0.1

Upgrade Riverpod version

## 1.0.0

Initial release
