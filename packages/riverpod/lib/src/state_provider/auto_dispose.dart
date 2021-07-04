part of '../state_provider.dart';

class _AutoDisposeNotifierProvider<State>
    extends AutoDisposeProviderBase<StateController<State>> {
  _AutoDisposeNotifierProvider(this._create, {required String? name})
      : super(name);

  final Create<State, AutoDisposeStateProviderRef<State>> _create;

  @override
  StateController<State> create(AutoDisposeStateProviderRef<State> ref) {
    final initialState = _create(ref);
    final notifier = StateController(initialState);
    ref.onDispose(notifier.dispose);
    return notifier;
  }

  @override
  bool recreateShouldNotify(
    StateController<State> previousState,
    StateController<State> newState,
  ) {
    return true;
  }

  @override
  void setupOverride(SetupOverride setup) =>
      throw UnsupportedError('Cannot override StateProvider.notifier');

  @override
  AutoDisposeStateProviderElement<State> createElement() {
    return AutoDisposeStateProviderElement(this);
  }
}

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

  /// {@macro riverpod.stateprovider.notifier}
  late final AutoDisposeProviderBase<StateController<State>> notifier =
      _AutoDisposeNotifierProvider(
    _create,
    name: modifierName(name, 'notifier'),
  );

  @override
  StateController<State> create(AutoDisposeStateProviderRef<State> ref) {
    return _listenStateProvider(
      ref as ProviderElementBase<StateController<State>>,
      ref.watch(notifier),
    );
  }

  @override
  bool recreateShouldNotify(
    StateController<State> previousState,
    StateController<State> newState,
  ) {
    return true;
  }

  @override
  Override overrideWithProvider(
    AutoDisposeProviderBase<StateController<State>> provider,
  ) {
    return ProviderOverride((setup) {
      setup(origin: this, override: this);
      setup(origin: notifier, override: provider);
    });
  }

  @override
  Override overrideWithValue(StateController<State> value) {
    return ProviderOverride((setup) {
      setup(origin: this, override: this);
      setup(
        origin: notifier,
        override: ValueProvider<StateController<State>>(value),
      );
    });
  }

  @override
  void setupOverride(SetupOverride setup) {
    setup(origin: this, override: this);
    setup(origin: notifier, override: notifier);
  }

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
