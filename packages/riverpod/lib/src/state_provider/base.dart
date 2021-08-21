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
  bool updateShouldNotify(
    StateController<State> previousState,
    StateController<State> newState,
  ) {
    return true;
  }

  @override
  void setupOverride(SetupOverride setup) =>
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

  bool _debugDidSetValue = false;

  @override
  StateController<State> get controller {
    assert(() {
      if (!_debugDidSetValue) {
        throw StateError(
          'Cannot read the state exposed by a provider within '
          'before it was set',
        );
      }
      return true;
    }(), '');
    return getState()!;
  }

  @override
  void setState(StateController<State> newState) {
    assert(() {
      _debugDidSetValue = true;
      return true;
    }(), '');
    super.setState(newState);
  }

  @override
  void debugWillRebuildState() {
    _debugDidSetValue = false;
  }
}

/// {@macro riverpod.stateprovider}
@sealed
class StateProvider<State>
    extends AlwaysAliveProviderBase<StateController<State>> {
  /// {@macro riverpod.stateprovider}
  StateProvider(this._create, {String? name}) : super(name);

  /// {@macro riverpod.family}
  static const family = StateProviderFamilyBuilder();

  /// {@macro riverpod.autoDispose}
  static const autoDispose = AutoDisposeStateProviderBuilder();

  final Create<State, StateProviderRef<State>> _create;

  @override
  ProviderBase<Object?> get providerToRefresh => notifier;

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
  StateController<State> create(
    ProviderElementBase<StateController<State>> ref,
  ) {
    return _listenStateProvider(ref, ref.watch(notifier));
  }

  @override
  bool updateShouldNotify(
    StateController<State> previousState,
    StateController<State> newState,
  ) {
    return true;
  }

  /// Overrides the behavior of a provider with a value.
  ///
  /// {@macro riverpod.overideWith}
  Override overrideWithProvider(
    StateProvider<State> provider,
  ) {
    return ProviderOverride((setup) {
      setup(origin: this, override: this);
      setup(origin: notifier, override: provider.notifier);
    });
  }

  /// Overrides the behavior of a provider with a another provider.
  ///
  /// {@macro riverpod.overideWith}
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
    final provider = StateProvider<State>(
      (ref) => _create(ref, argument),
      name: name,
    );

    registerProvider(provider.notifier, argument);

    return provider;
  }

  /// Overrides the behavior of a family for a part of the application.
  ///
  /// {@macro riverpod.overideWith}
  Override overrideWithProvider(
    StateProvider<State> Function(Arg argument) override,
  ) {
    return FamilyOverride<Arg>(
      this,
      (arg, setup) {
        final provider = call(arg);
        setup(origin: provider.notifier, override: override(arg).notifier);
        setup(origin: provider, override: provider);
      },
    );
  }

  @override
  void setupOverride(Arg argument, SetupOverride setup) {
    final provider = call(argument);
    setup(origin: provider, override: provider);
    setup(origin: provider.notifier, override: provider.notifier);
  }
}
