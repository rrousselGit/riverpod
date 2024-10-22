## 2.6.1 - 2024-10-22

- Added `AsyncNotifier.listenSelf`. It was mistakenly absent from the 2.6.0 release

## 2.6.0 - 2024-10-20

- Deprecated all `Ref` subclasses. Instead, use `Ref` itself.
- Deprecated `Ref`'s type argument. Use `Ref` without its generic parameter instead.
- Deprecated any `Ref` member that used `Ref`'s generic (such as `Ref.state` or `Ref.listenSelf`).
  Instead, use a `Notifier`.
- Added `Notifier.listenSelf`, as a replacement to `Ref.listenSelf`.
- `Ref.watch` and other methods now accept auto-dispose providers too.

## 2.5.3 - 2024-10-12

- Fixed a typo in the documentation (thanks to @ljbkusters)

## 2.5.2 - 2024-03-18

- Fixed various typos in the documentation (thanks to @kevalvavaliya)

## 2.5.1 - 2024-03-10

- Deprecate `ProviderScope.parent` due to fundamentally not working.
  See https://github.com/rrousselGit/riverpod/issues/3261
- Improved `Provider(dependencies: [...])` documentation.
- Fix out of date `pub.dev` description
- `ref.invalidate` now correctly clear all resources associated
  with the provider if the provider is no-longer used.
- Fix `selectAsync` sometimes never resolving.
- Fix `ProviderSubscription.read` returned by `ref.listen(provider.future)` not throwing if used after the subscription has been closed.
- Fix `ref.onAddListener` and other life-cycles not being triggered when
  listening to `provider.future`/`provider.notifier`.
- Fix a bug that caused `Assertion failed: _lastFuture == null`

## 2.4.10 - 2024-02-03

- Fix out of date `pub.dev` description
- Add `test` argument to `AsyncValue.guard` method. (thanks to @utamori)

## 2.4.9 - 2023-11-27

- Fix "pending timer" issue inside tests when using `ref.keepAlive()`.
- Fix `Ref.invalidate`/`Ref.refresh` not throwing on circular dependency.
- Fix an infinite loop caused by `ref.keepAlive` if the `KeepAliveLink` is immediately closed.
- Fix `container.exists(provider)` on nested containers not checking their
  parent containers.

## 2.4.8 - 2023-11-20

Fix exceptions when using multiple root `ProviderContainers`/`ProviderScopes`.

## 2.4.7 - 2023-11-20

- Fix `ProviderObserver.didUpdateProvider` being called with an incorrect
  "provider" parameter when the provider is overridden.

## 2.4.6 - 2023-11-13

- Exceptions in asynchronous providers are now correctly received
  by `ProviderObserver.providerDidFail`.
- Fix exception when a `ProviderScope` is rebuilt with a different `key`.

## 2.4.5 - 2023-10-28

- Support assigning `AsyncValue<T>` to `AsyncNotifier<void>.state`

## 2.4.4 - 2023-10-15

- `riverpod` upgraded to `2.4.4`

## 2.4.3 - 2023-10-06

- Fixed incorrect `@visibleForTesting` warning.

## 2.4.2 - 2023-10-02

- Improved the error message when WidgetRef is used after the associated widget got unmounted.

## 2.4.1 - 2023-09-27

- `riverpod` upgraded to `2.4.1`

## 2.4.0 - 2023-09-04

- `riverpod` upgraded to `2.4.0`

## 2.3.10 - 2023-08-28

- `riverpod` upgraded to `2.3.10`

## 2.3.9 - 2023-08-28

