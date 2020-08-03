part of '../state_provider.dart';

/// {@macro riverpod.stateprovider}
class AutoDisposeStateProvider<T>
    extends AutoDisposeProviderBase<StateController<T>, StateController<T>> {
  /// {@macro riverpod.stateprovider}
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

/// {@template riverpod.stateprovider.family}
/// A class that allows building a [StateProvider] from an external parameter.
/// {@endtemplate}
class AutoDisposeStateProviderFamily<T, A> extends Family<
    StateController<T>,
    StateController<T>,
    A,
    AutoDisposeProviderReference,
    AutoDisposeStateProvider<T>> {
  /// {@macro riverpod.stateprovider.family}
  AutoDisposeStateProviderFamily(
    T Function(AutoDisposeProviderReference ref, A a) create, {
    String name,
  }) : super((ref, a) => StateController(create(ref, a)), name);

  @override
  AutoDisposeStateProvider<T> create(
    A value,
    StateController<T> Function(AutoDisposeProviderReference ref, A param)
        builder,
    String name,
  ) {
    return AutoDisposeStateProvider((ref) {
      return builder(ref, value).state;
    }, name: name);
  }
}

/// Overrides [overrideWithProvider] for [StateProvider.autoDispose.family].
extension AutoDisposeStateFamilyX<T, Param> on Family<
    StateController<T>,
    StateController<T>,
    Param,
    AutoDisposeProviderReference,
    AutoDisposeStateProvider<T>> {
  /// Overrides the behavior of a family for a part of the application.
  Override overrideWithProvider(
    T Function(AutoDisposeProviderReference ref, Param param) builderOverride,
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
