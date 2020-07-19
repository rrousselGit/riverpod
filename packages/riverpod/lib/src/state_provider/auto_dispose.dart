part of '../state_provider.dart';

class AutoDisposeStateProvider<T>
    extends AutoDisposeProviderBase<StateController<T>, StateController<T>> {
  AutoDisposeStateProvider(
    Create<T, AutoDisposeProviderReference> create, {
    String name,
  }) : super((ref) => StateController(create(ref)), name);

  @override
  _AutoDisposeStateProviderState<T> createState() {
    return _AutoDisposeStateProviderState<T>();
  }
}

class _AutoDisposeStateProviderState<T> = ProviderStateBase<StateController<T>,
    StateController<T>> with _StateProviderStateMixin<T>;

extension AutoDisposeStateFamilyX<T, Param> on Family<
    StateController<T>,
    StateController<T>,
    Param,
    AutoDisposeProviderReference,
    AutoDisposeStateProvider<T>> {
  /// Overrides the behavior of a family for a part of the application.
  Override overrideAsProvider(
    T Function(AutoDisposeProviderReference ref, Param param) builderOverride,
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