- Fix some exceptions causing Flutter asking to demangle stacktraces (#1874)
- Fix out of date `AsyncValue` docs.

## 2.3.7 - 2023-08-16

- Added support for state_notifier 1.0.0
- `Notifier.state` is now accessible inside tests

## 2.3.6 - 2023-04-24

- Improved error message for missing `dependencies` (thanks to @ValentinVignal)
- Fixed various typos in the documentation (thanks to @ValentinVignal)
- Fix not disposing autoDispose family providers
- Removed incorrect statement in ChangeNotifierProvider docs

## 2.3.5 - 2023-04-18

- fix `AsyncValue.isReloading` docs

## 2.3.4 - 2023-04-07

- Fixes an issue with nested ProviderScope (thanks to @jeiea)

## 2.3.3 - 2023-04-06

- The debugger no-longer pauses on uncaught exceptions inside providers.
  This was voluntary, but too many people have complained that it often
  is a false positive.
- Removed unused dependency (thanks to @passsy)

## 2.3.2 - 2023-03-13

- Deprecated the generic parameter of `Family`.
  This will enable implementing generic providers in `riverpod_generator` once
  it is removed.
- Updated documentation

## 2.3.1 - 2023-03-09

- `riverpod` upgraded to `2.3.1`

## 2.3.0

- Added `StreamNotifier` + `StreamNotifierProvider`.
  This is for building a `StreamProvider` while exposing ways to modify the stream.

  It is primarily meant to be used using code-generation via riverpod_generator,
  by writing:

  ```dart
  @riverpod
  class Example extends _$Example {
    @override
    Stream<Model> build() {
      // TODO return some stream
    }
  }
  ```

- Deprecated `StreamProvider.stream`
  Instead of:

  ```dart
  ref.watch(provider.stream).listen(...)
  ```

  do:

  ```dart
  ref.listen(provider, (_, value) {...});
  ```

  Instead of:

  ```dart
  final a = StreamProvider((ref) {
    return ref.watch(b.stream).map((e) => Model(e));
  })
  ```

  Do:

  ```dart
  final a = FutureProvider((ref) async {
    final e = await ref.watch(b.future);
    return Model(e);
  })
  ```

- Some restrictions on the `dependencies` parameter of providers have been lifted.
  It is no-longer necessary to include providers which do not themselves specify `dependencies`.
  All providers should specify `dependencies` if they are scoped at any point.

- Annotated `Notifier.state` setter as protected.

## 2.2.0

- Improve type-inference when using `AsyncValue.whenOrNull` (thanks to @AhmedLSayed9)
- Fixed AsyncValue.asError incorrectly not preserving the generic type
- Internal refactoring for riverpod_generator

## 2.1.3

Fixes an issue with `FutureProvider<void>` (#2028)

## 2.1.2

- It is now correctly possible to use `ProviderSubscription`s inside `ConsumerState.dispose` (thanks to @1980)
- Update dependencies.
- fixes an exception on newer Dart versions
- fixes an edge-case where `FutureProvider`/`AsyncNotifier` did not emit the new state when the created `Future` completed (#1997)
- fixes errors inside FutureProvider/AsyncNotifier/StreamProvider not preserving the previous state (if any).
- Update dependencies.

## 2.1.1

Fix typos

## 2.1.0

A small release adding missing utilities and fixing some web related issues.

- Added `provider.overrideWith((ref) => state`)
- Added `FutureProviderRef.future`.
- Deprecated `StateProvider.state`
  Instead, use either `ref.watch(stateProvider)` or `ref.read(stateProvider.notifier).state =`
- Deprecated `provider.overrideWithProvider`. Instead use `provider.overrideWith`
- Added `Ref.notifyListeners()` to forcibly notify dependents.
  This can be useful for mutable state.
- Added `@useResult` to `Ref.refresh`/`WidgetRef.refresh`
- Added `Ref.exists` to check whether a provider is initialized or not.
- `FutureProvider`, `StreamProvider` and `AsyncNotifierProvider` now preserve the
  previous data/error when going back to loading.
  This is done by allowing `AsyncLoading` to optionally contain a value/error.
- Added `AsyncValue.when(skipLoadingOnReload: bool, skipLoadingOnRefresh: bool, skipError: bool)`
  flags to give fine control over whether the UI should show `loading`
  or `data/error` cases.
- Add `AsyncValue.requireValue`, to forcibly obtain the `value` and throw if in
  loading/error state
- Doing `ref.watch(futureProvider.future)` can no-longer return a `SynchronousFuture`.
  That behavior could break various `Future` utilities, such as `Future.wait`
- Add `AsyncValue.copyWithPrevious(..., isRefresh: false)` to differentiate
  rebuilds from `ref.watch` vs rebuilds from `ref.refresh`.
- ProviderContainer no-longer throws when disposed if it has an undisposed child ProviderContainer.
- Improved the error message when trying to modify a provider inside a
  widget life-cycle.

- Fixes a stackoverflow on Web caused by Dart (thanks to @leehack)
- Fixes a bug when the root ProviderContainer is not associated with a ProviderScope.
- Fixes a case where a circular dependency between providers was incorrectly allowed (#1766)

## 2.0.2

- **FIX**: Fixed an assert error if a `family` depends on itself while specifying `dependencies`. (#1721).

# 2.0.2

Fixed an assert error if a `family` depends on itself while specifying `dependencies`.

# 2.0.1

Updated changelog (see 2.0.0)

# 2.0.0

Here is the changelog for all the changes in the 2.0 version.
An article is in progress and will be linked here once available.

**Breaking changes**:

- `FutureProvider.stream` is removed.
- Using `overrideWithProvider`, it is no-longer possible to override a provider
  with a different type of provider (such as overriding `FutureProvider` with a `StreamProvider`).
- `AsyncError.stackTrace` is now a required positional parameter and non-nullable
- All `overrideWithValue` methods are removed, besides `Provider.overrideWithValue`.
  This change is temporary, and these methods will be reintroduced in a later version.
  In the meantime, you can use `overrideWithProvider`.
- Modifiers (`provider.future`, `provider.state`, ...) no-longer are providers, and therefore no-longer
  appear inside `ProviderObserver`.
- The `Reader` typedef is removed. Use `Ref` instead.
- `ProviderListener` is removed. Used `ref.listen` instead.
- Removed the deprecated `ProviderReference`.
- Providers no-longer throw a `ProviderException` if an exception was thrown while building their value.
  Instead, they will rethrow the thrown exception and its stacktrace.
- It is no longer possible to pass `provider.future/.notifier/...` to the parameter `dependencies` of provider.
  Passing the provider directly is enough.
- The `Family` type now has a single generic parameter instead of 3.

Non-breaking changes:

- Upgrade minimum required Flutter SDK version to 3.0.0
- Upgrade minimum required Dart SDK version to 2.17.0
- Added `WidgetRef.context`. This allows functions that depend on a `WidgetRef`
  to use the `BuildContext` without having to receive it as parameter.
- Added `provider.selectAsync`, which allows to both await an async value
  while also filtering rebuilds.
- Added `WidgetRef.listenManual` for listening to providers in a widget
  outside of `build`.
- Added `ref.listenSelf`, for subscribing to changes of a provider within
  that provider.
  That can be useful for logging purposes or storing the state of a provider
  in a DB.
- Added `container.invalidate(provider)`/`ref.invalidate(provider)` and `ref.invalidateSelf()`.
  These are similar to `ref.refresh` methods, but do not immediately rebuild the provider.

These methods are safer than `ref.refresh` as they can avoid a provider
rebuilding twice in a quick succession.

- Added `ref.onAddListener`, `ref.onRemoveListener`, `ref.onCancel` and
  `ref.onResume`. All of which allow performing side-effects when providers
  are listened or stop being listened.

- A new `AutoDisposeRef.keepAlive()` function is added. It is meant to replace
  `AutoDisposeRef.maintainState` to make logic for preventing the disposal of a provider more reusable.
- feat; `AutoDisposeRef.maintainState` is deprecated. Use the new `AutoDisposeRef.keepAlive()` instead.
- Add support for `ref.invalidate(family)` to recompute an entire family (#1517)
- Added `AsyncValue.valueOrNull` to obtain the value while ignoring potential errors.
- Added new functionalities to `AsyncValue`: `hasError`, `hasData`, `asError`, `isLoading`
  , `copyWithPrevious` and `unwrapPrevious`.

Fixes:

- fixed a bug where `AsyncValue.whenData` did not preserve `AsyncValue.isLoading/isRefreshing`
- `StateProvider` and `StateNotifierProvider` no longer notify their listeners
  on `ref.refresh` if the new result is identical to the old one.
- fixed potential null exception when using `autoDispose`
- fixed a bug where unmounting a nested ProviderScope could cause an exception (#1400)
- Fixed an issue where providers were incorrectly allowed to depend on themselves,
  breaking `autoDispose` in the process.
- Fixed a memory leak when using `StateProvider.autoDispose`'s `.state`
- Fix `ProviderObserver.didDisposeProvider` not executing on provider refresh.
- Fixed an issue where `AsyncValue.value` did not throw if there is an error.
- Fixed a cast error when overriding a provider with a more specific provider type (#1100)
- Fixed a bug where `onDispose` listeners could be executed twice under certain
  conditions when using `autoDispose`.
- Fixed an issue where refreshing a `provider.future`/`provider.stream` did work properly
- Fixed false positive with `ref.watch` asserts

## 1.0.3

Removed an assert preventing from overriding the same provider/family
multiple times on a `ProviderScope`/`ProviderContainer`.

## 1.0.2

Fixed a null exception on web

## 1.0.1

Improved the performance of the assert which verifies that providers properly
respect their `dependencies` variable.

## 1.0.0

Riverpod is now stable!

### General changes

- **Breaking**: `ProviderContainer.debugProviderValues` and `ProviderContainer.debugProviderElements` are removed.
  You can now instead use `ProviderContainer.getAllProviderElements`.
- `ChangeNotifierProvider` now supports nullable `ChangeNotifier` (#856)
- Increased minimum SDK version to 2.14.0
- **Breaking** The return value when reading a `StateProvider` changed.
  Before, doing `ref.read(someStateProvider)` would return the `StateController` instance.
  Now, this will only return the state of the `StateController`.
  This new behaviour matches `StateNotifierProvider`.

  For a simple migration, the old behavior is available by writing
  `ref.read(someStateProvider.state)`.

- Added `ref.listen` for triggering actions inside providers/widgets when a provider changes.

  It can be used to listen to another provider without recreating the provider state:

  ```dart
  final counterProvider = StateNotifierProvider<Counter, int>(...);

  final anotherProvider = Provider<T>((ref) {
    ref.listen<int>(counterProvider, (previous, count) {
      print('counter changed from $previous to $count');
    });
  });
  ```

  Alternatively, it can be used by widgets to show modals/dialogs:

  ```dart
  final counterProvider = StateNotifierProvider<Counter, int>(...);

  class Example extends ConsumerWidget {
    @override
    Widget build(BuildContext context, WidgetRef ref) {
      ref.listen<int>(counterProvider, (previous, count) {
        showDialog(...);
      });
    }
  }
  ```

- `ProviderListener` is deprecated in favor of `ref.listen`.

- It is now possible to "await" all providers that emit an `AsyncValue` (previously limited to `FutureProvider`/`StreamProvider`).
  This includes cases where a `StateNotifierProvider` exposes an `AsyncValue`:

  ```dart
  class MyAsyncStateNotifier extends StateNotifier<AsyncValue<MyState>> {
    MyAsyncStateNotifier(): super(AsyncValue.loading()) {
      // TODO fetch some data and update the state when it is obtained
    }
  }

  final myAsyncStateNotifierProvider = StateNotifierProvider<MyAsyncStateNotifier, AsyncValue<MyState>>((ref) {
    return MyAsyncStateNotifier();
  });

  final someFutureProvider = FutureProvider((ref) async {
    MyState myState = await ref.watch(myAsyncStateNotifierProvider.future);
  });
  ```

- Deprecated `StreamProvider.last` in favor of `StreamProvider.future`.

- `StreamProvider.future`, `StreamProvider.stream` and `FutureProvider.future` now
  expose a future/stream that is independent from how many times the associated provider "rebuilt":
  - if a `StreamProvider` rebuild before its stream emitted any value,
    `StreamProvider.future` will resolve with the first value of the new stream instead.
  - if a `FutureProvider` rebuild before its future completes,
    `FutureProvider.future` will resolve with the result of the new future instead.
- You can now override any provider with any other provider, as long as the value
  that they expose matches. For example, it is possible to override a `StreamProvider<Model>`
  with a `Provider<AsyncValue<Model>>`.
- `ref.onDispose` now calls the dispose function as soon as one of the provider's
  dependency is known to have changed
- Providers can now call `ref.refresh` to refresh a provider, instead of having
  to do `ref.container.refresh`.
- Providers no longer wait until their next read to recompute their state if one
  of their dependency changed and they have listeners.
- Added `ProviderContainer.pump`, a utility to easily "await" until providers
  notify their listeners or are disposed.
- fixed an issue when using both `family` and `autoDispose` that could lead to an inconsistent state

### Unified the syntax for interacting with providers

- **Breaking**: The prototype of `ConsumerWidget`'s `build` and `Consumer`'s `builder` changed.
  Before:

  ```dart
  class Example extends ConsumerWidget {
    @override
    Widget build(BuildContext context, ScopedReader watch) {
      int count = watch(counterProvider);
      ...
    }
  }
  ```

  After:

  ```dart
  class Example extends ConsumerWidget {
    @override
    Widget build(BuildContext context, WidgetRef ref) {
      int count = ref.watch(counterProvider);
      ...
    }
  }
  ```

- `ProviderListener` is deprecated. Instead, use `ref.listen`:

  ```dart
  class Example extends ConsumerWidget {
    @override
    Widget build(BuildContext context, WidgetRef ref) {
      ref.listen<int>(counter, (count) {
        print('count changed $count');
      });
    }
  }
  ```

- Added `ConsumerStatefulWidget` + `ConsumerState`, a variant of
  `StatefulWidget`s that have access to a `WidgetRef`.

- All "watch" functions now support `myProvider.select((value) => ...)`.
  This allows filtering rebuilds:

  ```dart
  final userProvider = StateNotifierProvider<UserController, User>(...);

  Consumer(
    builder: (context, ref, _) {
      // With this syntax, the Consumer will not rebuild if `userProvider`
      // emits a new User but its "name" didn't change.
      bool userName = ref.watch(userProvider.select((user) => user.name));
    },
  )
  ```

- `ProviderReference` is deprecated in favor of `Ref`.

- **Breaking**: `ProviderObserver.didUpdateProvider` now receives both the previous and new value.
- **Breaking**: `ProviderObserver.mayHaveChanged` is removed.

- **Breaking**: `Family.overrideWithProvider` now must create a provider:

  ```dart
  final family = Provider.family<State, Arg>(...);

  family.overrideWithProvider(
    (Arg arg) => Provider<State>((ref) => ...)
  );
  ```

- All providers now receive a custom subclass of `ProviderRefBase` as a parameter:

  ```dart
  Provider<T>((ProviderRef<T> ref) {...});
  FutureProvider<T>((FutureProviderRef<T> ref) {...});
  StateProvider<T>((StateProviderRef<T> ref) {...});
  ```

  That allows providers to implement features that is not shared with other providers.

  - `Provider`, `FutureProvider` and `StreamProvider`'s `ref` now have a `state` property,
    which represents the currently exposed value. Modifying it will notify the listeners:

    ```dart
    Provider<int>((ref) {
      ref.listen(onIncrementProvider, (_) {
        ref.state++;
      });

      return 0;
    });
    ```

  - `StateProvider`'s `ref` now has a `controller` property, which allows the
    provider to access the `StateController` exposed.

- **Breaking**: `ProviderReference.mounted` is removed. You can implement something similar using `onDispose`:
  ```dart
  Provider<T>((ref) {
    var mounted = true;
    ref.onDispose(() => mounted = false);
  });
  ```

### All providers can now be scoped.

- **Breaking**: `ScopedProvider` is removed.
  To migrate, change `ScopedProvider`s to `Provider`s.

- All providers now come with an extra named parameter called `dependencies`.
  This parameter optionally allows defining the list of providers/families that this
  new provider depends on:

  ```dart
  final a = Provider(...);

  final b = Provider((ref) => ref.watch(a), dependencies: [a]);
  ```

  By doing so, this will tell Riverpod to automatically override `b` if `a` gets overridden.

### Updated `AsyncValue`:

- **Breaking** `AsyncValue.copyWith` is removed
- **Breaking** `AsyncValue.error(..., stacktrace)` is now a named parameter instead of positional parameter.
- Deprecated `AsyncValue.data` in favor of `AsyncValue.value`
- Allowed `AsyncData`, `AsyncError` and `AsyncLoading` to be extended
- Added `AsyncValue.whenOrNull`, similar to `whenOrElse` but instead of an
  "orElse" parameter, returns `null`.
- Added `AsyncValue.value`, which allows reading the value without handling
  loading/error states.
- `AsyncError` can now be instantiated with `const`.

- Added `StateController.update`, to simplify updating the state from the previous state:
  ```dart
  final provider = StateController((ref) => 0);
  ...
  ref.read(provider).update((state) => state + 1);
  ```
- It is no longer allowed to use `ref.watch` or `ref.read` inside a selector:

  ```dart
  provider.select((value) => ref.watch(something)); // KO, cannot user ref.watch inside selectors
  ```

- FutureProvider now creates a `FutureOr<T>` instead of a `Future<T>`.
  That allows bypassing the loading state in the event where a value was synchronously available.

### Bug fixes

- Fixed a bug where widgets were not rebuilding in release mode under certain conditions
- **FIX**: StreamProvider.last no longer throws a StateError when no value were emitted (#296).
- fixed an issue where when chaining providers, widgets may re-render
  a frame late, potentially causing a flicker. (see #648)

## 1.0.0-dev.11

Fixed an issue where `dependencies` did not work for `ChangeNotifierProvider` (#800)

## 1.0.0-dev.10

Fixed a bug where reading a provider within a consumer could throw (#796)

## 1.0.0-dev.9

Fix an issue where `*Provider.autoDispose` were not able to specify the
`dependencies` parameter.

## 1.0.0-dev.8

### Future/StreamProvider

- FutureProvider now creates a `FutureOr<T>` instead of a `Future<T>`
  That allows bypassing the loading state in the event where a value was synchronously available.

- During loading and error states, `FutureProvider` and `StreamProvider` now expose the
  latest value through `AsyncValue`.
  That allows UI to show the previous data while some new data is loading,
  instead of showing a spinner:

  ```dart
  final provider = FutureProvider<User>((ref) async {
    ref.watch(anotherProvider); // may cause `provider` to rebuild

    return fetchSomething();
  })
  ...

  Widget build(context, ref) {
    return ref.watch(provider).when(
      error: (err, stack, _) => Text('error'),
      data: (user) => Text('Hello ${user.name}'),
      loading: (previous) {
        if (previous is AsyncData<User>) {
          return Text('loading ... (previous: ${previous.value.name})');
        }

        return CircularProgressIndicator();
      }
    );

  }
  ```

### AsyncValue

- **Breaking** `AsyncValue.copyWith` is removed
- **Breaking** `AsyncValue.error(..., stacktrace)` is now a named parameter instead of positional parameter.
- **Breaking** `AsyncValue.when(loading: )` and `AsyncValue.when(error: )` (and `when` variants)
  now receive an extra "previous" parameter.
- Deprecated `AsyncValue.data` in favor of `AsyncValue.value`
- Allowed `AsyncData`, `AsyncError` and `AsyncLoading` to be extended
- Added `AsyncValue.whenOrNull`, similar to `whenOrElse` but instead of an
  "orElse" parameter, returns `null`.
- Added `AsyncValue.value`, which allows reading the value without handling
  loading/error states.
- `AsyncError` can now be instantiated with `const`.
- `AsyncLoading` and `AsyncError` now optionally includes the previous state.

### General

- **Breaking** All `overrideWithProvider` methods are removed.
  To migrate, instead use `overrideWithValue`.
- All providers now come with an extra named parameter called `dependencies`.
  This parameter optionally allows defining the list of providers/families that this
  new provider depends on:

  ```dart
  final a = Provider(...);

  final b = Provider((ref) => ref.watch(a), dependencies: [a]);
  ```

  By doing so, this will tell Riverpod to automatically override `b` if `a` gets overridden.

- Added `StateController.update`, to simplify updating the state from the previous state:
  ```dart
  final provider = StateController((ref) => 0);
  ...
  ref.read(provider).update((state) => state + 1);
  ```
- It is no longer allowed to use `ref.watch` or `ref.read` inside a selector:
  ```dart
  provider.select((value) => ref.watch(something)); // KO, cannot user ref.watch inside selectors
  ```

### Bug-fixes

- fixed a bug where providers were rebuilding even when not listened to
- fixed `ref.listen` now working when downcasting the value of a provider.
- fixed a bug where disposing a scoped `ProviderContainer` could cause other
  `ProviderContainer`s to stop working.
- fixed an issue where conditionally depending on an "autoDispose" provider
  may not properly dispose of it (see #712)
- fixed an issue where when chaining providers, widgets may re-render
  a frame late, potentially causing a flicker. (see #648)

## 1.0.0-dev.7

- Fixed `ProviderObserver` not working when modifying a `StateProvider`.
- Fixed a bug where scoped provider were potentially not disposed
- Fixed a bug where widgets were not rebuilding in release mode under certain conditions

## 1.0.0-dev.6

- **FIX**: StreamProvider.last no longer throws a StateError when no value were emitted (#296).
- Re-enabled debug assertions that were temporarily disabled by previous dev versions.
- Allows families to be scoped/overridden
- Fixed bugs with `ref.refresh` not working on some providers
- renamed `ProviderBase.recreateShouldNotify` to `updateShouldNotify`

## 1.0.0-dev.5

Fixed an issue where provider listeners could not be called properly.

## 1.0.0-dev.3

Fixed various issues related to scoped providers.

## 1.0.0-dev.2

- All providers can now be scoped.
- **breaking**: `ScopedProvider` is removed. To migrate, change `ScopedProvider`s to `Provider`s.

## 1.0.0-dev.1

- Add missing exports (see #532)

## 1.0.0-dev.0

- **Breaking**: The prototype of `ConsumerWidget`'s `build` and `Consumer`'s `builder` changed.
  Before:

  ```dart
  class Example extends ConsumerWidget {
    @override
    Widget build(BuildContext context, ScopedReader watch) {
      int count = watch(counterProvider);
      ...
    }
  }
  ```

  After:

  ```dart
  class Example extends ConsumerWidget {
    @override
    Widget build(BuildContext context, WidgetRef ref) {
      int count = ref.watch(counterProvider);
      ...
    }
  }
  ```

- `ProviderListener` is deprecated. Instead, use `ref.listen`:

  ```dart
  class Example extends ConsumerWidget {
    @override
    Widget build(BuildContext context, WidgetRef ref) {
      ref.listen<int>(counter, (count) {
        print('count changed $count');
      });
    }
  }
  ```

- Added `ConsumerStatefulWidget` + `ConsumerState`, a variant of
  `StatefulWidget`s that have access to a `WidgetRef`.

- All "watch" functions now support `myProvider.select((value) => ...)`.
  This allows filtering rebuilds:

  ```dart
  final userProvider = StateNotifierProvider<UserController, User>(...);

  Consumer(
    builder: (context, ref, _) {
      // With this syntax, the Consumer will not rebuild if `userProvider`
      // emits a new User but its "name" didn't change.
      bool userName = ref.watch(userProvider.select((user) => user.name));
    },
  )
  ```

- **Breaking**: `Family.overrideWithProvider` now must create a provider:

  ```dart
  final family = Provider.family<State, Arg>(...);

  family.overrideWithProvider(
    (Arg arg) => Provider<State>((ref) => ...)
  );
  ```

- **Breaking**: `ProviderObserver.didUpdateProvider` now receives both the previous and new value.
- **Breaking**: `ProviderObserver.mayHaveChanged` is removed.
- Added `ref.listen`, used to listen to another provider without recreating the provider state:

  ```dart
  final counter = StateNotifierProvider<Counter, int>(...);

  final anotherProvider = Provider<T>((ref) {
    ref.listen<int>(counter, (count) {
      print('counter change: $count');
    });
  });
  ```

- `ProviderReference` is deprecated in favor of `ProviderRefBase`.
- All providers now receive a custom subclass of `ProviderRefBase` as a parameter:

  ```dart
  Provider<T>((ProviderRef<T> ref) {...});
  FutureProvider<T>((FutureProviderRef<T> ref) {...});
  StateProvider<T>((StateProviderRef<T> ref) {...});
  ```

  That allows providers to implement features that is not shared with other providers.

  - `Provider`, `FutureProvider` and `StreamProvider`'s `ref` now have a `state` property,
    which represents the currently exposed value. Modifying it will notify the listeners:

    ```dart
    Provider<int>((ref) {
      ref.listen(onIncrementProvider, (_) {
        ref.state++;
      });

      return 0;
    });
    ```

  - `StateProvider`'s `ref` now has a `controller` property, which allows the
    provider to access the `StateController` exposed.

- **Breaking**: `ProviderReference.mounted` is removed. You can implement something similar using `onDispose`:
  ```dart
  Provider<T>((ref) {
    var mounted = true;
    ref.onDispose(() => mounted = false);
  });
  ```
- **Breaking**: `ProviderContainer.debugProviderValues` and `ProviderContainer.debugProviderElements` are removed.
  You can now instead use `ProviderContainer.getAllProviderElements`.
- `StreamProvider.last`, `StreamProvider.stream` and `FutureProvider.future` now
  expose a future/stream that is independent from how many times the associated provider "rebuilt":
  - if a `StreamProvider` rebuild before its stream emitted any value,
    `StreamProvider.last` will resolve with the first value of the new stream instead.
  - if a `FutureProvider` rebuild before its future completes,
    `FutureProvider.future` will resolve with the result of the new future instead.
- You can now override any provider with any other provider, as long as the value
  that they expose matches. For example, it is possible to override a `StreamProvider<Model>`
  with a `Provider<AsyncValue<Model>>`.
- Providers can now call `ref.refresh` to refresh a provider, instead of having
  to do `ref.container.refresh`.
- `ref.onDispose` now calls the dispose function as soon as one of the provider's
  dependency is known to have changed
- Providers no longer wait until their next read to recompute their state if one
  of their dependency changed and they have listeners.
- Added `ProviderContainer.pump`, a utility to easily "await" until providers
  notify their listeners or are disposed.
- fixed an issue when using both `family` and `autoDispose` that could lead to an inconsistent state

## 0.14.0+3

Removed an assert that could cause issues when an application is partially migrated to null safety.

## 0.14.0+2

- Fix `context.refresh` not compiling when using nullable providers

## 0.14.0+1

- Re-added `StateProvider.overrideWithValue`/`StateProvider.overrideWithProvider` that were unvoluntarily removed.

## 0.14.0

- **BREAKING CHANGE** The `Listener`/`LocatorMixin` typedefs are removed as the former could cause a name
  conflict with the widget named `Listener` and the latter is not supported when using Riverpod.
- **BREAKING CHANGE** The syntax for using `StateNotifierProvider` was updated.
  Before:

  ```dart
  class MyStateNotifier extends StateNotifier<MyModel> {...}

  final provider = StateNotifierProvider<MyStateNotifier>((ref) => MyStateNotifier());

  ...
  Widget build(context, watch) {
    MyStateNotifier notifier = watch(provider);
    MyModel model = watch(provider.state);
  }
  ```

  After:

  ```dart
  class MyStateNotifier extends StateNotifier<MyModel> {...}

  final provider = StateNotifierProvider<MyStateNotifier, MyModel>>((ref) => MyStateNotifier());

  ...
  Widget build(context, watch) {
    MyStateNotifier notifier = watch(provider.notifier);
    MyModel model = watch(provider);
  }
  ```

  See also https://github.com/rrousselGit/riverpod/issues/341 for more information.

- **BREAKING CHANGE** It is no longer possible to override `StreamProvider.stream/last` and `FutureProvider.future`.
- feat: Calling `ProviderContainer.dispose` multiple time no longer throws.
  This simplifies the tear-off logic of tests.
- feat: Added `ChangeNotifierProvider.notifier` and `StateProvider.notifier`
  They allow obtaining the notifier associated with the provider, without causing widgets/providers to rebuild when the state updates.
- fix: overriding a `StateNotifierProvider`/`ChangeNotifierProvider` with `overrideWithValue` now correctly listens to the notifier.

## 0.1

## 0.13.1+1

Fixed an issue where `context.read` and `ProviderListener` were unable to read providers that return a nullable value

## 0.13.1

- Fixed a bug where overriding a `FutureProvider` with an error value could cause tests to fail (see https://github.com/rrousselGit/riverpod/issues/355)

## 0.13.0

- stable null-safety release
- `ProviderObserver` can now have a const constructor
- Added the mechanism for state-inspection using the Flutter devtool
- loosened the version constraints of `freezed_annotation`
- deprecated `import 'flutter_riverpod/all.dart'`. Now everything is available with `flutter_riverpod/flutter_riverpod.dart`.
- Fixed a but where listening to `StreamProvider.last` could result in a `StateError` (#217)
- removed the assert preventing ConsumerWidget's "watch" from being used after the `build` method completed.
  This allows "watch" to be used inside `ListView.builder`.
- `context.read(myProvider)` now accepts `ScopeProviders`

## 0.13.0-nullsafety.3

- deprecated `import 'flutter_riverpod/all.dart'`. Now everything is available with `flutter_riverpod/flutter_riverpod.dart`.
- removed the assert preventing ConsumerWidget's "watch" from being used after the `build` method completed.
  This allows "watch" to be used inside `ListView.builder`.
- `context.read(myProvider)` now accepts `ScopeProviders`

## 0.13.0-nullsafety.2

- Fixed outdated doc

## 0.13.0-nullsafety.1

- Fixed a but where listening to `StreamProvider.last` could result in a `StateError` (#217)

## 0.13.0-nullsafety.0

Migrated to null-safety

## 0.12.2

- Exported `AutoDisposeProviderRefBase`

## 0.12.1

- Fixed an remaining memory leak related to StreamProvider (see also https://github.com/rrousselGit/riverpod/issues/193)

## 0.12.0

- **Breaking** FutureProvider and StreamProvider no longer supports `null` as a valid value.
- Fixed a memory leak with StreamProvider (see also https://github.com/rrousselGit/riverpod/issues/193)
- Fixed an error message typo related to Consumer

## 0.11.2

- Fixed a bug where providers (usually ScopedProviders) did not dispose correctly
  (see also https://github.com/rrousselGit/riverpod/issues/154).

## 0.11.1

- Fixed a bug where hot-reload did not work for `ConsumerWidget`/`Consumer`

## 0.11.0

- `package:flutter_riverpod/flutter_riverpod.dart` now exports `StateNotifier`
- Marked the providers with `@sealed` so that the IDE warns against
  implementing/subclassing providers.
- Fix mistakes in `AsyncValue.guard`'s documentation (thanks @mono0926)
- Loosened the version constraints of `freezed_annotation` to support `0.12.0`

## 0.10.1

- Fixed invalid version error

## 0.10.0

- Fixed a bug where the state of a provider may be disposed when it shouldn't be disposed.

- Added a way to import the implementation class of providers with modifiers,
  such as `AutoDisposeProvider`.

  This is useful if you want to use Riverpod with the lint `always_specify_types`:

  ```dart
  import 'package:flutter_riverpod/all.dart';

  final AutoDisposeStateProvider<int> counter = StateProvider.autoDispose<int>((ProviderRefBase ref) {
    return 0;
  });
  ```

  If you do not use this lint, prefer using the default import instead, to not
  pollute your auto-complete.

## 0.9.0

- **Breaking** Updating `ProviderListener` so that `onChange` receives the
  `BuildContext` as a parameter (thanks to @tbm98)

## 0.8.0

- Renamed `ProviderContainer.debugProviderStates` to `ProviderContainer.debugProviderElements`
- Fixed a bug where updating `ProviderScope.overrides` may cause an exception
  for no reason (see https://github.com/rrousselGit/riverpod/issues/107)

## 0.7.2

Fixed a bug that prevented the use of `ConsumerWidget` under normal circumstances

## 0.7.1

- Fixed a bug where in release mode, `ScopedProvider` did not update correctly (https://github.com/rrousselGit/riverpod/issues/101)

## 0.7.0

- **Breaking**: `Consumer` is slightly modified to match other Builders like
  `ValueListenableBuilder`.
  Before:

  ```dart
  return Consumer((context, watch) {
    final value = watch(myProvider);
    return Text('$value');
  });
  ```

  after:

  ```dart
  return Consumer(
    builder: (context, watch, child) {
      final value = watch(myProvider);
      return Text('$value');
    },
  );
  ```

- Added a `ConsumerWidget` class which can be extended to make a `StatelessWidget`
  that can read providers:

  ```dart
  class MyWidget extends ConsumerWidget {
    const MyWidget({Key? key}) : super(key: key);

    @override
    Widget build(BuildContext context, ScopedReader watch) {
      final value = watch(myProvider);
      return Text('$value');
    }
  }
  ```

- `ref.watch` on non ".autoDispose" providers can no longer read ".autoDispose"
  providers.

  For more info, see http://riverpod.dev/docs/concepts/modifiers/auto_dispose#the-argument-type-autodisposeprovider-cant-be-assigned-to-the-parameter-type-alwaysaliveproviderbase

- `ScopedProvider` now accepts `null` as a function:

  ```dart
  final example = ScopedProvider<int>(null);
  ```

  Which is equivalent to:

  ```dart
  final example = ScopedProvider<int>((watch) => throw UnimplementedError(''));
  ```

- Fixed a bug where `context.refresh` may not work properly if the widget tree
  contains multiple `ProviderScope`.

## 0.6.1

- Fixed a bug where when disposing `ProviderContainer`, providers may be disposed
  in an incorrect order.
- Improved the performances of reading providers by 25%

## 0.6.0

- Merged `Computed` and `Provider`. Now, all providers have the ability to rebuild
  their state when one of the object they listen changed.

  To migrate, change:

  ```dart
  final provider = Provider(...);
  final example = Computed((watch) {
    final value = watch(provider);
    return value;
  });
  ```

  into:

  ```dart
  final provider = Provider(...);
  final example = Provider((ref) {
    final value = ref.watch(provider);
    return value;
  });
  ```

- `Computed` (now `Provider`) no longer deeply compare collections to avoid rebuilds.
  Comparing the content of lists is quite expensive and actually rarely useful.
  Now, a simple `==` comparison is used.

- Renamed `ProviderStateOwner` to `ProviderContainer`
- Renamed `ProviderStateOwnerObserver` to `ProviderObserver`

- It is no longer possible to override a provider anywhere in the widget tree.
  Providers can only be overridden in the top-most `ProviderScope`/`ProviderContainer`.

- Providers can now read values which may change over time using `ref.read` and `ref.watch`.
  When using `ref.watch`, if the value obtained changes, this will cause the provider
  to re-create its state.

- It is no longer possible to add `ProviderObserver` anywhere in the widget tree.
  They can be added only on the top-most `ProviderScope`/`ProviderContainer`.

- `Provider.read(BuildContext)` is changed into `context.read(provider)`, and
  can now read `Provider.autoDispose`.

- Added `ProviderContainer.refresh(provider)` and `context.refresh(provider)`.
  These method allows forcing the refresh of a provider, which can be useful
  for things like "retry on error" or "pull to refresh".

* `ref.read(StreamProvider<T>)` no longer returns a `Stream<T>` but an `AsyncValue<T>`
  Before:

  ```dart
  final streamProvider = StreamProvider<T>(...);
  final example = Provider((ref) {
    Stream<T> stream = ref.read(streamProvider);
  });
  ```

  After:

  ```dart
  final streamProvider = StreamProvider<T>(...);
  final example = Provider((ref) {
    Stream<T> stream = ref.watch(streamProvider.steam);
  });
  ```

* `ref.read(FutureProvider<T>)` no longer returns a `Future<T>` but an `AsyncValue<T>`

  Before:

  ```dart
  final futureProvider = FutureProvider<T>(...);
  final example = Provider((ref) {
    Future<T> future = ref.read(futureProvider);
  });
  ```

  After:

  ```dart
  final futureProvider = FutureProvider<T>(...);
  final example = Provider((ref) {
    Future<T> future = ref.watch(futureProvider.future);
  });
  ```

* Removed `ref.dependOn`.
  You can now use `ref.read`/`ref.watch` to achieve the same effect.

  Before:

  ```dart
  final streamProvider = StreamProvider<T>(...);
  final example = Provider((ref) {
    Future<T> last = ref.dependOn(streamProvider).last;
  });
  ```

  After:

  ```dart
  final streamProvider = StreamProvider<T>(...);
  final example = Provider((ref) {
    Future<T> last = ref.watch(streamProvider.last);
  });
  ```

* `Provider.readOwner(ProviderStateOwner)` is changed into `ProviderContainer.read(Provider)`

* `Provider.watchOwner(ProviderStateOwner, (value) {})` is changed into:

  ```dart
  ProviderContainer container;
  final provider = Provider((ref) => 0);

  final subscription = container.listen(
    provider,
    mayHaveChanged: (sub) {},
    didChange: (sub) {}.
  );

  subscription.close();
  ```

* `MyProvider.family.autoDispose` now correctly free both the arguments and the associated
  providers from memory when the provider is no longer listened to.

- Added `ScopedProvider`, a new kind of provider that can be overridden anywhere
  in the widget tree.
  Normal providers cannot read a `ScopedProvider`.

- Added `ProviderListener`, a widget which allows listening to a provider
  without rebuilding the widget-tree. This can be useful for showing modals
  and pushing routes.

## 0.5.1

- Fixed the documentation of `StateNotifierProvider` incorrectly showing the
  documentation of `StreamProvider`.
- Improve the documentation of `StateProvider`.

## 0.5.0

- Changed `ComputedFamily` into `Computed.family`
- Added [AsyncValue.guard](https://pub.dev/documentation/riverpod/latest/riverpod/AsyncValue/guard.html to simplify transforming a Future into an AsyncValue.
- Improved the documentation of the different providers

## 0.4.0

Changed the syntax of "AutoDispose*" and "*Family" to use a syntax similar to
named constructors instead.

Before:

```dart
final myProvider = AutoDisposeStateNotifierProviderFamily<MyStateNotifier, int>((ref, id) {
  return MyStateNotifier(id: id);
});
```

After:

```dart
final myProvider = StateNotifierProvider.autoDispose.family<MyStateNotifier, int>((ref, id) {
  return MyStateNotifier(id: id);
});
```

The behavior is the same. Only the syntax changed.

## 0.3.0

- Added `AsyncValue.whenData`, syntax sugar for `AsyncValue.when` to handle
  only the `data` case and do nothing for the error/loading cases.

- Fixed a bug that caused [Computed] to crash if it stopped being listened to
  then was listened to again.

## 0.2.1

- `Computed` and `Consumer` now correctly unsubscribe to a provider when their
  function stops using a provider.

## 0.2.0

- `ref.read` is renamed as `ref.dependOn`
- Deprecated `ref.dependOn(streamProvider).stream` and `ref.dependOn(futureProvider).future`
  in favor of a universal `ref.dependOn(provider).value`.
- added `ref.read(provider)`, syntax sugar for `ref.dependOn(provider).value`.

## 0.1.0

Initial release
