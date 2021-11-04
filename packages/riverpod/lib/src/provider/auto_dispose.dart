part of '../provider.dart';

/// {@macro riverpod.providerrefbase}
/// - [state], the value currently exposed by this providers.
abstract class AutoDisposeProviderRef<State>
    implements ProviderRef<State>, AutoDisposeRef {}

/// {@macro riverpod.provider}
@sealed
class AutoDisposeProvider<State> extends AutoDisposeProviderBase<State>
    with
        OverrideWithValueMixin<State>,
        OverrideWithProviderMixin<State, AutoDisposeProviderBase<State>> {
  /// {@macro riverpod.provider}
  AutoDisposeProvider(
    this._create, {
    String? name,
    this.dependencies,
    Family? from,
    Object? argument,
  }) : super(name: name, from: from, argument: argument);

  /// {@macro riverpod.family}
  static const family = AutoDisposeProviderFamilyBuilder();

  @override
  ProviderBase<State> get originProvider => this;

  final Create<State, AutoDisposeProviderRef<State>> _create;

  @override
  final List<ProviderOrFamily>? dependencies;

  @override
  State create(AutoDisposeProviderRef<State> ref) => _create(ref);

  @override
  bool updateShouldNotify(State previousState, State newState) {
    return previousState != newState;
  }

  @override
  AutoDisposeProviderElement<State> createElement() {
    return AutoDisposeProviderElement(this);
  }
}

/// An [AutoDisposeProviderElementBase] for [AutoDisposeProvider]
class AutoDisposeProviderElement<State>
    extends AutoDisposeProviderElementBase<State>
    implements AutoDisposeProviderRef<State> {
  /// An [AutoDisposeProviderElementBase] for [AutoDisposeProvider]
  AutoDisposeProviderElement(ProviderBase<State> provider) : super(provider);

  @override
  State get state => requireState;

  @override
  set state(State newState) => setState(newState);
}

/// {@macro riverpod.provider.family}
@sealed
class AutoDisposeProviderFamily<State, Arg>
    extends Family<State, Arg, AutoDisposeProvider<State>> {
  /// {@macro riverpod.provider.family}
  AutoDisposeProviderFamily(
    this._create, {
    String? name,
    List<ProviderOrFamily>? dependencies,
  }) : super(name: name, dependencies: dependencies);

  final FamilyCreate<State, AutoDisposeProviderRef<State>, Arg> _create;

  @override
  AutoDisposeProvider<State> create(Arg argument) {
    return AutoDisposeProvider<State>(
      (ref) => _create(ref, argument),
      name: name,
      from: this,
      argument: argument,
    );
  }
}
