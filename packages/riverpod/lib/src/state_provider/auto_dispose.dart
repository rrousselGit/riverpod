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
    extends AutoDisposeProviderBase<StateController<State>> {
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

  /// Overrides the behavior of a provider with a value.
  ///
  /// {@macro riverpod.overideWith}
  Override overrideWithProvider(
    AutoDisposeStateProvider<State> provider,
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
    final provider = AutoDisposeStateProvider<State>(
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
    AutoDisposeStateProvider<State> Function(Arg argument) override,
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
