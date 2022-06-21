part of '../provider.dart';

/// {@macro riverpod.providerrefbase}
/// - [state], the value currently exposed by this provider.
abstract class AutoDisposeProviderRef<State>
    implements ProviderRef<State>, AutoDisposeRef<State> {}

/// {@macro riverpod.provider}
@sealed
class AutoDisposeProvider<State> extends AutoDisposeProviderBase<State>
    with
        OverrideWithValueMixin<State>,
        OverrideWithProviderMixin<State, AutoDisposeProviderBase<State>> {
  /// {@macro riverpod.provider}
  AutoDisposeProvider(
    this._create, {
    super.name,
    this.dependencies,
    super.from,
    super.argument,
    super.cacheTime,
    super.disposeDelay,
  });

  /// {@macro riverpod.family}
  static const family = AutoDisposeProviderFamilyBuilder();

  @override
  ProviderBase<State> get originProvider => this;

  final Create<State, AutoDisposeProviderRef<State>> _create;

  @override
  final List<ProviderOrFamily>? dependencies;

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
  AutoDisposeProviderElement(this.provider);

  @override
  final AutoDisposeProvider<State> provider;

  @override
  State get state => requireState;

  @override
  set state(State newState) => setState(newState);

  @override
  State create() => provider._create(this);

  @override
  bool updateShouldNotify(State previousState, State newState) {
    return previousState != newState;
  }
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
    Duration? cacheTime,
    Duration? disposeDelay,
  }) : super(
          name: name,
          dependencies: dependencies,
          cacheTime: cacheTime,
          disposeDelay: disposeDelay,
        );

  final FamilyCreate<State, AutoDisposeProviderRef<State>, Arg> _create;

  @override
  AutoDisposeProvider<State> create(Arg argument) {
    return AutoDisposeProvider<State>(
      (ref) => _create(ref, argument),
      name: name,
      from: this,
      argument: argument,
      cacheTime: cacheTime,
      disposeDelay: disposeDelay,
    );
  }
}
