import 'dart:async';

import 'package:riverpod/src/internals.dart';
import 'package:test/test.dart';

class TestMatrix<T extends TestFactory<Object?>> {
  TestMatrix(this.values);

  final Map<String, T> values;

  void createGroup(void Function(T factory) cb) {
    for (final entry in values.entries) {
      group(entry.key, () => cb(entry.value));
    }
  }
}

class TestFactory<T> {
  TestFactory({required this.value});

  final T value;
}

typedef ProviderFactory<BaseT, ProviderT, RefT>
    = ProviderT Function([Object? arg]) Function(
  BaseT Function(RefT ref, Object? arg) create, {
  String? name,
  Iterable<ProviderOrFamily>? dependencies,
});

extension $Modifiers on ProviderBase<Object?> {
  Refreshable<Object?>? get notifier {
    final that = this;
    return switch (that) {
      ClassProvider() => that.notifier,
      _ => null,
    };
  }

  Refreshable<Future<Object?>>? get future {
    final that = this;
    return switch (that) {
      FutureModifier() => that.future,
      _ => null,
    };
  }
}

final providerFactory =
    <ProviderFactory<Object?, Provider<Object?>, Ref<Object?>>>[
  (create, {name, dependencies}) => ([arg]) {
        return Provider<Object?>(
          (ref) => create(ref, arg),
          name: name,
          dependencies: dependencies,
        );
      },
  (create, {name, dependencies}) => ([arg]) {
        return Provider.autoDispose<Object?>(
          (ref) => create(ref, arg),
          name: name,
          dependencies: dependencies,
        );
      },
  (create, {name, dependencies}) => ([arg]) {
        return Provider.family<Object?, Object?>(
          (ref, arg) => create(ref, arg),
          name: name,
          dependencies: dependencies,
        )(arg);
      },
  (create, {name, dependencies}) => ([arg]) {
        return Provider.autoDispose.family<Object?, Object?>(
          (ref, arg) => create(ref, arg),
          name: name,
          dependencies: dependencies,
        )(arg);
      },
];

final futureProviderFactories =
    <ProviderFactory<FutureOr<Object?>, FutureProvider<Object?>, Ref<Object?>>>[
  (create, {name, dependencies}) => ([arg]) {
        return FutureProvider<Object?>(
          (ref) => create(ref, arg),
          name: name,
          dependencies: dependencies,
        );
      },
  (create, {name, dependencies}) => ([arg]) {
        return FutureProvider.autoDispose<Object?>(
          (ref) => create(ref, arg),
          name: name,
          dependencies: dependencies,
        );
      },
  (create, {name, dependencies}) => ([arg]) {
        return FutureProvider.family<Object?, Object?>(
          (ref, arg) => create(ref, arg),
          name: name,
          dependencies: dependencies,
        )(arg);
      },
  (create, {name, dependencies}) => ([arg]) {
        return FutureProvider.autoDispose.family<Object?, Object?>(
          (ref, arg) => create(ref, arg),
          name: name,
          dependencies: dependencies,
        )(arg);
      },
];

final streamProviderFactories =
    <ProviderFactory<Stream<Object?>, StreamProvider<Object?>, Ref<Object?>>>[
  (create, {name, dependencies}) => ([arg]) {
        return StreamProvider<Object?>(
          (ref) => create(ref, arg),
          name: name,
          dependencies: dependencies,
        );
      },
  (create, {name, dependencies}) => ([arg]) {
        return StreamProvider.autoDispose<Object?>(
          (ref) => create(ref, arg),
          name: name,
          dependencies: dependencies,
        );
      },
  (create, {name, dependencies}) => ([arg]) {
        return StreamProvider.family<Object?, Object?>(
          (ref, arg) => create(ref, arg),
          name: name,
          dependencies: dependencies,
        )(arg);
      },
  (create, {name, dependencies}) => ([arg]) {
        return StreamProvider.autoDispose.family<Object?, Object?>(
          (ref, arg) => create(ref, arg),
          name: name,
          dependencies: dependencies,
        )(arg);
      },
];

