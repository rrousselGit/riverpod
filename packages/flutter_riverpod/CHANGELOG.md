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

# 0.1

# 0.13.1+1

Fixed an issue where `context.read` and `ProviderListener` were unable to read providers that return a nullable value

# 0.13.1

- Fixed a bug where overriding a `FutureProvider` with an error value could cause tests to fail (see https://github.com/rrousselGit/river_pod/issues/355)

# 0.13.0

- stable null-safety release
- `ProviderObserver` can now have a const constructor
- Added the mechanism for state-inspection using the Flutter devtool
- loosened the version constraints of `freezed_annotation`
- deprecated `import 'flutter_riverpod/all.dart'`. Now everything is available with `flutter_riverpod/flutter_riverpod.dart`.
- Fixed a but where listening to `StreamProvider.last` could result in a `StateError` (#217)
- removed the assert preventing ConsumerWidget's "watch" from being used after the `build` method completed.
  This allows "watch" to be used inside `ListView.builder`.
- `context.read(myProvider)` now accepts `ScopeProviders`

# 0.13.0-nullsafety.3

- deprecated `import 'flutter_riverpod/all.dart'`. Now everything is available with `flutter_riverpod/flutter_riverpod.dart`.
- removed the assert preventing ConsumerWidget's "watch" from being used after the `build` method completed.
  This allows "watch" to be used inside `ListView.builder`.
- `context.read(myProvider)` now accepts `ScopeProviders`

# 0.13.0-nullsafety.2

- Fixed outdated doc

# 0.13.0-nullsafety.1

- Fixed a but where listening to `StreamProvider.last` could result in a `StateError` (#217)

# 0.13.0-nullsafety.0

Migrated to null-safety

# 0.12.2

- Exported `AutoDisposeProviderReference`

# 0.12.1

- Fixed an remaining memory leak related to StreamProvider (see also https://github.com/rrousselGit/river_pod/issues/193)

# 0.12.0

- **Breaking** FutureProvider and StreamProvider no-longer supports `null` as a valid value.
- Fixed a memory leak with StreamProvider (see also https://github.com/rrousselGit/river_pod/issues/193)
- Fixed an error message typo related to Consumer

# 0.11.2

- Fixed a bug where providers (usually ScopedProviders) did not dispose correctly
  (see also https://github.com/rrousselGit/river_pod/issues/154).

# 0.11.1

- Fixed a bug where hot-reload did not work for `ConsumerWidget`/`Consumer`

# 0.11.0

- `package:flutter_riverpod/flutter_riverpod.dart` now exports `StateNotifier`
- Marked the providers with `@sealed` so that the IDE warns against
  implementing/subclassing providers.
- Fix mistakes in `AsyncValue.guard`'s documentation (thanks @mono0926)
- Loosened the version constraints of `freezed_annotation` to support `0.12.0`

# 0.10.1

- Fixed invalid version error

# 0.10.0

- Fixed a bug where the state of a provider may be disposed when it shouldn't be disposed.

- Added a way to import the implementation class of providers with modifiers,
  such as `AutoDisposeProvider`.

  This is useful if you want to use Riverpod with the lint `always_specify_types`:

  ```dart
  import 'package:flutter_riverpod/all.dart';

  final AutoDisposeStateProvider<int> counter = StateProvider.autoDispose<int>((ProviderReference ref) {
    return 0;
  });
  ```

  If you do not use this lint, prefer using the default import instead, to not
  pollute your auto-complete.

# 0.9.0

- **Breaking** Updating `ProviderListener` so that `onChange` receives the
  `BuildContext` as parameter (thanks to @tbm98)

# 0.8.0

- Renamed `ProviderContainer.debugProviderStates` to `ProviderContainer.debugProviderElements`
- Fixed a bug where updating `ProviderScope.overrides` may cause an exception
  for no reason (see https://github.com/rrousselGit/river_pod/issues/107)

# 0.7.2

Fixed a bug that prevented the use of `ConsumerWidget` under normal circumstances

# 0.7.1

- Fixed a bug where in release mode, `ScopedProvider` did not update correctly (https://github.com/rrousselGit/river_pod/issues/101)

# 0.7.0

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
  Providers can only be overriden in the top-most `ProviderScope`/`ProviderContainer`.

- Providers can now read values which may change over time using `ref.read` and `ref.watch`.
  When using `ref.watch`, if the value obtained changes, this will cause the provider
  to re-create its state.

- It is no-longer possible to add `ProviderObserver` anywhere in the widget tree.
  They can be added only on the top-most `ProviderScope`/`ProviderContainer`.

- `Provider.read(BuildContext)` is changed into `context.read(provider)`, and
  can now read `Provider.autoDispose`.

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
