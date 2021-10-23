part of '../state_notifier_provider.dart';

/// {@macro riverpod.providerrefbase}
abstract class StateNotifierProviderRef<Notifier extends StateNotifier<State>,
    State> implements Ref {
  /// The [StateNotifier] currently exposed by this provider.
  ///
  /// Cannot be accessed while creating the provider.
  Notifier get notifier;
}

/// {@macro riverpod.statenotifierprovider}
@sealed
class StateNotifierProvider<Notifier extends StateNotifier<State>, State>
    extends AlwaysAliveProviderBase<State>
    with StateNotifierProviderOverrideMixin<Notifier, State> {
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
  State create(ProviderElementBase<State> ref) {
    final notifier = ref.watch(this.notifier);

    void listener(State newState) {
      ref.setState(newState);
    }

    final removeListener = notifier.addListener(listener);
    ref.onDispose(removeListener);

    return ref.requireState;
  }

  @override
  bool updateShouldNotify(State previousState, State newState) {
    return true;
  }

  @override
  ProviderElementBase<State> createElement() => ProviderElement(this);
}

class _NotifierProvider<Notifier extends StateNotifier<State>, State>
    extends AlwaysAliveProviderBase<Notifier> {
  _NotifierProvider(
    this._create, {
    required String? name,
    required this.dependencies,
  }) : super(
          name: name == null ? null : '$name.notifier',
        );

  final Create<Notifier, StateNotifierProviderRef<Notifier, State>> _create;

  @override
  final List<ProviderOrFamily>? dependencies;

  @override
  Notifier create(
    covariant StateNotifierProviderRef<Notifier, State> ref,
  ) {
    final notifier = _create(ref);
    ref.onDispose(notifier.dispose);
    return notifier;
  }

  @override
  bool updateShouldNotify(Notifier previousState, Notifier newState) {
    return true;
  }

  @override
  _NotifierProviderElement<Notifier, State> createElement() =>
      _NotifierProviderElement(this);
}

class _NotifierProviderElement<Notifier extends StateNotifier<State>, State>
    extends ProviderElementBase<Notifier>
    implements StateNotifierProviderRef<Notifier, State> {
  _NotifierProviderElement(
    _NotifierProvider<Notifier, State> provider,
  ) : super(provider);

  @override
  Notifier get notifier => requireState;
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

  @override
  void setupOverride(Arg argument, SetupOverride setup) {
    final provider = call(argument);
    setup(origin: provider, override: provider);
    setup(origin: provider.notifier, override: provider.notifier);
  }
}