final asyncProviderFactory =
    <ProviderFactory<Object?, ProviderBase<AsyncValue<Object?>>, Ref<Object?>>>[
  for (final factory in futureProviderFactories)
    (create, {name, dependencies}) => factory(
          (ref, arg) async => create(ref, arg),
          name: name,
          dependencies: dependencies,
        ),
  for (final factory in streamProviderFactories)
    (create, {name, dependencies}) => factory(
          (ref, arg) => Stream.value(create(ref, arg)),
          name: name,
          dependencies: dependencies,
        ),
];

final asyncNotifierProviderFactory = TestMatrix<AsyncNotifierTestFactory>(
  {
    'AsyncNotifierProvider': AsyncNotifierTestFactory(
      deferredNotifier: DeferredAsyncNotifier.new,
      deferredProvider: <StateT>(create, {updateShouldNotify}) {
        return AsyncNotifierProvider<DeferredAsyncNotifier<StateT>, StateT>(
          () => DeferredAsyncNotifier(
            create,
            updateShouldNotify: updateShouldNotify,
          ),
        );
      },
      provider: <StateT>(create) =>
          AsyncNotifierProvider<AsyncNotifier<StateT>, StateT>(
        () => create() as AsyncNotifier<StateT>,
      ),
      value: (create, {name, dependencies}) => ([arg]) {
        return AsyncNotifierProvider<AsyncNotifier<Object?>, Object?>(
          () => create(null, arg) as AsyncNotifier<Object?>,
          name: name,
          dependencies: dependencies,
        );
      },
    ),
    'AsyncNotifierProvider.autoDispose': AsyncNotifierTestFactory(
      deferredNotifier: DeferredAsyncNotifier.new,
      deferredProvider: <StateT>(create, {updateShouldNotify}) {
        return AsyncNotifierProvider.autoDispose<DeferredAsyncNotifier<StateT>,
            StateT>(
          () => DeferredAsyncNotifier(
            create,
            updateShouldNotify: updateShouldNotify,
          ),
        );
      },
      provider: <StateT>(create) {
        return AsyncNotifierProvider.autoDispose<AsyncNotifier<StateT>, StateT>(
          () => create() as AsyncNotifier<StateT>,
        );
      },
      value: (create, {name, dependencies}) => ([arg]) {
        return AsyncNotifierProvider.autoDispose<AsyncNotifier<Object?>,
            Object?>(
          () => create(null, arg) as AsyncNotifier<Object?>,
          name: name,
          dependencies: dependencies,
        );
      },
    ),
    'AsyncNotifierProvider.family': AsyncNotifierTestFactory(
      deferredNotifier: DeferredFamilyAsyncNotifier.new,
      deferredProvider: <StateT>(create, {updateShouldNotify}) {
        return AsyncNotifierProvider.family<DeferredFamilyAsyncNotifier<StateT>,
            StateT, Object?>(
          () => DeferredFamilyAsyncNotifier(
            create,
            updateShouldNotify: updateShouldNotify,
          ),
        ).call(42);
      },
      provider: <StateT>(create) {
        return AsyncNotifierProvider.family<
            FamilyAsyncNotifier<StateT, Object?>, StateT, Object?>(
          () => create() as FamilyAsyncNotifier<StateT, Object?>,
        ).call(42);
      },
      value: (create, {name, dependencies}) => ([arg]) {
        return AsyncNotifierProvider.family<
            FamilyAsyncNotifier<Object?, Object?>, Object?, Object?>(
          () => create(null, arg) as FamilyAsyncNotifier<Object?, Object?>,
          name: name,
          dependencies: dependencies,
        )(arg);
      },
    ),
    'AsyncNotifierProvider.autoDispose.family': AsyncNotifierTestFactory(
      deferredNotifier: DeferredFamilyAsyncNotifier.new,
      deferredProvider: <StateT>(create, {updateShouldNotify}) {
        return AsyncNotifierProvider.family
            .autoDispose<DeferredFamilyAsyncNotifier<StateT>, StateT, Object?>(
              () => DeferredFamilyAsyncNotifier(
                create,
                updateShouldNotify: updateShouldNotify,
              ),
            )
            .call(42);
      },
      provider: <StateT>(create) {
        return AsyncNotifierProvider.autoDispose
            .family<FamilyAsyncNotifier<StateT, Object?>, StateT, Object?>(
              () => create() as FamilyAsyncNotifier<StateT, Object?>,
            )
            .call(42);
      },
      value: (create, {name, dependencies}) => ([arg]) {
        return AsyncNotifierProvider.autoDispose
            .family<FamilyAsyncNotifier<Object?, Object?>, Object?, Object?>(
          () => create(null, arg) as FamilyAsyncNotifier<Object?, Object?>,
          name: name,
          dependencies: dependencies,
        )(arg);
      },
    ),
  },
);

