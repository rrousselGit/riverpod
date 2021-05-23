part of '../provider.dart';

/// {@macro riverpod.providerrefbase}
/// - [state], the value currently exposed by this providers.
abstract class ProviderRef<State> implements ProviderRefBase {
  /// Obtains the state currently exposed by this provider.
  ///
  /// Mutating this property will notify the provider listeners.
  ///
  /// Cannot be called while a provider is creating, unless the setter was called first.
  State get state;
  set state(State newState);
}

/// A [ProviderElementBase] for [Provider]
class ProviderElement<State> extends ProviderElementBase<State>
    implements ProviderRef<State> {
  /// A [ProviderElementBase] for [Provider]
  ProviderElement(ProviderBase<State> provider) : super(provider);
}

/// {@macro riverpod.provider}
@sealed
class Provider<State> extends AlwaysAliveProviderBase<State>
    with ProviderOverridesMixin<State> {
  /// {@macro riverpod.provider}
  Provider(this._create, {String? name}) : super(name);

  /// {@macro riverpod.family}
  static const family = ProviderFamilyBuilder();

  /// {@macro riverpod.autoDispose}
  static const autoDispose = AutoDisposeProviderBuilder();

  final Create<State, ProviderRef<State>> _create;

  @override
  State create(ProviderRef<State> ref) => _create(ref);

  @override
  bool recreateShouldNotify(State previousState, State newState) {
    return previousState != newState;
  }

  @override
  ProviderElement<State> createElement() => ProviderElement(this);
}

/// {@template riverpod.provider.family}
/// A class that allows building a [Provider] from an external parameter.
/// {@endtemplate}
@sealed
class ProviderFamily<State, Arg> extends Family<State, Arg, Provider<State>> {
  /// {@macro riverpod.provider.family}
  ProviderFamily(this._create, {String? name}) : super(name);

  final FamilyCreate<State, ProviderRef<State>, Arg> _create;

  @override
  Provider<State> create(Arg argument) {
    return Provider(
      (ref) => _create(ref, argument),
      name: name,
    );
  }
}
