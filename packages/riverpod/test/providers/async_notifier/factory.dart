import 'dart:async';

import 'package:riverpod/src/internals.dart';

typedef AsyncNotifierProviderFactoryType
    = AsyncNotifierProviderBase<NotifierT, T>
        Function<NotifierT extends AsyncNotifierBase<T>, T>(
  NotifierT Function() create, {
  Object? argument,
  List<ProviderOrFamily>? dependencies,
  Family? from,
  String? name,
});

typedef AsyncNotifierFactoryType = AsyncTestNotifierBase<T> Function<T>(
  FutureOr<T> Function(AsyncNotifierProviderRef<T>), {
  bool Function(AsyncValue<T>, AsyncValue<T>)? updateShouldNotify,
});

typedef SimpleTestProviderFactoryType
    = AsyncNotifierProviderBase<AsyncTestNotifierBase<T>, T> Function<T>(
  FutureOr<T> Function(AsyncNotifierProviderRef<T> ref) init, {
  bool Function(AsyncValue<T> prev, AsyncValue<T> next)? updateShouldNotify,
});

typedef TestProviderFactoryType
    = AsyncNotifierProviderBase<AsyncTestNotifierBase<T>, T> Function<T>(
  AsyncTestNotifierBase<T> Function() createNotifier,
);

List<AsyncNotifierFactory> matrix({
  bool alwaysAlive = true,
  bool autoDispose = true,
}) {
  return <AsyncNotifierFactory>[
    if (alwaysAlive)
      AsyncNotifierFactory(
        label: 'AsyncNotifierProvider',
        isAutoDispose: false,
        provider: TestAsyncNotifierProvider.new,
        notifier: AsyncTestNotifier.new,
        testProvider: <T>(createNotifier) {
          return TestAsyncNotifierProvider<AsyncTestNotifierBase<T>, T>(
            createNotifier,
          );
        },
        simpleTestProvider: <T>(init, {updateShouldNotify}) {
          return AsyncNotifierProvider<AsyncTestNotifier<T>, T>(
            () => AsyncTestNotifier(
              init,
              updateShouldNotify: updateShouldNotify,
            ),
          );
        },
      ),
    if (alwaysAlive)
      AsyncNotifierFactory(
        label: 'AsyncNotifierProviderFamily',
        isAutoDispose: false,
        provider: <NotifierT extends AsyncNotifierBase<T>, T>(create,
            {argument, dependencies, from, name}) {
          return TestFamilyAsyncNotifierProvider<NotifierT, T, int>(
            create,
            argument: 0,
          );
        },
        notifier: AsyncTestNotifierFamily.new,
        testProvider: <T>(createNotifier) {
          return TestFamilyAsyncNotifierProvider<AsyncTestNotifierFamily<T>, T,
              int>(
            () => createNotifier() as AsyncTestNotifierFamily<T>,
            argument: 0,
          );
        },
        simpleTestProvider: <T>(init, {updateShouldNotify}) {
          return TestFamilyAsyncNotifierProvider<AsyncTestNotifierFamily<T>, T,
              int>(
            () => AsyncTestNotifierFamily<T>(
              init,
              updateShouldNotify: updateShouldNotify,
            ),
            argument: 0,
          );
        },
      ),
    if (autoDispose)
      AsyncNotifierFactory(
        label: 'AutoDisposeAsyncNotifierProvider',
        isAutoDispose: true,
        provider: TestAutoDisposeAsyncNotifierProvider.new,
        notifier: AutoDisposeAsyncTestNotifier.new,
        testProvider: <T>(createNotifier) {
          return TestAutoDisposeAsyncNotifierProvider<
              AutoDisposeAsyncTestNotifier<T>, T>(
            () => createNotifier() as AutoDisposeAsyncTestNotifier<T>,
          );
        },
        simpleTestProvider: <T>(init, {updateShouldNotify}) {
          return AutoDisposeAsyncNotifierProvider<
              AutoDisposeAsyncTestNotifier<T>, T>(
            () => AutoDisposeAsyncTestNotifier(
              init,
              updateShouldNotify: updateShouldNotify,
            ),
          );
        },
      ),
    if (autoDispose)
      AsyncNotifierFactory(
        label: 'AutoDisposeAsyncNotifierProviderFamily',
        isAutoDispose: true,
        provider: <NotifierT extends AsyncNotifierBase<T>, T>(create,
            {argument, dependencies, from, name}) {
          return TestAutoDisposeFamilyAsyncNotifierProvider<NotifierT, T, int>(
            create,
            argument: 0,
          );
        },
        notifier: AutoDisposeAsyncTestNotifierFamily.new,
        testProvider: <T>(createNotifier) {
          return TestAutoDisposeFamilyAsyncNotifierProvider<
              AutoDisposeAsyncTestNotifierFamily<T>, T, int>(
            () => createNotifier() as AutoDisposeAsyncTestNotifierFamily<T>,
            argument: 0,
          );
        },
        simpleTestProvider: <T>(init, {updateShouldNotify}) {
          return TestAutoDisposeFamilyAsyncNotifierProvider<
              AutoDisposeAsyncTestNotifierFamily<T>, T, int>(
            () => AutoDisposeAsyncTestNotifierFamily<T>(
              init,
              updateShouldNotify: updateShouldNotify,
            ),
            argument: 0,
          );
        },
      ),
  ];
}

