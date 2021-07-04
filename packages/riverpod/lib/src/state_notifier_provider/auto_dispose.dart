part of '../state_notifier_provider.dart';

/// {@macro riverpod.providerrefbase}
typedef AutoDisposeStateNotifierProviderRef<
        Notifier extends StateNotifier<State>, State>
    = AutoDisposeProviderRefBase;

class _AutoDisposeNotifierProvider<Notifier extends StateNotifier<Object?>>
    extends AutoDisposeProviderBase<Notifier> {
  _AutoDisposeNotifierProvider(this._create, {required String? name})
      : super(name == null ? null : '$name.notifier');

  final Create<Notifier, AutoDisposeProviderRefBase> _create;

  @override
  Notifier create(AutoDisposeProviderRefBase ref) {
    final notifier = _create(ref);
    ref.onDispose(notifier.dispose);
    return notifier;
  }

  @override
  bool recreateShouldNotify(Notifier previousState, Notifier newState) {
    return true;
  }

  @override
  AutoDisposeProviderElement<Notifier> createElement() {
    return AutoDisposeProviderElement(this);
  }

  @override
  void setupOverride(SetupOverride setup) =>
      throw UnsupportedError('Cannot override StateNotifierProvider.notifier');
}

/// {@macro riverpod.statenotifierprovider}
@sealed
class AutoDisposeStateNotifierProvider<Notifier extends StateNotifier<State>,
        State> extends AutoDisposeProviderBase<State>
    with _StateNotifierProviderMixin<Notifier, State> {
  /// {@macro riverpod.statenotifierprovider}
  AutoDisposeStateNotifierProvider(this._create, {String? name}) : super(name);

  /// {@macro riverpod.family}
  static const family = AutoDisposeStateNotifierProviderFamilyBuilder();

  final Create<Notifier, AutoDisposeStateNotifierProviderRef<Notifier, State>>
      _create;

  /// {@template riverpod.statenotifierprovider.notifier}
  /// Obtains the [StateNotifier] associated with this [AutoDisposeStateNotifierProvider],
  /// without listening to it.
  ///
  /// Listening to this provider may cause providers/widgets to rebuild in the
  /// event that the [StateNotifier] it recreated.
  /// {@endtemplate}
  @override
  late final AutoDisposeProviderBase<Notifier> notifier =
      _AutoDisposeNotifierProvider(_create, name: name);

  @override
  State create(AutoDisposeProviderElementBase<State> ref) {
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
    AutoDisposeStateNotifierProvider<Notifier, State> provider,
  ) {
    return ProviderOverride((setup) {
      setup(origin: notifier, override: provider.notifier);
      setup(origin: this, override: this);
    });
  }

  @override
  AutoDisposeProviderElementBase<State> createElement() {
    return AutoDisposeProviderElement(this);
  }
}

/// {@template riverpod.statenotifierprovider.family}
/// A class that allows building a [AutoDisposeStateNotifierProvider] from an external parameter.
/// {@endtemplate}
@sealed
class AutoDisposeStateNotifierProviderFamily<
        Notifier extends StateNotifier<State>, State, Arg>
    extends Family<State, Arg,
        AutoDisposeStateNotifierProvider<Notifier, State>> {
  /// {@macro riverpod.statenotifierprovider.family}
  AutoDisposeStateNotifierProviderFamily(this._create, {String? name})
      : super(name);

  final FamilyCreate<Notifier,
      AutoDisposeStateNotifierProviderRef<Notifier, State>, Arg> _create;

  @override
  AutoDisposeStateNotifierProvider<Notifier, State> create(Arg argument) {
    final provider = AutoDisposeStateNotifierProvider<Notifier, State>(
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
    AutoDisposeStateNotifierProvider<Notifier, State> Function(Arg argument)
        override,
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
