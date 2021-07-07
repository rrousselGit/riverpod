# 1.0.0-dev.5

Fixed an issue where provider listeners could not be called properly.

# 1.0.0-dev.3

Fixed various issues related to scoped providers.

# 1.0.0-dev.2

- All providers can now be scoped.
- **breaking**: `ScopedProvider` is removed. To migrate, change `ScopedProvider`s to `Provider`s.

# 1.0.0-dev.1

- Add missing exports (see #532)

# 1.0.0-dev.0

- `ref.watch` now support `myProvider.select((value) => ...)`.
  This allows filtering rebuilds:

  ```dart
  final userProvider = StateNotifierProvider<UserController, User>(...);

  final anotherProvider = Provider((ref) {
    // With this syntax, the Consumer will not rebuild if `userProvider`
    // emits a new User but its "name" didn't change.
    bool userName = ref.watch(userProvider.select((user) => user.name));
  });
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
- All providers now receive a custom subclass of `ProviderRefBase` as parameter:

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
- `ref.onDispose` now calls the dispose function as soon as one of the provider's
  dependency is known to have changed
- Providers can now call `ref.refresh` to refresh a provider, instead of having
  to do `ref.container.refresh`.
- Providers no longer wait until their next read to recompute their state if one
  of their dependency changed and they have listeners.
- Added `ProviderContainer.pump`, an utility to easily "await" until providers
  notify their listeners or are disposed.
- fixed an issue when using both `family` and `autoDispose` that could lead to an inconsistent state

# 0.14.0+3

Removed an assert that could cause issues when an application is partially migrated to null safety.

# 0.14.0+1

- Re-added `StateProvider.overrideWithValue`/`StateProvider.overrideWithProvider` that were unvoluntarily removed.

# 0.14.0

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

  See also https://github.com/rrousselGit/river_pod/issues/341 for more information.

- **BREAKING CHANGE** It is no-longer possible to override `StreamProvider.stream/last` and `FutureProvider.future`.
- feat: Calling `ProviderContainer.dispose` multiple time no-longer throws.
  This simplifies the tear-off logic of tests.
- feat: Added `ChangeNotifierProvider.notifier` and `StateProvider.notifier`
  They allow obtaining the notifier associated to the provider, without causing widgets/providers to rebuild when the state updates.
- fix: overriding a `StateNotifierProvider`/`ChangeNotifierProvider` with `overrideWithValue` now correctly listens to the notifier.

# 0.13.1

- Fixed a bug where overriding a `FutureProvider` with an error value could cause tests to fail (see https://github.com/rrousselGit/river_pod/issues/355)

# 0.13.0

- stable null-safety release
- `ProviderObserver` can now have a const constructor
- Added the mechanism for state-inspection using the Flutter devtool
- loosened the version constraints of `freezed_annotation`
- deprecated `import 'riverpod/all.dart'`. Now everything is available with `riverpod/riverpod.dart`.
- Fixed a but where listening to `StreamProvider.last` could result in a `StateError` (#217)

# 0.13.0-nullsafety.3

- deprecated `import 'riverpod/all.dart'`. Now everything is available with `riverpod/riverpod.dart`.

# 0.13.0-nullsafety.1

- Fixed a but where listening to `StreamProvider.last` could result in a `StateError` (#217)

# 0.13.0-nullsafety.0

Migrated to null-safety

# 0.12.2

- Exported `AutoDisposeProviderRefBase`

# 0.12.1

- Fixed an remaining memory leak related to StreamProvider (see also https://github.com/rrousselGit/river_pod/issues/193)

# 0.12.0

- **Breaking** FutureProvider and StreamProvider no-longer supports `null` as a valid value.
- Fixed a memory leak with StreamProvider (see also https://github.com/rrousselGit/river_pod/issues/193)

# 0.11.2

- Fixed a bug where providers (usually ScopedProviders) did not dispose correctly
  (see also https://github.com/rrousselGit/river_pod/issues/154).

# 0.11.0

- `package:riverpod/riverpod.dart` now exports `StateNotifier`
- Marked the providers with `@sealed` so that the IDE warns against
  implementing/subclassing providers.
- Fix mistakes in `AsyncValue.guard`'s documentation (thanks @mono0926)
- Loosened the version constraints of `freezed_annotation` to support `0.12.0`

# 0.10.0

- Fixed a bug where the state of a provider may be disposed when it shouldn't be disposed.

- Added a way to import the implementation class of providers with modifiers,
  such as `AutoDisposeProvider`.

  This is useful if you want to use Riverpod with the lint `always_specify_types`:

  ```dart
  import 'package:riverpod/all.dart';

  final AutoDisposeStateProvider<int> counter = StateProvider.autoDispose<int>((ProviderRefBase ref) {
    return 0;
  });
  ```

  If you do not use this lint, prefer using the default import instead, to not
  pollute your auto-complete.

# 0.8.0

- Renamed `ProviderContainer.debugProviderStates` to `ProviderContainer.debugProviderElements`
- Fixed a bug where updating `ProviderScope.overrides` may cause an exception
  for no reason (see https://github.com/rrousselGit/river_pod/issues/107)

# 0.7.0

- `ref.watch` on non ".autoDispose" providers can no-longer read ".autoDispose"
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

# 0.6.1

- Fixed a bug where when disposing `ProviderContainer`, providers may be disposed
  in an incorrect order.
- Improved the performances of reading providers by 25%

# 0.6.0

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

- `Computed` (now `Provider`) no-longer deeply compare collections to avoid rebuilds.
  Comparing the content of lists is quite expensive and actually rarely useful.
  Now, a simple `==` comparison is used.

- Renamed `ProviderStateOwner` to `ProviderContainer`
- Renamed `ProviderStateOwnerObserver` to `ProviderObserver`

- It is no-longer possible to override a provider anywhere in the widget tree.
  Providers can only be overriden in the top-most `ProviderContainer`.

- Providers can now read values which may change over time using `ref.read` and `ref.watch`.
  When using `ref.watch`, if the value obtained changes, this will cause the provider
  to re-create its state.

- It is no-longer possible to add `ProviderObserver` anywhere in the widget tree.
  They can be added only on the top-most `ProviderContainer`.

- Added `ProviderContainer.refresh(provider)`.
  This method allows forcing the refresh of a provider, which can be useful
  for things like "retry on error" or "pull to refresh".

* `ref.read(StreamProvider<T>)` no-longer returns a `Stream<T>` but an `AsyncValue<T>`
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

* `ref.read(FutureProvider<T>)` no-longer returns a `Future<T>` but an `AsyncValue<T>`

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
  You can now use `ref.read`/`ref.watch` to acheive the same effect.

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
  providers from memory when the provider is no-longer listened.

- Added `ScopedProvider`, a new kind of provider that can be overriden anywhere
  in the widget tree.
  Normal providers cannot read a `ScopedProvider`.

# 0.5.1

- Fixed the documentation of `StateNotifierProvider` incorrectly showing the
  documentation of `StreamProvider`.
- Improve the documentation of `StateProvider`.

# 0.5.0

- Changed `ComputedFamily` into `Computed.family`
- Added [AsyncValue.guard](https://pub.dev/documentation/riverpod/latest/riverpod/AsyncValue/guard.html to simplify transforming a Future into an AsyncValue.
- Improved the documentation of the different providers

# 0.4.0

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

# 0.3.0

- Added `AsyncValue.whenData`, syntax sugar for `AsyncValue.when` to handle
  only the `data` case and do nothing for the error/loading cases.

- Fixed a bug that caused [Computed] to crash if it stopped being listened
  then was listened again.

# 0.2.1

- `Computed` now correctly unsubscribe to a provider when their
  function stops using a provider.

# 0.2.0

- `ref.read` is renamed as `ref.dependOn`
- Deprecated `ref.dependOn(streamProvider).stream` and `ref.dependOn(futureProvider).future`
  in favor of a universal `ref.dependOn(provider).value`.
- added `ref.read(provider)`, syntax sugar for `ref.dependOn(provider).value`.

# 0.1.0

Initial release
