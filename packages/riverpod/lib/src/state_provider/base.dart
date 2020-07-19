part of '../state_provider.dart';

class StateProvider<T>
    extends AlwaysAliveProviderBase<StateController<T>, StateController<T>> {
  StateProvider(
    Create<T, ProviderReference> create, {
    String name,
  }) : super((ref) => StateController(create(ref)), name);

  /// {@macro riverpod.family}
  static const family = StateProviderFamilyBuilder();

  /// {@macro riverpod.autoDispose}
  // TODO
  // static const autoDispose = AutoDisposeStateProviderBuilder();

  @override
  _StateProviderState<T> createState() {
    return _StateProviderState<T>();
  }
}

class _StateProviderState<T> = ProviderStateBase<StateController<T>,
    StateController<T>> with _StateProviderStateMixin<T>;

class StateProviderFamily<T, A> extends Family<StateController<T>,
    StateController<T>, A, ProviderReference, StateProvider<T>> {
  StateProviderFamily(
    T Function(ProviderReference ref, A a) create, {
    String name,
  }) : super((ref, a) => StateController(create(ref, a)), name);

  @override
  StateProvider<T> create(
    A value,
    StateController<T> Function(ProviderReference ref, A param) builder,
  ) {
    return StateProvider((ref) => builder(ref, value).state, name: name);
  }
}

extension StateFamilyX<T, Param> on Family<StateController<T>,
    StateController<T>, Param, ProviderReference, StateProvider<T>> {
  /// Overrides the behavior of a family for a part of the application.
  Override overrideAsProvider(
    T Function(ProviderReference ref, Param param) builderOverride,
  ) {
    return FamilyOverride(
      this,
      (dynamic param) {
        return create(
          param as Param,
          (ref, a) => StateController(builderOverride(ref, a)),
        );
      },
    );
  }
}
