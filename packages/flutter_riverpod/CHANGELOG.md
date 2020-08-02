# 0.6.0-dev+1

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

- `Computed` and `Consumer` now correctly unsubscribe to a provider when their
  function stops using a provider.

# 0.2.0

- `ref.read` is renamed as `ref.dependOn`
- Deprecated `ref.dependOn(streamProvider).stream` and `ref.dependOn(futureProvider).future`
  in favor of a universal `ref.dependOn(provider).value`.
- added `ref.read(provider)`, syntax sugar for `ref.dependOn(provider).value`.

# 0.1.0

Initial release
