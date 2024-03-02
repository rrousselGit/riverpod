import 'dart:async';

import 'package:riverpod/src/internals.dart';

typedef StreamNotifierProviderFactoryType
    = StreamNotifierProviderBase<NotifierT, T>
        Function<NotifierT extends AsyncNotifierBase<T>, T>(
  NotifierT Function() create, {
  String? name,
});

typedef StreamNotifierFactoryType = StreamTestNotifierBase<T> Function<T>(
  Stream<T> Function(StreamNotifierProviderRef<T>), {
  bool Function(AsyncValue<T>, AsyncValue<T>)? updateShouldNotify,
});

typedef SimpleTestProviderFactoryType
    = StreamNotifierProviderBase<StreamTestNotifierBase<T>, T> Function<T>(
  Stream<T> Function(StreamNotifierProviderRef<T> ref) init, {
  bool Function(AsyncValue<T> prev, AsyncValue<T> next)? updateShouldNotify,
});

typedef TestProviderFactoryType
    = StreamNotifierProviderBase<StreamTestNotifierBase<T>, T> Function<T>(
  StreamTestNotifierBase<T> Function() createNotifier,
);

List<StreamNotifierFactory> matrix({
  bool alwaysAlive = true,
  bool autoDispose = true,
}) {
  return <StreamNotifierFactory>[
    if (alwaysAlive)
      StreamNotifierFactory(
        label: 'StreamNotifierProvider',
        isAutoDispose: false,
        provider: StreamNotifierProviderImpl.new,
        notifier: StreamTestNotifier.new,
        testProvider: <T>(createNotifier) {
          return StreamNotifierProviderImpl<StreamTestNotifierBase<T>, T>(
            createNotifier,
          );
        },
        simpleTestProvider: <T>(init, {updateShouldNotify}) {
          return StreamNotifierProvider<StreamTestNotifier<T>, T>(
            () => StreamTestNotifier(
              init,
              updateShouldNotify: updateShouldNotify,
            ),
          );
        },
      ),
    if (alwaysAlive)
      StreamNotifierFactory(
        label: 'StreamNotifierProviderFamily',
        isAutoDispose: false,
        provider: <NotifierT extends AsyncNotifierBase<T>, T>(
          create, {
          argument,
          dependencies,
          from,
          name,
        }) {
          return FamilyStreamNotifierProviderImpl<NotifierT, T, int>.internal(
            create,
            argument: 0,
            name: null,
            dependencies: null,
            allTransitiveDependencies: null,
            debugGetCreateSourceHash: null,
          );
        },
        notifier: StreamTestNotifierFamily.new,
        testProvider: <T>(createNotifier) {
          return FamilyStreamNotifierProviderImpl<StreamTestNotifierFamily<T>,
              T, int>.internal(
            () => createNotifier() as StreamTestNotifierFamily<T>,
            argument: 0,
            name: null,
            dependencies: null,
            allTransitiveDependencies: null,
            debugGetCreateSourceHash: null,
          );
        },
        simpleTestProvider: <T>(init, {updateShouldNotify}) {
          return FamilyStreamNotifierProviderImpl<StreamTestNotifierFamily<T>,
              T, int>.internal(
            () => StreamTestNotifierFamily<T>(
              init,
              updateShouldNotify: updateShouldNotify,
            ),
            argument: 0,
            name: null,
            dependencies: null,
            allTransitiveDependencies: null,
            debugGetCreateSourceHash: null,
          );
        },
      ),
    if (autoDispose)
      StreamNotifierFactory(
        label: 'AutoDisposeStreamNotifierProvider',
        isAutoDispose: true,
        provider: AutoDisposeStreamNotifierProviderImpl.new,
        notifier: AutoDisposeStreamTestNotifier.new,
        testProvider: <T>(createNotifier) {
          return AutoDisposeStreamNotifierProviderImpl<
              AutoDisposeStreamTestNotifier<T>, T>(
            () => createNotifier() as AutoDisposeStreamTestNotifier<T>,
          );
        },
        simpleTestProvider: <T>(init, {updateShouldNotify}) {
          return AutoDisposeStreamNotifierProvider<
              AutoDisposeStreamTestNotifier<T>, T>(
            () => AutoDisposeStreamTestNotifier(
              init,
              updateShouldNotify: updateShouldNotify,
            ),
          );
        },
      ),
    if (autoDispose)
      StreamNotifierFactory(
        label: 'AutoDisposeStreamNotifierProviderFamily',
        isAutoDispose: true,
        provider: <NotifierT extends AsyncNotifierBase<T>, T>(
          create, {
          argument,
          dependencies,
          from,
          name,
        }) {
          return AutoDisposeFamilyStreamNotifierProviderImpl<NotifierT, T,
              int>.internal(
            create,
            argument: 0,
            name: null,
            dependencies: null,
            allTransitiveDependencies: null,
            debugGetCreateSourceHash: null,
          );
        },
        notifier: AutoDisposeStreamTestNotifierFamily.new,
        testProvider: <T>(createNotifier) {
          return AutoDisposeFamilyStreamNotifierProviderImpl<
              AutoDisposeStreamTestNotifierFamily<T>, T, int>.internal(
            () => createNotifier() as AutoDisposeStreamTestNotifierFamily<T>,
            argument: 0,
            name: null,
            dependencies: null,
            allTransitiveDependencies: null,
            debugGetCreateSourceHash: null,
          );
        },
        simpleTestProvider: <T>(init, {updateShouldNotify}) {
          return AutoDisposeFamilyStreamNotifierProviderImpl<
              AutoDisposeStreamTestNotifierFamily<T>, T, int>.internal(
            () => AutoDisposeStreamTestNotifierFamily<T>(
              init,
              updateShouldNotify: updateShouldNotify,
            ),
            argument: 0,
            name: null,
            dependencies: null,
            allTransitiveDependencies: null,
            debugGetCreateSourceHash: null,
          );
        },
      ),
  ];
}

