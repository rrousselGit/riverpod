part of '../state_provider.dart';

/// {@macro riverpod.stateprovider}
class StateProvider<T>
    extends AlwaysAliveProviderBase<StateController<T>, StateController<T>> {
  /// {@macro riverpod.stateprovider}
  StateProvider(
    Create<T, ProviderReference> create, {
    String name,
  }) : super((ref) => StateController(create(ref)), name);

  /// {@macro riverpod.family}
  static const family = StateProviderFamilyBuilder();

  /// {@macro riverpod.autoDispose}
  static const autoDispose = AutoDisposeStateProviderBuilder();

  @override
  _StateProviderState<T> createState() {
    return _StateProviderState<T>();
  }
}

class _StateProviderState<T> = ProviderStateBase<StateController<T>,
    StateController<T>> with _StateProviderStateMixin<T>;

/// {@macro riverpod.stateprovider.family}
class StateProviderFamily<T, A> extends Family<StateController<T>,
    StateController<T>, A, ProviderReference, StateProvider<T>> {
  /// {@macro riverpod.stateprovider.family}
  StateProviderFamily(
    T Function(ProviderReference ref, A a) create, {
    String name,
  }) : super((ref, a) => StateController(create(ref, a)), name);

  @override
  StateProvider<T> create(
    A value,
    StateController<T> Function(ProviderReference ref, A param) builder,
    String name,
  ) {
    return StateProvider((ref) => builder(ref, value).state, name: name);
  }
}

/// Overrides [overrideWithProvider] for [StateProvider.family].
extension StateFamilyX<T, Param> on Family<StateController<T>,
    StateController<T>, Param, ProviderReference, StateProvider<T>> {
  /// Overrides the behavior of a family for a part of the application.
  Override overrideWithProvider(
    T Function(ProviderReference ref, Param param) builderOverride,
  ) {
    return FamilyOverride(
      this,
      (dynamic param) {
        return create(
          param as Param,
          (ref, a) => StateController(builderOverride(ref, a)),
          null,
        );
      },
    );
  }
}
