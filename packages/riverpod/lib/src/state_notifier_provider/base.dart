part of '../state_notifier_provider.dart';

class _NotifierProvider<Notifier extends StateNotifier<Object?>>
    extends AlwaysAliveProviderBase<Notifier> {
  _NotifierProvider(this._create, {required String? name})
      : super(name == null ? null : '$name.notifier');

  final Create<Notifier, ProviderRefBase> _create;

  @override
  Notifier create(ProviderRefBase ref) {
    final notifier = _create(ref);
    ref.onDispose(notifier.dispose);
    return notifier;
  }

  @override
  bool recreateShouldNotify(Notifier previousState, Notifier newState) {
    return true;
  }

  @override
  ProviderElement<Notifier> createElement() => ProviderElement(this);

  @override
  void setupOverride(SetupOverride setup) =>
      throw UnsupportedError('Cannot override StateNotifierProvider.notifier');
}

/// {@macro riverpod.providerrefbase}
typedef StateNotifierProviderRef<Notifier extends StateNotifier<State>, State>
    = ProviderRefBase;

/// {@macro riverpod.statenotifierprovider}
@sealed
class StateNotifierProvider<Notifier extends StateNotifier<State>, State>
    extends AlwaysAliveProviderBase<State>
    with _StateNotifierProviderMixin<Notifier, State> {
  /// {@macro riverpod.statenotifierprovider}
  StateNotifierProvider(this._create, {String? name}) : super(name);

  /// {@macro riverpod.family}
  static const family = StateNotifierProviderFamilyBuilder();

  /// {@macro riverpod.autoDispose}
  static const autoDispose = AutoDisposeStateNotifierProviderBuilder();

  final Create<Notifier, StateNotifierProviderRef<Notifier, State>> _create;

  /// {@template riverpod.statenotifierprovider.notifier}
  /// Obtains the [StateNotifier] associated with this [StateNotifierProvider],
  /// without listening to it.
  ///
  /// Listening to this provider may cause providers/widgets to rebuild in the
  /// event that the [StateNotifier] it recreated.
  /// {@endtemplate}
  @override
  late final AlwaysAliveProviderBase<Notifier> notifier =
      _NotifierProvider(_create, name: name);

  @override
  State create(ProviderElementBase<State> ref) {
    final notifier = ref.watch(this.notifier);

    void listener(State newState) {
      ref.state = newState;
    }

    final removeListener = notifier.addListener(listener);
    ref.onDispose(removeListener);

    return ref.state;
  }

  @override
  bool recreateShouldNotify(State previousState, State newState) {
    return true;
  }

  /// Overrides the behavior of a provider with a another provider.
  ///
  /// {@macro riverpod.overideWith}
  Override overrideWithProvider(
    StateNotifierProvider<Notifier, State> provider,
  ) {
    return ProviderOverride((setup) {
      setup(origin: notifier, override: provider.notifier);
      setup(origin: this, override: this);
    });
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
  StateNotifierProviderFamily(this._create, {String? name}) : super(name);

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
