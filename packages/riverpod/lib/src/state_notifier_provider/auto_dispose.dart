part of '../state_notifier_provider.dart';

/// {@macro riverpod.providerrefbase}
typedef AutoDisposeStateNotifierProviderRef<
        Notifier extends StateNotifier<State>, State>
    = AutoDisposeProviderRefBase;

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

  /// Overrides the behavior of a provider with a another provider.
  ///
  /// {@macro riverpod.overideWith}
  Override overrideWithProvider(
    AutoDisposeStateNotifierProvider<Notifier, State> provider,
  ) {
    return ProviderOverride(provider.notifier, notifier);
  }

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
}

/// An extension that adds [overrideWithProvider] to [Family].
extension XAutoDisposeStateNotifierFamily<
    Notifier extends StateNotifier<State>,
    State,
    Arg> on AutoDisposeStateNotifierProviderFamily<Notifier, State, Arg> {
  /// Overrides the behavior of a family for a part of the application.
  ///
  /// {@macro riverpod.overideWith}
  Override overrideWithProvider(
    AutoDisposeProviderBase<Notifier> Function(Arg argument) override,
  ) {
    return FamilyOverride(
      this,
      (arg, provider) {
        if (provider is _AutoDisposeNotifierProvider<Notifier>) {
          return override(arg as Arg);
        }
        return provider;
      },
    );
  }
}
