part of '../state_provider.dart';

/// {@macro riverpod.providerrefbase}
/// - [controller], the [StateController] currently exposed by this provider.
abstract class StateProviderRef<State> implements Ref<StateController<State>> {
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
  })  : notifier = _StateProviderNotifier(
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
      _StateProviderState(
    this,
    dependencies: [notifier],
    from: from,
    argument: argument,
    name: modifierName(name, 'state'),
  );

  /// {@template riverpod.stateprovider.notifier}
  /// Obtains the [StateController] associated with this provider, but without
  /// listening to it.
  ///
  /// Listening to this provider may cause providers/widgets to rebuild in the
  /// event that the [StateController] it recreated.
  ///
  ///
  /// It is preferable to do:
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
  StateProviderElement<State> createElement() => StateProviderElement(this);
}

/// The [ProviderElementBase] for [StateProvider]
class StateProviderElement<State> extends ProviderElementBase<State> {
  /// The [ProviderElementBase] for [StateProvider]
  StateProviderElement(this.provider);

  @override
  final StateProvider<State> provider;

  @override
  State create() {
    final notifier = watch(provider.notifier);

    final removeListener = notifier.addListener(setState);
    onDispose(removeListener);

    return notifier.state;
  }

  @override
  bool updateShouldNotify(State previousState, State newState) {
    return true;
  }
}

class _StateProviderState<State>
    extends AlwaysAliveProviderBase<StateController<State>> {
  _StateProviderState(
    this._origin, {
    required this.dependencies,
    required super.from,
    required super.argument,
    required super.name,
  });

  final StateProvider<State> _origin;

  @override
  final List<ProviderOrFamily>? dependencies;

  @override
  _StateProviderStateElement<State> createElement() {
    return _StateProviderStateElement(this);
  }
}

class _StateProviderStateElement<State>
    extends ProviderElementBase<StateController<State>> {
  _StateProviderStateElement(this.provider);

  @override
  final _StateProviderState<State> provider;

  @override
  StateController<State> create() {
    return _listenStateProvider(
      this,
      watch(provider._origin.notifier),
    );
  }

  @override
  bool updateShouldNotify(
    StateController<State> previousState,
    StateController<State> newState,
  ) {
    return true;
  }
}

class _StateProviderNotifier<State>
    extends AlwaysAliveProviderBase<StateController<State>> {
  _StateProviderNotifier(
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
  _StateProviderNotifierElement<State> createElement() {
    return _StateProviderNotifierElement(this);
  }
}

class _StateProviderNotifierElement<State>
    extends ProviderElementBase<StateController<State>>
    implements StateProviderRef<State> {
  _StateProviderNotifierElement(this.provider);

  @override
  final _StateProviderNotifier<State> provider;

  @override
  StateController<State> get controller => requireState;

  @override
  StateController<State> create() {
    final initialState = provider._create(this);
    final notifier = StateController(initialState);
    onDispose(notifier.dispose);
    return notifier;
  }

  @override
  bool updateShouldNotify(
    StateController<State> previousState,
    StateController<State> newState,
  ) {
    return true;
  }
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
