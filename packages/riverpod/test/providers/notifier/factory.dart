import 'package:riverpod/src/internals.dart';

typedef NotifierProviderFactoryType = NotifierProviderBase<NotifierT, T>
    Function<NotifierT extends NotifierBase<T>, T>(
  NotifierT Function() create, {
  Object? argument,
  Iterable<ProviderOrFamily>? dependencies,
  Family<Object?>? from,
  String? name,
});

typedef NotifierFactoryType = TestNotifierBase<T> Function<T>(
  T Function(NotifierProviderRef<T>), {
  bool Function(T, T)? updateShouldNotify,
});

typedef SimpleTestProviderFactoryType
    = NotifierProviderBase<TestNotifierBase<T>, T> Function<T>(
  T Function(NotifierProviderRef<T> ref) init, {
  bool Function(T prev, T next)? updateShouldNotify,
});

typedef TestProviderFactoryType = NotifierProviderBase<TestNotifierBase<T>, T>
    Function<T>(
  TestNotifierBase<T> Function() createNotifier,
);

List<NotifierFactory> matrix({
  bool alwaysAlive = true,
  bool autoDispose = true,
}) {
  return <NotifierFactory>[
    if (alwaysAlive)
      NotifierFactory(
        label: 'NotifierProvider',
        isAutoDispose: false,
        provider: NotifierProviderImpl.new,
        notifier: TestNotifier.new,
        testProvider: <T>(createNotifier) {
          return NotifierProviderImpl<TestNotifierBase<T>, T>(
            createNotifier,
          );
        },
        simpleTestProvider: <T>(init, {updateShouldNotify}) {
          return NotifierProvider<TestNotifier<T>, T>(
            () => TestNotifier(
              init,
              updateShouldNotify: updateShouldNotify,
            ),
          );
        },
      ),
    if (alwaysAlive)
      NotifierFactory(
        label: 'NotifierProviderFamily',
        isAutoDispose: false,
        provider: <NotifierT extends NotifierBase<T>, T>(
          create, {
          argument,
          dependencies,
          from,
          name,
        }) {
          return FamilyNotifierProviderImpl<NotifierT, T, int>.internal(
            create,
            argument: 0,
            name: null,
            dependencies: null,
            allTransitiveDependencies: null,
            debugGetCreateSourceHash: null,
          );
        },
        notifier: TestNotifierFamily.new,
        testProvider: <T>(createNotifier) {
          return FamilyNotifierProviderImpl<TestNotifierFamily<T>, T,
              int>.internal(
            () => createNotifier() as TestNotifierFamily<T>,
            argument: 0,
            name: null,
            dependencies: null,
            allTransitiveDependencies: null,
            debugGetCreateSourceHash: null,
          );
        },
        simpleTestProvider: <T>(init, {updateShouldNotify}) {
          return FamilyNotifierProviderImpl<TestNotifierFamily<T>, T,
              int>.internal(
            () => TestNotifierFamily<T>(
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
      NotifierFactory(
        label: 'AutoDisposeNotifierProvider',
        isAutoDispose: true,
        provider: AutoDisposeNotifierProviderImpl.new,
        notifier: AutoDisposeTestNotifier.new,
        testProvider: <T>(createNotifier) {
          return AutoDisposeNotifierProviderImpl<AutoDisposeTestNotifier<T>, T>(
            () => createNotifier() as AutoDisposeTestNotifier<T>,
          );
        },
        simpleTestProvider: <T>(init, {updateShouldNotify}) {
          return AutoDisposeNotifierProvider<AutoDisposeTestNotifier<T>, T>(
            () => AutoDisposeTestNotifier(
              init,
              updateShouldNotify: updateShouldNotify,
            ),
          );
        },
      ),
    if (autoDispose)
      NotifierFactory(
        label: 'AutoDisposeNotifierProviderFamily',
        isAutoDispose: true,
        provider: <NotifierT extends NotifierBase<T>, T>(
          create, {
          argument,
          dependencies,
          from,
          name,
        }) {
          return AutoDisposeFamilyNotifierProviderImpl<NotifierT, T,
              int>.internal(
            create,
            argument: 0,
            name: null,
            dependencies: null,
            allTransitiveDependencies: null,
            debugGetCreateSourceHash: null,
          );
        },
        notifier: AutoDisposeTestNotifierFamily.new,
        testProvider: <T>(createNotifier) {
          return AutoDisposeFamilyNotifierProviderImpl<
              AutoDisposeTestNotifierFamily<T>, T, int>.internal(
            () => createNotifier() as AutoDisposeTestNotifierFamily<T>,
            argument: 0,
            name: null,
            dependencies: null,
            allTransitiveDependencies: null,
            debugGetCreateSourceHash: null,
          );
        },
        simpleTestProvider: <T>(init, {updateShouldNotify}) {
          return AutoDisposeFamilyNotifierProviderImpl<
              AutoDisposeTestNotifierFamily<T>, T, int>.internal(
            () => AutoDisposeTestNotifierFamily<T>(
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

class NotifierFactory {
  const NotifierFactory({
    required this.label,
    required this.provider,
    required this.notifier,
    required this.isAutoDispose,
    required this.testProvider,
    required this.simpleTestProvider,
  });

  final String label;
  final bool isAutoDispose;
  final NotifierProviderFactoryType provider;
  final NotifierFactoryType notifier;
  final TestProviderFactoryType testProvider;
  final SimpleTestProviderFactoryType simpleTestProvider;
}

abstract class TestNotifierBase<T> extends NotifierBase<T> {}

class TestNotifier<T> extends Notifier<T> implements TestNotifierBase<T> {
  TestNotifier(this._init, {bool Function(T prev, T next)? updateShouldNotify})
      : _updateShouldNotify = updateShouldNotify;

  final T Function(NotifierProviderRef<T> ref) _init;

  final bool Function(T prev, T next)? _updateShouldNotify;

  @override
  T build() => _init(ref);

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

class TestNotifierFamily<T> extends FamilyNotifier<T, int>
    implements TestNotifierBase<T> {
  TestNotifierFamily(
    this._init, {
    bool Function(T prev, T next)? updateShouldNotify,
  }) : _updateShouldNotify = updateShouldNotify;

  final T Function(NotifierProviderRef<T> ref) _init;

  final bool Function(T prev, T next)? _updateShouldNotify;

  @override
  T build(int arg) => _init(ref);

  @override
  bool updateShouldNotify(T previous, T next) {
    return _updateShouldNotify?.call(previous, next) ??
        super.updateShouldNotify(previous, next);
  }

  @override
  String toString() {
    return 'TestNotifierFamily<$T>#$hashCode';
  }
}

class AutoDisposeTestNotifier<T> extends AutoDisposeNotifier<T>
    implements TestNotifierBase<T> {
  AutoDisposeTestNotifier(
    this._init2, {
    bool Function(T prev, T next)? updateShouldNotify,
  }) : _updateShouldNotify = updateShouldNotify;

  final T Function(AutoDisposeNotifierProviderRef<T> ref) _init2;

  final bool Function(T prev, T next)? _updateShouldNotify;

  @override
  T build() => _init2(ref);

  @override
  bool updateShouldNotify(T previous, T next) {
    return _updateShouldNotify?.call(previous, next) ??
        super.updateShouldNotify(previous, next);
  }

  @override
  String toString() {
    return 'AutoDisposeTestNotifier<$T>#$hashCode';
  }
}

class AutoDisposeTestNotifierFamily<T> extends AutoDisposeFamilyNotifier<T, int>
    implements TestNotifierBase<T> {
  AutoDisposeTestNotifierFamily(
    this._init2, {
    bool Function(T prev, T next)? updateShouldNotify,
  }) : _updateShouldNotify = updateShouldNotify;

  final T Function(AutoDisposeNotifierProviderRef<T> ref) _init2;

  final bool Function(T prev, T next)? _updateShouldNotify;

  @override
  T build(int arg) => _init2(ref);

  @override
  bool updateShouldNotify(T previous, T next) {
    return _updateShouldNotify?.call(previous, next) ??
        super.updateShouldNotify(previous, next);
  }

  @override
  String toString() {
    return 'AutoDisposeTestNotifierFamily<$T, int>#$hashCode';
  }
}
