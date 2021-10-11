part of '../state_notifier_provider.dart';

class _NotifierProvider<Notifier extends StateNotifier<Object?>>
    extends AlwaysAliveProviderBase<Notifier> {
  _NotifierProvider(
    this._create, {
    required String? name,
    required this.dependencies,
  }) : super(
          name: name == null ? null : '$name.notifier',
        );

  final Create<Notifier, ProviderRefBase> _create;

  @override
  final List<ProviderOrFamily>? dependencies;

  @override
  ProviderBase<Notifier> get originProvider => this;

  @override
  Notifier create(ProviderRefBase ref) {
    final notifier = _create(ref);
    ref.onDispose(notifier.dispose);
    return notifier;
  }

  @override
  bool updateShouldNotify(Notifier previousState, Notifier newState) {
    return true;
  }

  @override
  ProviderElement<Notifier> createElement() => ProviderElement(this);
}

/// {@macro riverpod.providerrefbase}
typedef StateNotifierProviderRef<Notifier extends StateNotifier<State>, State>
    = ProviderRefBase;

/// {@macro riverpod.statenotifierprovider}
@sealed
class StateNotifierProvider<Notifier extends StateNotifier<State>, State>
    extends AlwaysAliveProviderBase<State> {
  /// {@macro riverpod.statenotifierprovider}
  StateNotifierProvider(
    Create<Notifier, StateNotifierProviderRef<Notifier, State>> create, {
    String? name,
    List<ProviderOrFamily>? dependencies,
  })  : notifier = _NotifierProvider(
          create,
          name: name,
          dependencies: dependencies,
        ),
        super(name: name);

  /// {@macro riverpod.family}
  static const family = StateNotifierProviderFamilyBuilder();

  /// {@macro riverpod.autoDispose}
  static const autoDispose = AutoDisposeStateNotifierProviderBuilder();

  @override
  late final List<ProviderOrFamily>? dependencies = [notifier];

  @override
  ProviderBase get originProvider => notifier;

  /// {@template riverpod.statenotifierprovider.notifier}
  /// Obtains the [StateNotifier] associated with this [StateNotifierProvider],
  /// without listening to it.
  ///
  /// Listening to this provider may cause providers/widgets to rebuild in the
  /// event that the [StateNotifier] it recreated.
  /// {@endtemplate}
  final AlwaysAliveProviderBase<Notifier> notifier;

  /// {@macro riverpod.overrridewithvalue}
  Override overrideWithValue(Notifier value) {
    return ProviderOverride(
      origin: notifier,
      override: ValueProvider<Notifier>(value),
    );
  }

  /// {@macro riverpod.overrridewithprovider}
  Override overrideWithProvider(
    StateNotifierProvider<Notifier, State> provider,
  ) {
    return ProviderOverride(
      origin: notifier,
      override: provider.notifier,
    );
  }

  @override
  State create(ProviderElementBase<State> ref) {
    final notifier = ref.watch(this.notifier);

    void listener(State newState) {
      ref.setState(newState);
    }

    final removeListener = notifier.addListener(listener);
    ref.onDispose(removeListener);

    return ref.getState() as State;
  }

  @override
  bool updateShouldNotify(State previousState, State newState) {
    return true;
  }

  @override
  ProviderElementBase<State> createElement() => ProviderElement(this);
}

/// {@template riverpod.statenotifierprovider.family}
/// A class that allows building a [StateNotifierProvider] from an external parameter.
/// {@endtemplate}
@sealed
class StateNotifierProviderFamily<Notifier extends StateNotifier<State>, State,
    Arg> extends Family<State, Arg, StateNotifierProvider<Notifier, State>> {
  /// {@macro riverpod.statenotifierprovider.family}
  StateNotifierProviderFamily(
    this._create, {
    String? name,
    List<ProviderOrFamily>? dependencies,
  }) : super(name: name, dependencies: dependencies);

  final FamilyCreate<Notifier, StateNotifierProviderRef<Notifier, State>, Arg>
      _create;

  @override
  StateNotifierProvider<Notifier, State> create(
    Arg argument,
  ) {
    final provider = StateNotifierProvider<Notifier, State>(
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
    StateNotifierProvider<Notifier, State> Function(Arg argument) override,
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
