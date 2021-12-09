part of '../state_provider.dart';

/// {@macro riverpod.providerrefbase}
/// - [controller], the [StateController] currently exposed by this providers.
abstract class StateProviderRef<State> implements Ref {
  /// The [StateController] currently exposed by this provider.
  ///
  /// Cannot be accessed while creating the provider.
  StateController<State> get controller;
}

/// {@macro riverpod.stateprovider}
@sealed
class StateProvider<State> extends AlwaysAliveProviderBase<State>
    with
        StateProviderOverrideMixin<State>,
        OverrideWithProviderMixin<StateController<State>,
            StateProvider<State>> {
  /// {@macro riverpod.stateprovider}
  StateProvider(
    Create<State, StateProviderRef<State>> create, {
    String? name,
    List<ProviderOrFamily>? dependencies,
    Family? from,
    Object? argument,
  })  : notifier = _NotifierProvider(
          create,
          name: modifierName(name, 'notifier'),
          dependencies: dependencies,
          from: from,
          argument: argument,
        ),
        super(name: name, from: from, argument: argument);

  /// {@macro riverpod.family}
  static const family = StateProviderFamilyBuilder();

  /// {@macro riverpod.autoDispose}
  static const autoDispose = AutoDisposeStateProviderBuilder();

  @override
  ProviderBase<StateController<State>> get originProvider => notifier;

  @override
  late final AlwaysAliveProviderBase<StateController<State>> state =
      _NotifierStateProvider(
    (ref) {
      return _listenStateProvider(
        ref as ProviderElementBase<StateController<State>>,
        ref.watch(notifier),
      );
    },
    dependencies: [notifier],
    from: from,
    argument: argument,
  );

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
  /// not rebuilding dependent providers/widgets after using `ref.refresh` on this provider.
  /// {@endtemplate}
  @override
  final AlwaysAliveProviderBase<StateController<State>> notifier;

  @override
  State create(
    ProviderElementBase<State> ref,
  ) {
    final notifier = ref.watch(this.notifier);

    final removeListener = notifier.addListener(ref.setState);
    ref.onDispose(removeListener);

    return notifier.state;
  }

  @override
  bool updateShouldNotify(State previousState, State newState) {
    return true;
  }

  @override
  StateProviderElement<State> createElement() => StateProviderElement(this);
}

/// The [ProviderElementBase] for [StateProvider]
class StateProviderElement<State> extends ProviderElementBase<State> {
  /// The [ProviderElementBase] for [StateProvider]
  StateProviderElement(StateProvider<State> provider) : super(provider);
}

class _NotifierStateProvider<State> extends Provider<State> {
  _NotifierStateProvider(
    Create<State, ProviderRef<State>> create, {
    List<ProviderOrFamily>? dependencies,
    required Family? from,
    required Object? argument,
  }) : super(
          create,
          dependencies: dependencies,
          from: from,
          argument: argument,
        );

  @override
  bool updateShouldNotify(State previousState, State newState) {
    return true;
  }
}

class _NotifierProvider<State>
    extends AlwaysAliveProviderBase<StateController<State>> {
  _NotifierProvider(
    this._create, {
    required String? name,
    required this.dependencies,
    required Family? from,
    required Object? argument,
  }) : super(name: name, from: from, argument: argument);

  final Create<State, StateProviderRef<State>> _create;

  @override
  final List<ProviderOrFamily>? dependencies;

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
  _NotifierStateProviderElement<State> createElement() {
    return _NotifierStateProviderElement(this);
  }
}

class _NotifierStateProviderElement<State>
    extends ProviderElementBase<StateController<State>>
    implements StateProviderRef<State> {
  _NotifierStateProviderElement(_NotifierProvider<State> provider)
      : super(provider);

  @override
  StateController<State> get controller => requireState;
}

/// {@macro riverpod.stateprovider.family}
@sealed
class StateProviderFamily<State, Arg>
    extends Family<State, Arg, StateProvider<State>> {
  /// {@macro riverpod.stateprovider.family}
  StateProviderFamily(
    this._create, {
    String? name,
    List<ProviderOrFamily>? dependencies,
  }) : super(name: name, dependencies: dependencies);

  final FamilyCreate<State, StateProviderRef<State>, Arg> _create;

  @override
  StateProvider<State> create(
    Arg argument,
  ) {
    return StateProvider<State>(
      (ref) => _create(ref, argument),
      name: name,
      from: this,
      argument: argument,
    );
  }

  @override
  void setupOverride(Arg argument, SetupOverride setup) {
    final provider = call(argument);
    setup(origin: provider.notifier, override: provider.notifier);
  }

  /// {@macro riverpod.overidewithprovider}
  Override overrideWithProvider(
    StateProvider<State> Function(Arg argument) override,
  ) {
    return FamilyOverride<Arg>(
      this,
      (arg, setup) {
        final provider = call(arg);
        final newProvider = override(arg);
        setup(origin: provider.notifier, override: newProvider.notifier);
      },
    );
  }
}