class StreamNotifierFactory {
  const StreamNotifierFactory({
    required this.label,
    required this.provider,
    required this.notifier,
    required this.isAutoDispose,
    required this.testProvider,
    required this.simpleTestProvider,
  });

  final String label;
  final bool isAutoDispose;
  final StreamNotifierProviderFactoryType provider;
  final StreamNotifierFactoryType notifier;
  final TestProviderFactoryType testProvider;
  final SimpleTestProviderFactoryType simpleTestProvider;
}

abstract class StreamTestNotifierBase<T> extends AsyncNotifierBase<T> {
  // overriding to remove the @protected
  @override
  AsyncValue<T> get state;

  @override
  set state(AsyncValue<T> value);

  // overriding to remove the @protected
  @override
  Future<T> update(
    FutureOr<T> Function(T p1) cb, {
    FutureOr<T> Function(Object err, StackTrace stackTrace)? onError,
  });
}

class StreamTestNotifier<T> extends StreamNotifier<T>
    implements StreamTestNotifierBase<T> {
  StreamTestNotifier(
    this._init, {
    bool Function(AsyncValue<T> prev, AsyncValue<T> next)? updateShouldNotify,
  }) : _updateShouldNotify = updateShouldNotify;

  final Stream<T> Function(StreamNotifierProviderRef<T> ref) _init;

  final bool Function(AsyncValue<T> prev, AsyncValue<T> next)?
      _updateShouldNotify;

  @override
  Stream<T> build() => _init(ref);

  @override
  bool updateShouldNotify(AsyncValue<T> prev, AsyncValue<T> next) {
    return _updateShouldNotify?.call(prev, next) ??
        super.updateShouldNotify(prev, next);
  }

  @override
  String toString() {
    return 'StreamTestNotifier<$T>#$hashCode';
  }
}

class StreamTestNotifierFamily<T> extends FamilyStreamNotifier<T, int>
    implements StreamTestNotifierBase<T> {
  StreamTestNotifierFamily(
    this._init, {
    bool Function(AsyncValue<T> prev, AsyncValue<T> next)? updateShouldNotify,
  }) : _updateShouldNotify = updateShouldNotify;

  final Stream<T> Function(StreamNotifierProviderRef<T> ref) _init;

  final bool Function(AsyncValue<T> prev, AsyncValue<T> next)?
      _updateShouldNotify;

  @override
  Stream<T> build(int arg) => _init(ref);

  @override
  bool updateShouldNotify(AsyncValue<T> prev, AsyncValue<T> next) {
    return _updateShouldNotify?.call(prev, next) ??
        super.updateShouldNotify(prev, next);
  }

  @override
  String toString() {
    return 'StreamTestNotifierFamily<$T>#$hashCode';
  }
}

class AutoDisposeStreamTestNotifier<T> extends AutoDisposeStreamNotifier<T>
    implements StreamTestNotifierBase<T> {
  AutoDisposeStreamTestNotifier(
    this._init2, {
    bool Function(AsyncValue<T> prev, AsyncValue<T> next)? updateShouldNotify,
  }) : _updateShouldNotify = updateShouldNotify;

  final Stream<T> Function(AutoDisposeStreamNotifierProviderRef<T> ref) _init2;

  final bool Function(AsyncValue<T> prev, AsyncValue<T> next)?
      _updateShouldNotify;

  @override
  Stream<T> build() => _init2(ref);

  @override
  bool updateShouldNotify(AsyncValue<T> prev, AsyncValue<T> next) {
    return _updateShouldNotify?.call(prev, next) ??
        super.updateShouldNotify(prev, next);
  }

  @override
  String toString() {
    return 'AutoDisposeStreamTestNotifier<$T>#$hashCode';
  }
}

class AutoDisposeStreamTestNotifierFamily<T>
    extends AutoDisposeFamilyStreamNotifier<T, int>
    implements StreamTestNotifierBase<T> {
  AutoDisposeStreamTestNotifierFamily(
    this._init2, {
    bool Function(AsyncValue<T> prev, AsyncValue<T> next)? updateShouldNotify,
  }) : _updateShouldNotify = updateShouldNotify;

  final Stream<T> Function(AutoDisposeStreamNotifierProviderRef<T> ref) _init2;

  final bool Function(AsyncValue<T> prev, AsyncValue<T> next)?
      _updateShouldNotify;

  @override
  Stream<T> build(int arg) => _init2(ref);

  @override
  bool updateShouldNotify(AsyncValue<T> prev, AsyncValue<T> next) {
    return _updateShouldNotify?.call(prev, next) ??
        super.updateShouldNotify(prev, next);
  }

  @override
  String toString() {
    return 'AutoDisposeStreamTestNotifierFamily<$T, int>#$hashCode';
  }
}
