part of '../state_notifier_provider.dart';

/// {@macro riverpod.providerrefbase}
abstract class StateNotifierProviderRef<Notifier extends StateNotifier<State>,
    State> implements Ref<Notifier> {
  /// The [StateNotifier] currently exposed by this provider.
  ///
  /// Cannot be accessed while creating the provider.
  Notifier get notifier;
}

/// {@macro riverpod.statenotifierprovider}
@sealed
class StateNotifierProvider<Notifier extends StateNotifier<State>, State>
    extends AlwaysAliveProviderBase<State>
    with
        StateNotifierProviderOverrideMixin<Notifier, State>,
        OverrideWithProviderMixin<Notifier,
            StateNotifierProvider<Notifier, State>> {
  /// {@macro riverpod.statenotifierprovider}
  StateNotifierProvider(
    Create<Notifier, StateNotifierProviderRef<Notifier, State>> create, {
    String? name,
    List<ProviderOrFamily>? dependencies,
    Family? from,
    Object? argument,
  })  : notifier = _NotifierProvider(
          create,
          name: name,
          dependencies: dependencies,
          from: from,
          argument: argument,
        ),
        super(name: name, from: from, argument: argument);

  /// {@macro riverpod.family}
  static const family = StateNotifierProviderFamilyBuilder();

  /// {@macro riverpod.autoDispose}
  static const autoDispose = AutoDisposeStateNotifierProviderBuilder();

  /// {@template riverpod.statenotifierprovider.notifier}
  /// Obtains the [StateNotifier] associated with this [StateNotifierProvider],
  /// without listening to it.
  ///
  /// Listening to this provider may cause providers/widgets to rebuild in the
  /// event that the [StateNotifier] it recreated.
  /// {@endtemplate}
  @override
  final AlwaysAliveProviderBase<Notifier> notifier;

  @override
  bool updateShouldNotify(State previousState, State newState) {
    return true;
  }

  @override
  StateNotifierProviderElement<Notifier, State> createElement() =>
      StateNotifierProviderElement(this);
}

/// The element of a [StateNotifierProvider]
class StateNotifierProviderElement<Notifier extends StateNotifier<State>, State>
    extends ProviderElementBase<State> {
  /// The element of a [StateNotifierProvider]
  StateNotifierProviderElement(this.provider);

  @override
  final StateNotifierProvider<Notifier, State> provider;

  @override
  State create() {
    final notifier = watch(provider.notifier);

    void listener(State newState) {
      setState(newState);
    }

    final removeListener = notifier.addListener(listener);
    onDispose(removeListener);

    return requireState;
  }
}

class _NotifierProvider<Notifier extends StateNotifier<State>, State>
    extends AlwaysAliveProviderBase<Notifier> {
  _NotifierProvider(
    this._create, {
    required String? name,
    required this.dependencies,
    Family? from,
    Object? argument,
  }) : super(
          name: name == null ? null : '$name.notifier',
          from: from,
          argument: argument,
        );

  final Create<Notifier, StateNotifierProviderRef<Notifier, State>> _create;

  @override
  final List<ProviderOrFamily>? dependencies;

  @override
  bool updateShouldNotify(Notifier previousState, Notifier newState) => true;

  @override
  _NotifierProviderElement<Notifier, State> createElement() {
    return _NotifierProviderElement(this);
  }
}

class _NotifierProviderElement<Notifier extends StateNotifier<State>, State>
    extends ProviderElementBase<Notifier>
    implements StateNotifierProviderRef<Notifier, State> {
  _NotifierProviderElement(this.provider);

  @override
  final _NotifierProvider<Notifier, State> provider;

  @override
  Notifier get notifier => requireState;

  @override
  Notifier create() {
    final notifier = provider._create(this);
    onDispose(notifier.dispose);
    return notifier;
  }
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
    return StateNotifierProvider<Notifier, State>(
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

  /// {@macro riverpod.overridewithprovider}
  Override overrideWithProvider(
    StateNotifierProvider<Notifier, State> Function(Arg argument) override,
  ) {
    return FamilyOverride<Arg>(
      this,
      (arg, setup) {
        final provider = call(arg);
        setup(origin: provider.notifier, override: override(arg).notifier);
      },
    );
  }
}