class AsyncNotifierFactory {
  const AsyncNotifierFactory({
    required this.label,
    required this.provider,
    required this.notifier,
    required this.isAutoDispose,
    required this.testProvider,
    required this.simpleTestProvider,
  });

  final String label;
  final bool isAutoDispose;
  final AsyncNotifierProviderFactoryType provider;
  final AsyncNotifierFactoryType notifier;
  final TestProviderFactoryType testProvider;
  final SimpleTestProviderFactoryType simpleTestProvider;
}

abstract class AsyncTestNotifierBase<T> extends AsyncNotifierBase<T> {
  // overriding to remove the @protected
  @override
  AsyncValue<T> get state => super.state;

  @override
  set state(AsyncValue<T> value) => super.state = value;
}

class AsyncTestNotifier<T> extends AsyncNotifier<T>
    implements AsyncTestNotifierBase<T> {
  AsyncTestNotifier(this._init,
      {bool Function(AsyncValue<T> prev, AsyncValue<T> next)?
          updateShouldNotify})
      : _updateShouldNotify = updateShouldNotify;

  final FutureOr<T> Function(AsyncNotifierProviderRef<T> ref) _init;

  final bool Function(AsyncValue<T> prev, AsyncValue<T> next)?
      _updateShouldNotify;

  @override
  FutureOr<T> build() => _init(ref);

  @override
  bool updateShouldNotify(AsyncValue<T> prev, AsyncValue<T> next) {
    return _updateShouldNotify?.call(prev, next) ??
        super.updateShouldNotify(prev, next);
  }

  @override
  String toString() {
    return 'AsyncTestNotifier<$T>#$hashCode';
  }
}

class AsyncTestNotifierFamily<T> extends FamilyAsyncNotifier<T, int>
    implements AsyncTestNotifierBase<T> {
  AsyncTestNotifierFamily(
    this._init, {
    bool Function(AsyncValue<T> prev, AsyncValue<T> next)? updateShouldNotify,
  }) : _updateShouldNotify = updateShouldNotify;

  final FutureOr<T> Function(AsyncNotifierProviderRef<T> ref) _init;

  final bool Function(AsyncValue<T> prev, AsyncValue<T> next)?
      _updateShouldNotify;

  @override
  FutureOr<T> build(int arg) => _init(ref);

  @override
  bool updateShouldNotify(AsyncValue<T> prev, AsyncValue<T> next) {
    return _updateShouldNotify?.call(prev, next) ??
        super.updateShouldNotify(prev, next);
  }

  @override
  String toString() {
    return 'AsyncTestNotifierFamily<$T>#$hashCode';
  }
}

class AutoDisposeAsyncTestNotifier<T> extends AutoDisposeAsyncNotifier<T>
    implements AsyncTestNotifierBase<T> {
  AutoDisposeAsyncTestNotifier(
    this._init2, {
    bool Function(AsyncValue<T> prev, AsyncValue<T> next)? updateShouldNotify,
  }) : _updateShouldNotify = updateShouldNotify;

  final FutureOr<T> Function(AutoDisposeAsyncNotifierProviderRef<T> ref) _init2;

  final bool Function(AsyncValue<T> prev, AsyncValue<T> next)?
      _updateShouldNotify;

  @override
  FutureOr<T> build() => _init2(ref);

  @override
  bool updateShouldNotify(AsyncValue<T> prev, AsyncValue<T> next) {
    return _updateShouldNotify?.call(prev, next) ??
        super.updateShouldNotify(prev, next);
  }

  @override
  String toString() {
    return 'AutoDisposeAsyncTestNotifier<$T>#$hashCode';
  }
}

class AutoDisposeAsyncTestNotifierFamily<T>
    extends AutoDisposeFamilyAsyncNotifier<T, int>
    implements AsyncTestNotifierBase<T> {
  AutoDisposeAsyncTestNotifierFamily(
    this._init2, {
    bool Function(AsyncValue<T> prev, AsyncValue<T> next)? updateShouldNotify,
  }) : _updateShouldNotify = updateShouldNotify;

  final FutureOr<T> Function(AutoDisposeAsyncNotifierProviderRef<T> ref) _init2;

  final bool Function(AsyncValue<T> prev, AsyncValue<T> next)?
      _updateShouldNotify;

  @override
  FutureOr<T> build(int arg) => _init2(ref);

  @override
  bool updateShouldNotify(AsyncValue<T> prev, AsyncValue<T> next) {
    return _updateShouldNotify?.call(prev, next) ??
        super.updateShouldNotify(prev, next);
  }

  @override
  String toString() {
    return 'AutoDisposeAsyncTestNotifierFamily<$T, int>#$hashCode';
  }
}
