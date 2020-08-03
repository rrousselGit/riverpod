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
  Providers can only be overriden in the top-most `ProviderScope`/`ProviderContainer`.

- Providers can now read values which may change over time using `ref.read` and `ref.watch`.
  When using `ref.watch`, if the value obtained changes, this will cause the provider
  to re-create its state.

- It is no-longer possible to add `ProviderObserver` anywhere in the widget tree.
  They can be added only on the top-most `ProviderScope`/`ProviderContainer`.

- `Provider.read(BuildContext)` is changed into `context.read(provider)`, and
  can now read `Provider.autoDispose`.

- `ref.read` no-longer throws `CircularDependencyError` in most situations.

- Added `ProviderContainer.refresh(provider)` and `context.refresh(provider)`.
  These method allows forcing the refresh of a provider, which can be useful
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

- Added `ProviderListener`, a widget which allows listening to a provider
  without rebuilding the widget-tree. This can be useful for showing modals
  and pushing routes.

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

# 0.3.1

- Loosen the version constraint of `flutter_hooks` used to support latest versions.

# 0.3.0

- Added `AsyncValue.whenData`, syntax sugar for `AsyncValue.when` to handle
  only the `data` case and do nothing for the error/loading cases.

- Fixed a bug that caused [Computed] to crash if it stopped being listened
  then was listened again.

# 0.2.1

- `useProvider` no longer throws an `UnsupportedError` when the provider listened
  changes, and correctly listen to the new provider.

- `Computed` and `Consumer` now correctly unsubscribe to a provider when their
  function stops using a provider.

# 0.2.0

- `ref.read` is renamed as `ref.dependOn`
- Deprecated `ref.dependOn(streamProvider).stream` and `ref.dependOn(futureProvider).future`
  in favor of a universal `ref.dependOn(provider).value`.
- added `ref.read(provider)`, syntax sugar for `ref.dependOn(provider).value`.

# 0.1.0

Initial release
