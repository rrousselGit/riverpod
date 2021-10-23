part of '../state_provider.dart';

/// {@macro riverpod.providerrefbase}
/// - [controller], the [StateController] currently exposed by this providers.
abstract class AutoDisposeStateProviderRef<State>
    implements AutoDisposeRef, StateProviderRef<State> {}

/// {@macro riverpod.stateprovider}
@sealed
class AutoDisposeStateProvider<State>
    extends AutoDisposeProviderBase<StateController<State>> {
  /// {@macro riverpod.stateprovider}
  AutoDisposeStateProvider(
    Create<State, AutoDisposeStateProviderRef<State>> create, {
    String? name,
    List<ProviderOrFamily>? dependencies,
  })  : notifier = _AutoDisposeNotifierProvider(
          create,
          name: modifierName(name, 'notifier'),
          dependencies: dependencies,
        ),
        super(name: name);

  /// {@macro riverpod.family}
  static const family = AutoDisposeStateProviderFamilyBuilder();

  /// {@macro riverpod.stateprovider.notifier}
  final AutoDisposeProviderBase<StateController<State>> notifier;

  @override
  late final List<ProviderOrFamily> dependencies = [notifier];

  @override
  ProviderBase<Object?> get originProvider => this;

  /// {@macro riverpod.overrridewithvalue}
  Override overrideWithValue(StateController<State> value) {
    return ProviderOverride(
      origin: notifier,
      override: ValueProvider<StateController<State>>(value),
    );
  }

  /// {@macro riverpod.overrridewithprovider}
  Override overrideWithProvider(
    StateProvider<State> provider,
  ) {
    return ProviderOverride(
      origin: notifier,
      override: provider.notifier,
    );
  }

  @override
  StateController<State> create(AutoDisposeStateProviderRef<State> ref) {
    return _listenStateProvider(
      ref as ProviderElementBase<StateController<State>>,
      ref.watch(notifier),
    );
  }

  @override
  bool updateShouldNotify(
    StateController<State> previousState,
    StateController<State> newState,
  ) {
    return true;
  }

  @override
  AutoDisposeStateProviderElement<State> createElement() {
    return AutoDisposeStateProviderElement(this);
  }
}

/// The [ProviderElementBase] for [StateProvider]
class AutoDisposeStateProviderElement<State>
    extends AutoDisposeProviderElementBase<StateController<State>>
    implements AutoDisposeStateProviderRef<State> {
  /// The [ProviderElementBase] for [StateProvider]
  AutoDisposeStateProviderElement(ProviderBase<StateController<State>> provider)
      : super(provider);

  @override
  StateController<State> get controller => requireState;
}

class _AutoDisposeNotifierProvider<State>
    extends AutoDisposeProviderBase<StateController<State>> {
  _AutoDisposeNotifierProvider(
    this._create, {
    required String? name,
    required this.dependencies,
  }) : super(name: name);

  final Create<State, AutoDisposeStateProviderRef<State>> _create;

  @override
  final List<ProviderOrFamily>? dependencies;

  @override
  ProviderBase<Object?> get originProvider => this;

  @override
  StateController<State> create(AutoDisposeStateProviderRef<State> ref) {
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
  AutoDisposeStateProviderElement<State> createElement() {
    return AutoDisposeStateProviderElement(this);
  }
}

/// {@macro riverpod.stateprovider.family}
@sealed
class AutoDisposeStateProviderFamily<State, Arg> extends Family<
    StateController<State>, Arg, AutoDisposeStateProvider<State>> {
  /// {@macro riverpod.stateprovider.family}
  AutoDisposeStateProviderFamily(
    this._create, {
    String? name,
    List<ProviderOrFamily>? dependencies,
  }) : super(name: name, dependencies: dependencies);

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
