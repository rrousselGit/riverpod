part of '../matrix.dart';

final streamNotifierProviderFactory = TestMatrix<StreamNotifierTestFactory>(
  {
    'StreamNotifierProvider': StreamNotifierTestFactory(
      isAutoDispose: false,
      isFamily: false,
      deferredNotifier: DeferredStreamNotifier.new,
      deferredProvider: <StateT>(create, {updateShouldNotify}) {
        return StreamNotifierProvider<DeferredStreamNotifier<StateT>, StateT>(
          () => DeferredStreamNotifier(
            create,
            updateShouldNotify: updateShouldNotify,
          ),
        );
      },
      provider: <StateT>(create) =>
          StreamNotifierProvider<StreamNotifier<StateT>, StateT>(
        () => create() as StreamNotifier<StateT>,
      ),
      value: (create, {name, dependencies}) => ([arg]) {
        return StreamNotifierProvider<StreamNotifier<Object?>, Object?>(
          () => create(null, arg) as StreamNotifier<Object?>,
          name: name,
          dependencies: dependencies,
        );
      },
    ),
    'StreamNotifierProvider.autoDispose': StreamNotifierTestFactory(
      isAutoDispose: true,
      isFamily: false,
      deferredNotifier: DeferredStreamNotifier.new,
      deferredProvider: <StateT>(create, {updateShouldNotify}) {
        return StreamNotifierProvider.autoDispose<
            DeferredStreamNotifier<StateT>, StateT>(
          () => DeferredStreamNotifier(
            create,
            updateShouldNotify: updateShouldNotify,
          ),
        );
      },
      provider: <StateT>(create) {
        return StreamNotifierProvider.autoDispose<StreamNotifier<StateT>,
            StateT>(
          () => create() as StreamNotifier<StateT>,
        );
      },
      value: (create, {name, dependencies}) => ([arg]) {
        return StreamNotifierProvider.autoDispose<StreamNotifier<Object?>,
            Object?>(
          () => create(null, arg) as StreamNotifier<Object?>,
          name: name,
          dependencies: dependencies,
        );
      },
    ),
    'StreamNotifierProvider.family': StreamNotifierTestFactory(
      isAutoDispose: false,
      isFamily: true,
      deferredNotifier: DeferredFamilyStreamNotifier.new,
      deferredProvider: <StateT>(create, {updateShouldNotify}) {
        return StreamNotifierProvider.family<
            DeferredFamilyStreamNotifier<StateT>, StateT, Object?>(
          () => DeferredFamilyStreamNotifier(
            create,
            updateShouldNotify: updateShouldNotify,
          ),
        ).call(42);
      },
      provider: <StateT>(create) {
        return StreamNotifierProvider.family<
            FamilyStreamNotifier<StateT, Object?>, StateT, Object?>(
          () => create() as FamilyStreamNotifier<StateT, Object?>,
        ).call(42);
      },
      value: (create, {name, dependencies}) => ([arg]) {
        return StreamNotifierProvider.family<
            FamilyStreamNotifier<Object?, Object?>, Object?, Object?>(
          () => create(null, arg) as FamilyStreamNotifier<Object?, Object?>,
          name: name,
          dependencies: dependencies,
        )(arg);
      },
    ),
    'StreamNotifierProvider.autoDispose.family': StreamNotifierTestFactory(
      isAutoDispose: true,
      isFamily: true,
      deferredNotifier: DeferredFamilyStreamNotifier.new,
      deferredProvider: <StateT>(create, {updateShouldNotify}) {
        return StreamNotifierProvider.family
            .autoDispose<DeferredFamilyStreamNotifier<StateT>, StateT, Object?>(
              () => DeferredFamilyStreamNotifier(
                create,
                updateShouldNotify: updateShouldNotify,
              ),
            )
            .call(42);
      },
      provider: <StateT>(create) {
        return StreamNotifierProvider.autoDispose
            .family<FamilyStreamNotifier<StateT, Object?>, StateT, Object?>(
              () => create() as FamilyStreamNotifier<StateT, Object?>,
            )
            .call(42);
      },
      value: (create, {name, dependencies}) => ([arg]) {
        return StreamNotifierProvider.autoDispose
            .family<FamilyStreamNotifier<Object?, Object?>, Object?, Object?>(
          () => create(null, arg) as FamilyStreamNotifier<Object?, Object?>,
          name: name,
          dependencies: dependencies,
        )(arg);
      },
    ),
  },
);

