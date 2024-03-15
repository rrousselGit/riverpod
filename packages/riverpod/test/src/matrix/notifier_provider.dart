part of '../matrix.dart';

final notifierProviderFactory = TestMatrix<NotifierTestFactory>(
  {
    'NotifierProvider': NotifierTestFactory(
      isAutoDispose: false,
      isFamily: false,
      deferredNotifier: DeferredNotifier.new,
      deferredProvider: <StateT>(create, {updateShouldNotify}) {
        return NotifierProvider<DeferredNotifier<StateT>, StateT>(
          () => DeferredNotifier(
            create,
            updateShouldNotify: updateShouldNotify,
          ),
        );
      },
      provider: <StateT>(create) => NotifierProvider<Notifier<StateT>, StateT>(
        () => create() as Notifier<StateT>,
      ),
      value: (create, {name, dependencies}) => ([arg]) {
        return NotifierProvider<Notifier<Object?>, Object?>(
          () => create(null, arg) as Notifier<Object?>,
          name: name,
          dependencies: dependencies,
        );
      },
    ),
    'NotifierProvider.autoDispose': NotifierTestFactory(
      isAutoDispose: true,
      isFamily: false,
      deferredNotifier: DeferredNotifier.new,
      deferredProvider: <StateT>(create, {updateShouldNotify}) {
        return NotifierProvider.autoDispose<DeferredNotifier<StateT>, StateT>(
          () => DeferredNotifier(
            create,
            updateShouldNotify: updateShouldNotify,
          ),
        );
      },
      provider: <StateT>(create) {
        return NotifierProvider.autoDispose<Notifier<StateT>, StateT>(
          () => create() as Notifier<StateT>,
        );
      },
      value: (create, {name, dependencies}) => ([arg]) {
        return NotifierProvider.autoDispose<Notifier<Object?>, Object?>(
          () => create(null, arg) as Notifier<Object?>,
          name: name,
          dependencies: dependencies,
        );
      },
    ),
    'NotifierProvider.family': NotifierTestFactory(
      isAutoDispose: false,
      isFamily: true,
      deferredNotifier: DeferredFamilyNotifier.new,
      deferredProvider: <StateT>(create, {updateShouldNotify}) {
        return NotifierProvider.family<DeferredFamilyNotifier<StateT>, StateT,
            Object?>(
          () => DeferredFamilyNotifier(
            create,
            updateShouldNotify: updateShouldNotify,
          ),
        ).call(42);
      },
      provider: <StateT>(create) {
        return NotifierProvider.family<FamilyNotifier<StateT, Object?>, StateT,
            Object?>(
          () => create() as FamilyNotifier<StateT, Object?>,
        ).call(42);
      },
      value: (create, {name, dependencies}) => ([arg]) {
        return NotifierProvider.family<FamilyNotifier<Object?, Object?>,
            Object?, Object?>(
          () => create(null, arg) as FamilyNotifier<Object?, Object?>,
          name: name,
          dependencies: dependencies,
        )(arg);
      },
    ),
    'NotifierProvider.autoDispose.family': NotifierTestFactory(
      isAutoDispose: true,
      isFamily: true,
      deferredNotifier: DeferredFamilyNotifier.new,
      deferredProvider: <StateT>(create, {updateShouldNotify}) {
        return NotifierProvider.family
            .autoDispose<DeferredFamilyNotifier<StateT>, StateT, Object?>(
              () => DeferredFamilyNotifier(
                create,
                updateShouldNotify: updateShouldNotify,
              ),
            )
            .call(42);
      },
      provider: <StateT>(create) {
        return NotifierProvider.autoDispose
            .family<FamilyNotifier<StateT, Object?>, StateT, Object?>(
              () => create() as FamilyNotifier<StateT, Object?>,
            )
            .call(42);
      },
      value: (create, {name, dependencies}) => ([arg]) {
        return NotifierProvider.autoDispose
            .family<FamilyNotifier<Object?, Object?>, Object?, Object?>(
          () => create(null, arg) as FamilyNotifier<Object?, Object?>,
          name: name,
          dependencies: dependencies,
        )(arg);
      },
    ),
  },
);

abstract class TestNotifier<StateT> implements $Notifier<StateT> {
  // Removing protected
  @override
  StateT get state;

  @override
  set state(StateT value);
}

class DeferredNotifier<StateT> extends Notifier<StateT>
    implements TestNotifier<StateT> {
  DeferredNotifier(
    this._create, {
    bool Function(StateT, StateT)? updateShouldNotify,
  }) : _updateShouldNotify = updateShouldNotify;

  final StateT Function(Ref<StateT> ref) _create;
  final bool Function(
    StateT previousState,
    StateT newState,
  )? _updateShouldNotify;

  @override
  StateT build() => _create(ref);

  @override
  bool updateShouldNotify(StateT previousState, StateT newState) =>
      _updateShouldNotify?.call(previousState, newState) ??
      super.updateShouldNotify(previousState, newState);
}

class DeferredFamilyNotifier<StateT> extends FamilyNotifier<StateT, int>
    implements TestNotifier<StateT> {
  DeferredFamilyNotifier(
    this._create, {
    bool Function(StateT, StateT)? updateShouldNotify,
  }) : _updateShouldNotify = updateShouldNotify;

  final StateT Function(Ref<StateT> ref) _create;

  final bool Function(
    StateT previousState,
    StateT newState,
  )? _updateShouldNotify;

  @override
  StateT build(int arg) => _create(ref);

  @override
  bool updateShouldNotify(
    StateT previousState,
    StateT newState,
  ) =>
      _updateShouldNotify?.call(previousState, newState) ??
      super.updateShouldNotify(previousState, newState);
}

class NotifierTestFactory extends TestFactory<
    ProviderFactory<$Notifier<Object?>, ProviderBase<Object?>, void>> {
  NotifierTestFactory({
    required super.isAutoDispose,
    required super.isFamily,
    required super.value,
    required this.deferredNotifier,
    required this.deferredProvider,
    required this.provider,
  });

  final TestNotifier<StateT> Function<StateT>(
    StateT Function(Ref<StateT> ref) create,
  ) deferredNotifier;

  final $NotifierProvider<TestNotifier<StateT>, StateT> Function<StateT>(
    StateT Function(Ref<StateT> ref) create, {
    bool Function(StateT, StateT)? updateShouldNotify,
  }) deferredProvider;

  final $NotifierProvider<$Notifier<StateT>, StateT> Function<StateT>(
    $Notifier<StateT> Function() create,
  ) provider;

  $NotifierProvider<TestNotifier<StateT>, StateT> simpleTestProvider<StateT>(
    StateT Function(Ref<StateT> ref) create, {
    bool Function(StateT, StateT)? updateShouldNotify,
  }) {
    return deferredProvider<StateT>(
      (ref) => create(ref),
      updateShouldNotify: updateShouldNotify,
    );
  }
}
