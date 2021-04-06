part of '../state_provider.dart';

/// {@macro riverpod.stateprovider}
@sealed
class StateProvider<T>
    extends AlwaysAliveProviderBase<StateController<T>, StateController<T>>
    with ProviderOverridesMixin<StateController<T>, StateController<T>> {
  /// {@macro riverpod.stateprovider}
  StateProvider(
    this._create, {
    String? name,
  }) : super(name);

  /// {@template riverpod.stateprovider.notifier}
  /// Obtains the [StateController] associated with this provider, but without
  /// listening to it.
  ///
  /// Listening to this provider may cause providers/widgets to rebuild in the
  /// event that the [StateController] it recreated.
  ///
  ///
  /// It is preferrable to do:
  /// ```dart
  /// ref.watch(stateProvider.notifier)
  /// ```
  ///
  /// instead of:
  /// ```dart
  /// ref.read(stateProvider)
  /// ```
  ///
  /// The reasoning is, using `read` could cause hard to catch bugs, such as
  /// not rebuilding dependent providers/widgets after using `context.refresh` on this provider.
  /// {@endtemplate}
  late final AlwaysAliveProviderBase<StateController<T>, StateController<T>>
      notifier = Provider((ref) => ref.watch(this));

  final Create<T, ProviderReference> _create;

  @override
  StateController<T> create(ProviderReference ref) {
    return StateController(_create(ref));
  }

  /// {@macro riverpod.family}
  static const family = StateProviderFamilyBuilder();

  /// {@macro riverpod.autoDispose}
  static const autoDispose = AutoDisposeStateProviderBuilder();

  @override
  _StateProviderState<T> createState() {
    return _StateProviderState<T>();
  }
}

@sealed
class _StateProviderState<T> = ProviderStateBase<StateController<T>,
    StateController<T>> with _StateProviderStateMixin<T>;

/// {@macro riverpod.stateprovider.family}
@sealed
class StateProviderFamily<T, A> extends Family<StateController<T>,
    StateController<T>, A, ProviderReference, StateProvider<T>> {
  /// {@macro riverpod.stateprovider.family}
  StateProviderFamily(
    T Function(ProviderReference ref, A a) create, {
    String? name,
  }) : super((ref, a) => StateController(create(ref, a)), name);

  @override
  StateProvider<T> create(
    A value,
    StateController<T> Function(ProviderReference ref, A param) builder,
    String? name,
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
      (param) {
        return create(
          param as Param,
          (ref, a) => StateController(builderOverride(ref, a)),
          null,
        );
      },
    );
  }
}
