part of '../matrix.dart';

final asyncNotifierProviderFactory = TestMatrix<AsyncNotifierTestFactory>(
  {
    'AsyncNotifierProvider': AsyncNotifierTestFactory(
      isAutoDispose: false,
      isFamily: false,
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
      value: (create, {name, dependencies, retry}) => ([arg]) {
        return AsyncNotifierProvider<AsyncNotifier<Object?>, Object?>(
          () => create(null, arg) as AsyncNotifier<Object?>,
          name: name,
          dependencies: dependencies,
          retry: retry,
        );
      },
    ),
    'AsyncNotifierProvider.autoDispose': AsyncNotifierTestFactory(
      isAutoDispose: true,
      isFamily: false,
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
      value: (create, {name, dependencies, retry}) => ([arg]) {
        return AsyncNotifierProvider.autoDispose<AsyncNotifier<Object?>,
            Object?>(
          () => create(null, arg) as AsyncNotifier<Object?>,
          name: name,
          dependencies: dependencies,
          retry: retry,
        );
      },
    ),
    'AsyncNotifierProvider.family': AsyncNotifierTestFactory(
      isAutoDispose: false,
      isFamily: true,
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
      value: (create, {name, dependencies, retry}) => ([arg]) {
        return AsyncNotifierProvider.family<
            FamilyAsyncNotifier<Object?, Object?>, Object?, Object?>(
          () => create(null, arg) as FamilyAsyncNotifier<Object?, Object?>,
          name: name,
          dependencies: dependencies,
          retry: retry,
        )(arg);
      },
    ),
    'AsyncNotifierProvider.autoDispose.family': AsyncNotifierTestFactory(
      isAutoDispose: true,
      isFamily: true,
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
      value: (create, {name, dependencies, retry}) => ([arg]) {
        return AsyncNotifierProvider.autoDispose
            .family<FamilyAsyncNotifier<Object?, Object?>, Object?, Object?>(
          () => create(null, arg) as FamilyAsyncNotifier<Object?, Object?>,
          name: name,
          dependencies: dependencies,
          retry: retry,
        )(arg);
      },
    ),
  },
);

abstract class TestAsyncNotifier<StateT> implements $AsyncNotifier<StateT> {
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

  final FutureOr<StateT> Function(Ref ref) _create;
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

  final FutureOr<StateT> Function(Ref ref) _create;

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
    ProviderFactory<$AsyncNotifier<Object?>, ProviderBase<Object?>>> {
  AsyncNotifierTestFactory({
    required super.isAutoDispose,
    required super.isFamily,
    required super.value,
    required this.deferredNotifier,
    required this.deferredProvider,
    required this.provider,
  });

  final TestAsyncNotifier<StateT> Function<StateT>(
    FutureOr<StateT> Function(Ref ref) create,
  ) deferredNotifier;

  final $AsyncNotifierProvider<TestAsyncNotifier<StateT>, StateT>
      Function<StateT>(
    FutureOr<StateT> Function(Ref ref) create, {
    bool Function(AsyncValue<StateT>, AsyncValue<StateT>)? updateShouldNotify,
  }) deferredProvider;

  final $AsyncNotifierProvider<$AsyncNotifier<StateT>, StateT> Function<StateT>(
    $AsyncNotifier<StateT> Function() create,
  ) provider;

  $AsyncNotifierProvider<TestAsyncNotifier<StateT>, StateT>
      simpleTestProvider<StateT>(
    FutureOr<StateT> Function(Ref ref) create, {
    bool Function(AsyncValue<StateT>, AsyncValue<StateT>)? updateShouldNotify,
  }) {
    return deferredProvider<StateT>(
      (ref) => create(ref),
      updateShouldNotify: updateShouldNotify,
    );
  }
}
