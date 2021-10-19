part of '../stream_provider.dart';

/// {@macro riverpod.providerrefbase}
/// - [ProviderRef.state], the value currently exposed by this providers.
typedef AutoDisposeStreamProviderRef<State> = AutoDisposeRef;

/// {@macro riverpod.streamprovider}
@sealed
class AutoDisposeStreamProvider<State> extends AutoDisposeAsyncProvider<State>
    with
        _StreamProviderMixin<State>,
        OverrideWithValueMixin<AsyncValue<State>> {
  /// {@macro riverpod.streamprovider}
  AutoDisposeStreamProvider(
    this._create, {
    String? name,
    this.dependencies,
  }) : super(name: name);

  /// {@macro riverpod.family}
  static const family = AutoDisposeStreamProviderFamilyBuilder();

  final Create<Stream<State>, AutoDisposeStreamProviderRef<State>> _create;

  @override
  final List<ProviderOrFamily>? dependencies;

  @override
  late final AutoDisposeProviderBase<Stream<State>> stream =
      AutoDisposeAsyncValueAsStreamProvider(
    this,
    name: modifierName(name, 'stream'),
  );

  @override
  late final AutoDisposeProviderBase<Future<State>> last =
      AutoDisposeAsyncValueAsFutureProvider(
    this,
    name: modifierName(name, 'last'),
  );

  @override
  AsyncValue<State> create(
    AutoDisposeProviderElementBase<AsyncValue<State>> ref,
  ) {
    return _listenStream(() => _create(ref), ref);
  }

  @override
  bool updateShouldNotify(
    AsyncValue<State> previousState,
    AsyncValue<State> newState,
  ) {
    final wasLoading = previousState is AsyncLoading;
    final isLoading = newState is AsyncLoading;

    if (wasLoading || isLoading) return wasLoading != isLoading;

    return true;
  }

  @override
  AutoDisposeAsyncProviderElement<State> createElement() {
    return AutoDisposeAsyncProviderElement(this);
  }
}

/// {@macro riverpod.streamprovider.family}
@sealed
class AutoDisposeStreamProviderFamily<State, Arg>
    extends Family<AsyncValue<State>, Arg, AutoDisposeStreamProvider<State>> {
  /// {@macro riverpod.streamprovider.family}
  AutoDisposeStreamProviderFamily(
    this._create, {
    String? name,
    List<ProviderOrFamily>? dependencies,
  }) : super(name: name, dependencies: dependencies);

  final FamilyCreate<Stream<State>, AutoDisposeStreamProviderRef<State>, Arg>
      _create;

  @override
  AutoDisposeStreamProvider<State> create(Arg argument) {
    final provider = AutoDisposeStreamProvider<State>(
      (ref) => _create(ref, argument),
      name: name,
    );

    registerProvider(provider.stream, argument);
    registerProvider(provider.last, argument);

    return provider;
  }

  @override
  void setupOverride(Arg argument, SetupOverride setup) {
    final provider = call(argument);
    setup(origin: provider, override: provider);
    setup(origin: provider.stream, override: provider.stream);
    setup(origin: provider.last, override: provider.last);
  }
}
