part of '../state_provider.dart';

class _NotifierProvider<State>
    extends AlwaysAliveProviderBase<StateController<State>> {
  _NotifierProvider(this._create, {required String? name}) : super(name);

  final Create<State, StateProviderRef<State>> _create;

  @override
  StateController<State> create(StateProviderRef<State> ref) {
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
  SetupOverride get setupOverride =>
      throw UnsupportedError('Cannot override StateProvider.notifier');

  @override
  StateProviderElement<State> createElement() {
    return StateProviderElement(this);
  }
}

/// {@macro riverpod.providerrefbase}
/// - [controller], the [StateController] currently exposed by this providers.
abstract class StateProviderRef<State> implements ProviderRefBase {
  /// The [StateController] currently exposed by this provider.
  ///
  /// Cannot be accessed while creating the provider.
  StateController<State> get controller;
}

/// The [ProviderElementBase] for [StateProvider]
class StateProviderElement<State>
    extends ProviderElementBase<StateController<State>>
    implements StateProviderRef<State> {
  /// The [ProviderElementBase] for [StateProvider]
  StateProviderElement(ProviderBase<StateController<State>> provider)
      : super(provider);

  @override
  StateController<State> get controller => state;
}

/// {@macro riverpod.stateprovider}
@sealed
class StateProvider<State>
    extends AlwaysAliveProviderBase<StateController<State>>
    with ProviderOverridesMixin<StateController<State>> {
  /// {@macro riverpod.stateprovider}
  StateProvider(this._create, {String? name}) : super(name);

  /// {@macro riverpod.family}
  static const family = StateProviderFamilyBuilder();

  /// {@macro riverpod.autoDispose}
  static const autoDispose = AutoDisposeStateProviderBuilder();

  final Create<State, StateProviderRef<State>> _create;

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
  late final AlwaysAliveProviderBase<StateController<State>> notifier =
      _NotifierProvider(_create, name: modifierName(name, 'notifier'));

  @override
  StateController<State> create(StateProviderRef<State> ref) {
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
    AlwaysAliveProviderBase<StateController<State>> provider,
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
  SetupOverride get setupOverride => (setup) {
        setup(origin: this, override: this);
        setup(origin: notifier, override: notifier);
      };

  @override
  StateProviderElement<State> createElement() => StateProviderElement(this);
}

/// {@macro riverpod.stateprovider.family}
@sealed
class StateProviderFamily<State, Arg>
    extends Family<StateController<State>, Arg, StateProvider<State>> {
  /// {@macro riverpod.stateprovider.family}
  StateProviderFamily(this._create, {String? name}) : super(name);

  final FamilyCreate<State, StateProviderRef<State>, Arg> _create;

  @override
  StateProvider<State> create(
    Arg argument,
  ) {
    return StateProvider(
      (ref) => _create(ref, argument),
      name: name,
    );
  }
}
