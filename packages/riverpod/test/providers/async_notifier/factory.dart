import 'dart:async';

import 'package:riverpod/src/async_notifier.dart';
import 'package:riverpod/src/internals.dart';

typedef AsyncNotifierProviderFactoryType
    = AsyncNotifierProviderBase<NotifierT, T>
        Function<NotifierT extends AsyncNotifierBase<T>, T>(
  NotifierT Function(), {
  Object? argument,
  List<ProviderOrFamily>? dependencies,
  Family? from,
  String? name,
});

typedef AsyncNotifierFactoryType = AsyncNotifierBase<T> Function<T>(
  FutureOr<T> Function(AsyncNotifierProviderRef<T>), {
  bool Function(T, T)? updateShouldNotify,
});

typedef TestProviderFactoryType
    = AsyncNotifierProviderBase<AsyncTestNotifier<T>, T> Function<T>(
  FutureOr<T> Function(AsyncNotifierProviderRef<T> ref) init, {
  bool Function(T prev, T next)? updateShouldNotify,
});

const matrix = <AsyncNotifierFactory>[
  AsyncNotifierFactory(
    label: 'AsyncNotifierProvider',
    provider: TestAsyncNotifierProvider.new,
    notifier: AsyncTestNotifier.new,
    testProvider: _AsyncTestNotifierProvider,
  ),
  AsyncNotifierFactory(
    label: 'AutoDisposeAsyncNotifierProvider',
    provider: TestAutoDisposeAsyncNotifierProvider.new,
    notifier: AutoDisposeAsyncTestNotifier.new,
    testProvider: _AutoDisposeAsyncTestNotifierProvider,
  ),
];

class AsyncNotifierFactory {
  const AsyncNotifierFactory({
    required this.label,
    required this.provider,
    required this.notifier,
    required this.testProvider,
  });

  final String label;
  final AsyncNotifierProviderFactoryType provider;
  final AsyncNotifierFactoryType notifier;
  final TestProviderFactoryType testProvider;
}

// ignore: non_constant_identifier_names
AsyncNotifierProvider<AsyncTestNotifier<T>, T> _AsyncTestNotifierProvider<T>(
  FutureOr<T> Function(AsyncNotifierProviderRef<T> ref) init, {
  bool Function(T prev, T next)? updateShouldNotify,
}) {
  return AsyncNotifierProvider<AsyncTestNotifier<T>, T>(
    () => AsyncTestNotifier(
      init,
      updateShouldNotify: updateShouldNotify,
    ),
  );
}

AutoDisposeAsyncNotifierProvider<AutoDisposeAsyncTestNotifier<T>, T>
// ignore: non_constant_identifier_names
    _AutoDisposeAsyncTestNotifierProvider<T>(
  FutureOr<T> Function(AutoDisposeAsyncNotifierProviderRef<T> ref) init, {
  bool Function(T prev, T next)? updateShouldNotify,
}) {
  return AutoDisposeAsyncNotifierProvider<AutoDisposeAsyncTestNotifier<T>, T>(
    () => AutoDisposeAsyncTestNotifier(
      init,
      updateShouldNotify: updateShouldNotify,
    ),
  );
}

class AsyncTestNotifier<T> extends AsyncNotifier<T> {
  AsyncTestNotifier(this._init,
      {bool Function(T prev, T next)? updateShouldNotify})
      : _updateShouldNotify = updateShouldNotify;

  final FutureOr<T> Function(AsyncNotifierProviderRef<T> ref) _init;

  final bool Function(T prev, T next)? _updateShouldNotify;

  // overriding to remove the @protected
  @override
  AsyncValue<T> get state => super.state;

  @override
  set state(AsyncValue<T> value) => super.state = value;

  @override
  FutureOr<T> build() => _init(ref);

  @override
  bool updateShouldNotify(T previous, T next) {
    return _updateShouldNotify?.call(previous, next) ??
        super.updateShouldNotify(previous, next);
  }

  @override
  String toString() {
    return 'TestNotifier<$T>#$hashCode';
  }
}

class AutoDisposeAsyncTestNotifier<T> extends AutoDisposeAsyncNotifier<T>
    implements AsyncTestNotifier<T> {
  AutoDisposeAsyncTestNotifier(
    this._init2, {
    bool Function(T prev, T next)? updateShouldNotify,
  }) : _updateShouldNotify = updateShouldNotify;

  final FutureOr<T> Function(AutoDisposeAsyncNotifierProviderRef<T> ref) _init2;

  @override
  final bool Function(T prev, T next)? _updateShouldNotify;

  // overriding to remove the @protected
  @override
  AsyncValue<T> get state => super.state;

  @override
  set state(AsyncValue<T> value) => super.state = value;

  @override
  FutureOr<T> build() => _init2(ref);

  @override
  bool updateShouldNotify(T previous, T next) {
    return _updateShouldNotify?.call(previous, next) ??
        super.updateShouldNotify(previous, next);
  }

  @override
  String toString() {
    return 'TestNotifier<$T>#$hashCode';
  }

  // Forced by the `implements AsyncTestNotifier<T>` but not used
  // TODO refactor to remove
  @override
  FutureOr<T> Function(AsyncNotifierProviderRef<T> ref) get _init =>
      throw UnimplementedError();
}
