part of '../provider.dart';

/// {@macro riverpod.providerrefbase}
/// - [state], the value currently exposed by this providers.
abstract class AutoDisposeProviderRef<State>
    implements ProviderRef<State>, AutoDisposeProviderRefBase {}

/// An [AutoDisposeProviderElementBase] for [AutoDisposeProvider]
class AutoDisposeProviderElement<State>
    extends AutoDisposeProviderElementBase<State>
    implements AutoDisposeProviderRef<State> {
  /// An [AutoDisposeProviderElementBase] for [AutoDisposeProvider]
  AutoDisposeProviderElement(ProviderBase<State> provider) : super(provider);

  bool _debugDidSetValue = false;

  @override
  State get state {
    assert(() {
      if (!_debugDidSetValue) {
        throw StateError(
          'Cannot read the state exposed by a provider within '
          'before it was set',
        );
      }
      return true;
    }(), '');

    return getState() as State;
  }

  @override
  set state(State newState) {
    setState(newState);
  }

  @override
  void setState(State newState) {
    assert(() {
      _debugDidSetValue = true;
      return true;
    }(), '');
    super.setState(newState);
  }

  @override
  void debugWillRebuildState() {
    _debugDidSetValue = false;
  }
}

/// {@macro riverpod.provider}
@sealed
class AutoDisposeProvider<State> extends AutoDisposeProviderBase<State>
    with AutoDisposeOverrideWithValueMixin<State> {
  /// {@macro riverpod.provider}
  AutoDisposeProvider(
    this._create, {
    String? name,
    this.dependencies,
  }) : super(name: name);

  /// {@macro riverpod.family}
  static const family = AutoDisposeProviderFamilyBuilder();

  final Create<State, AutoDisposeProviderRef<State>> _create;

  @override
  ProviderBase<State> get originProvider => this;

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
    );
  }
}