abstract class TestStreamNotifier<StateT> implements $StreamNotifier<StateT> {
  // Removing protected
  @override
  AsyncValue<StateT> get state;

  @override
  set state(AsyncValue<StateT> value);
}

class DeferredStreamNotifier<StateT> extends StreamNotifier<StateT>
    implements TestStreamNotifier<StateT> {
  DeferredStreamNotifier(
    this._create, {
    bool Function(AsyncValue<StateT>, AsyncValue<StateT>)? updateShouldNotify,
  }) : _updateShouldNotify = updateShouldNotify;

  final Stream<StateT> Function(Ref<AsyncValue<StateT>> ref) _create;
  final bool Function(
    AsyncValue<StateT> previousState,
    AsyncValue<StateT> newState,
  )? _updateShouldNotify;

  @override
  Stream<StateT> build() => _create(ref);

  @override
  bool updateShouldNotify(
    AsyncValue<StateT> previousState,
    AsyncValue<StateT> newState,
  ) =>
      _updateShouldNotify?.call(previousState, newState) ??
      super.updateShouldNotify(previousState, newState);
}

class DeferredFamilyStreamNotifier<StateT>
    extends FamilyStreamNotifier<StateT, int>
    implements TestStreamNotifier<StateT> {
  DeferredFamilyStreamNotifier(
    this._create, {
    bool Function(AsyncValue<StateT>, AsyncValue<StateT>)? updateShouldNotify,
  }) : _updateShouldNotify = updateShouldNotify;

  final Stream<StateT> Function(Ref<AsyncValue<StateT>> ref) _create;

  final bool Function(
    AsyncValue<StateT> previousState,
    AsyncValue<StateT> newState,
  )? _updateShouldNotify;

  @override
  Stream<StateT> build(int arg) => _create(ref);

  @override
  bool updateShouldNotify(
    AsyncValue<StateT> previousState,
    AsyncValue<StateT> newState,
  ) =>
      _updateShouldNotify?.call(previousState, newState) ??
      super.updateShouldNotify(previousState, newState);
}

class StreamNotifierTestFactory extends TestFactory<
    ProviderFactory<$StreamNotifier<Object?>, ProviderBase<Object?>, void>> {
  StreamNotifierTestFactory({
    required super.isAutoDispose,
    required super.isFamily,
    required super.value,
    required this.deferredNotifier,
    required this.deferredProvider,
    required this.provider,
  });

  final TestStreamNotifier<StateT> Function<StateT>(
    Stream<StateT> Function(Ref<AsyncValue<StateT>> ref) create,
  ) deferredNotifier;

  final $StreamNotifierProvider<TestStreamNotifier<StateT>, StateT>
      Function<StateT>(
    Stream<StateT> Function(Ref<AsyncValue<StateT>> ref) create, {
    bool Function(AsyncValue<StateT>, AsyncValue<StateT>)? updateShouldNotify,
  }) deferredProvider;

  final $StreamNotifierProvider<$StreamNotifier<StateT>, StateT>
      Function<StateT>(
    $StreamNotifier<StateT> Function() create,
  ) provider;

  $StreamNotifierProvider<TestStreamNotifier<StateT>, StateT>
      simpleTestProvider<StateT>(
    Stream<StateT> Function(Ref<AsyncValue<StateT>> ref) create, {
    bool Function(AsyncValue<StateT>, AsyncValue<StateT>)? updateShouldNotify,
  }) {
    return deferredProvider<StateT>(
      (ref) => create(ref),
      updateShouldNotify: updateShouldNotify,
    );
  }
}
