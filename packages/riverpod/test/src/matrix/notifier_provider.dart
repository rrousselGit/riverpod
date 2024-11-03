part of '../matrix.dart';

final notifierProviderFactory = TestMatrix<NotifierTestFactory>(
  {
    'NotifierProvider': NotifierTestFactory(
      isAutoDispose: false,
      isFamily: false,
      deferredNotifier: <T>(create) =>
          DeferredNotifier<T>((ref, self) => create(ref, self)),
      deferredProvider: <StateT>(create, {updateShouldNotify}) {
        return NotifierProvider<DeferredNotifier<StateT>, StateT>(
          () => DeferredNotifier(
            (ref, self) => create(ref, self),
            updateShouldNotify: updateShouldNotify,
          ),
        );
      },
      provider: <StateT>(create) => NotifierProvider<Notifier<StateT>, StateT>(
        () => create() as Notifier<StateT>,
      ),
      value: (create, {name, dependencies, retry}) => ([arg]) {
        return NotifierProvider<Notifier<Object?>, Object?>(
          () => create(null, arg) as Notifier<Object?>,
          name: name,
          dependencies: dependencies,
          retry: retry,
        );
      },
    ),
    'NotifierProvider.autoDispose': NotifierTestFactory(
      isAutoDispose: true,
      isFamily: false,
      deferredNotifier: <T>(create) =>
          DeferredNotifier<T>((ref, self) => create(ref, self)),
      deferredProvider: <StateT>(create, {updateShouldNotify}) {
        return NotifierProvider.autoDispose<DeferredNotifier<StateT>, StateT>(
          () => DeferredNotifier(
            (ref, self) => create(ref, self),
            updateShouldNotify: updateShouldNotify,
          ),
        );
      },
      provider: <StateT>(create) {
        return NotifierProvider.autoDispose<Notifier<StateT>, StateT>(
          () => create() as Notifier<StateT>,
        );
      },
      value: (create, {name, dependencies, retry}) => ([arg]) {
        return NotifierProvider.autoDispose<Notifier<Object?>, Object?>(
          () => create(null, arg) as Notifier<Object?>,
          name: name,
          dependencies: dependencies,
          retry: retry,
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
      value: (create, {name, dependencies, retry}) => ([arg]) {
        return NotifierProvider.family<FamilyNotifier<Object?, Object?>,
            Object?, Object?>(
          () => create(null, arg) as FamilyNotifier<Object?, Object?>,
          name: name,
          dependencies: dependencies,
          retry: retry,
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
      value: (create, {name, dependencies, retry}) => ([arg]) {
        return NotifierProvider.autoDispose
            .family<FamilyNotifier<Object?, Object?>, Object?, Object?>(
          () => create(null, arg) as FamilyNotifier<Object?, Object?>,
          name: name,
          dependencies: dependencies,
          retry: retry,
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

  @override
  void listenSelf(
    void Function(StateT? previous, StateT next) listener, {
    void Function(Object error, StackTrace stackTrace)? onError,
  });
}

class DeferredNotifier<StateT> extends Notifier<StateT>
    implements TestNotifier<StateT> {
  DeferredNotifier(
    this._create, {
    bool Function(StateT, StateT)? updateShouldNotify,
  }) : _updateShouldNotify = updateShouldNotify;

  final StateT Function(Ref ref, DeferredNotifier<StateT> self) _create;
  final bool Function(
    StateT previousState,
    StateT newState,
  )? _updateShouldNotify;

  @override
  Ref get ref;

  @override
  void listenSelf(
    void Function(StateT? previous, StateT next) listener, {
    void Function(Object error, StackTrace stackTrace)? onError,
  });

  @override
  StateT build() => _create(ref, this);

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

  final StateT Function(Ref ref, DeferredFamilyNotifier<StateT> self) _create;

  final bool Function(
    StateT previousState,
    StateT newState,
  )? _updateShouldNotify;

  @override
  StateT build(int arg) => _create(ref, this);

  @override
  bool updateShouldNotify(
    StateT previousState,
    StateT newState,
  ) =>
      _updateShouldNotify?.call(previousState, newState) ??
      super.updateShouldNotify(previousState, newState);
}

class NotifierTestFactory extends TestFactory<
    ProviderFactory<$Notifier<Object?>, ProviderBase<Object?>>> {
  NotifierTestFactory({
    required super.isAutoDispose,
    required super.isFamily,
    required super.value,
    required this.deferredNotifier,
    required this.deferredProvider,
    required this.provider,
  });

  final TestNotifier<StateT> Function<StateT>(
    StateT Function(Ref ref, $Notifier<StateT> self) create,
  ) deferredNotifier;

  final $NotifierProvider<TestNotifier<StateT>, StateT> Function<StateT>(
    StateT Function(Ref ref, $Notifier<StateT> self) create, {
    bool Function(StateT, StateT)? updateShouldNotify,
  }) deferredProvider;

  final $NotifierProvider<$Notifier<StateT>, StateT> Function<StateT>(
    $Notifier<StateT> Function() create,
  ) provider;

  $NotifierProvider<TestNotifier<StateT>, StateT> simpleTestProvider<StateT>(
    StateT Function(Ref ref, $Notifier<StateT> self) create, {
    bool Function(StateT, StateT)? updateShouldNotify,
  }) {
    return deferredProvider<StateT>(
      (ref, self) => create(ref, self),
      updateShouldNotify: updateShouldNotify,
    );
  }
}
