part of '../state_provider.dart';

/// {@macro riverpod.providerrefbase}
/// - [controller], the [StateController] currently exposed by this providers.
abstract class AutoDisposeStateProviderRef<State>
    implements AutoDisposeProviderRefBase, StateProviderRef<State> {}

/// The [ProviderElementBase] for [StateProvider]
class AutoDisposeStateProviderElement<State>
    extends AutoDisposeProviderElementBase<StateController<State>>
    implements AutoDisposeStateProviderRef<State> {
  /// The [ProviderElementBase] for [StateProvider]
  AutoDisposeStateProviderElement(ProviderBase<StateController<State>> provider)
      : super(provider);

  @override
  StateController<State> get controller => state;
}

/// {@macro riverpod.stateprovider}
@sealed
class AutoDisposeStateProvider<State>
    extends AutoDisposeProviderBase<StateController<State>>
    with AutoDisposeProviderOverridesMixin<StateController<State>> {
  /// {@macro riverpod.stateprovider}
  AutoDisposeStateProvider(this._create, {String? name}) : super(name);

  /// {@macro riverpod.family}
  static const family = AutoDisposeStateProviderFamilyBuilder();

  final Create<State, AutoDisposeStateProviderRef<State>> _create;

  @override
  StateController<State> create(AutoDisposeStateProviderRef<State> ref) {
    return _createStateProvider(
      ref as ProviderElementBase<StateController<State>>,
      _create(ref),
    );
  }

  @override
  bool recreateShouldNotify(
    StateController<State> previousState,
    StateController<State> newState,
  ) {
    return true;
  }

  /// {@macro riverpod.stateprovider.notifier}
  late final AutoDisposeProviderBase<StateController<State>> notifier =
      AutoDisposeProvider((ref) => ref.watch(this));

  @override
  AutoDisposeStateProviderElement<State> createElement() {
    return AutoDisposeStateProviderElement(this);
  }
}

/// {@macro riverpod.stateprovider.family}
@sealed
class AutoDisposeStateProviderFamily<State, Arg> extends Family<
    StateController<State>, Arg, AutoDisposeStateProvider<State>> {
  /// {@macro riverpod.stateprovider.family}
  AutoDisposeStateProviderFamily(this._create, {String? name}) : super(name);

  final FamilyCreate<State, AutoDisposeStateProviderRef<State>, Arg> _create;

  @override
  AutoDisposeStateProvider<State> create(
    Arg argument,
  ) {
    return AutoDisposeStateProvider(
      (ref) => _create(ref, argument),
      name: name,
    );
  }
}