abstract class TestAsyncNotifier<StateT> implements AsyncNotifierBase<StateT> {
  // Removing protected
  @override
  AsyncValue<StateT> get state;

  @override
  set state(AsyncValue<StateT> value);
}

class DeferredAsyncNotifier<StateT> extends AsyncNotifier<StateT>
    implements TestAsyncNotifier<StateT> {
  DeferredAsyncNotifier(
    this._create, {
    bool Function(AsyncValue<StateT>, AsyncValue<StateT>)? updateShouldNotify,
  }) : _updateShouldNotify = updateShouldNotify;

  final FutureOr<StateT> Function(Ref<AsyncValue<StateT>> ref) _create;
  final bool Function(
    AsyncValue<StateT> previousState,
    AsyncValue<StateT> newState,
  )? _updateShouldNotify;

  @override
  FutureOr<StateT> build() => _create(ref);

  @override
  bool updateShouldNotify(
    AsyncValue<StateT> previousState,
    AsyncValue<StateT> newState,
  ) =>
      _updateShouldNotify?.call(previousState, newState) ??
      super.updateShouldNotify(previousState, newState);
}

class DeferredFamilyAsyncNotifier<StateT>
    extends FamilyAsyncNotifier<StateT, int>
    implements TestAsyncNotifier<StateT> {
  DeferredFamilyAsyncNotifier(
    this._create, {
    bool Function(AsyncValue<StateT>, AsyncValue<StateT>)? updateShouldNotify,
  }) : _updateShouldNotify = updateShouldNotify;

  final FutureOr<StateT> Function(Ref<AsyncValue<StateT>> ref) _create;

  final bool Function(
    AsyncValue<StateT> previousState,
    AsyncValue<StateT> newState,
  )? _updateShouldNotify;

  @override
  FutureOr<StateT> build(int arg) => _create(ref);

  @override
  bool updateShouldNotify(
    AsyncValue<StateT> previousState,
    AsyncValue<StateT> newState,
  ) =>
      _updateShouldNotify?.call(previousState, newState) ??
      super.updateShouldNotify(previousState, newState);
}

class AsyncNotifierTestFactory extends TestFactory<
    ProviderFactory<AsyncNotifierBase<Object?>, ProviderBase<Object?>, void>> {
  AsyncNotifierTestFactory({
    required super.value,
    required this.deferredNotifier,
    required this.deferredProvider,
    required this.provider,
  });

  final TestAsyncNotifier<StateT> Function<StateT>(
    FutureOr<StateT> Function(Ref<AsyncValue<StateT>> ref) create,
  ) deferredNotifier;

  final AsyncNotifierProviderBase<TestAsyncNotifier<StateT>, StateT>
      Function<StateT>(
    FutureOr<StateT> Function(Ref<AsyncValue<StateT>> ref) create, {
    bool Function(AsyncValue<StateT>, AsyncValue<StateT>)? updateShouldNotify,
  }) deferredProvider;

  final AsyncNotifierProviderBase<AsyncNotifierBase<StateT>, StateT>
      Function<StateT>(
    AsyncNotifierBase<StateT> Function() create,
  ) provider;

  AsyncNotifierProviderBase<TestAsyncNotifier<StateT>, StateT>
      simpleTestProvider<StateT>(
    FutureOr<StateT> Function(Ref<AsyncValue<StateT>> ref) create, {
    bool Function(AsyncValue<StateT>, AsyncValue<StateT>)? updateShouldNotify,
  }) {
    return deferredProvider<StateT>(
      (ref) => create(ref),
      updateShouldNotify: updateShouldNotify,
    );
  }
}
