part of '../stream_provider.dart';

/// {@macro riverpod.providerrefbase}
/// - [ProviderRef.state], the value currently exposed by this providers.
typedef StreamProviderRef<State> = ProviderRefBase;

/// {@macro riverpod.streamprovider}
@sealed
class StreamProvider<State> extends AsyncProvider<State>
    with
        _StreamProviderMixin<State>,
        AlwaysAliveOverrideWithValueMixin<AsyncValue<State>> {
  /// {@macro riverpod.streamprovider}
  StreamProvider(
    this._create, {
    String? name,
    this.dependencies,
  }) : super(name: name);

  /// {@macro riverpod.family}
  static const family = StreamProviderFamilyBuilder();

  /// {@macro riverpod.autoDispose}
  static const autoDispose = AutoDisposeStreamProviderBuilder();

  final Create<Stream<State>, StreamProviderRef<State>> _create;

  @override
  final List<ProviderOrFamily>? dependencies;

  @override
  ProviderBase<AsyncValue<State>> get originProvider => this;

  @override
  late final AlwaysAliveProviderBase<Stream<State>> stream =
      AsyncValueAsStreamProvider(this, name: modifierName(name, 'stream'));

  @override
  late final AlwaysAliveProviderBase<Future<State>> last =
      AsyncValueAsFutureProvider(this, name: modifierName(name, 'last'));

  @override
  AsyncValue<State> create(ProviderElementBase<AsyncValue<State>> ref) {
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
  AsyncProviderElement<State> createElement() => AsyncProviderElement(this);
}

/// {@template riverpod.streamprovider.family}
/// A class that allows building a [StreamProvider] from an external parameter.
/// {@endtemplate}
@sealed
class StreamProviderFamily<State, Arg>
    extends Family<AsyncValue<State>, Arg, StreamProvider<State>> {
  /// {@macro riverpod.streamprovider.family}
  StreamProviderFamily(
    this._create, {
    String? name,
    List<ProviderOrFamily>? dependencies,
  }) : super(name: name, dependencies: dependencies);

  final FamilyCreate<Stream<State>, StreamProviderRef<State>, Arg> _create;

  @override
  StreamProvider<State> create(Arg argument) {
    final provider = StreamProvider<State>(
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

  /// Overrides the behavior of a family for a part of the application.
  ///
  /// {@macro riverpod.overideWith}
  Override overrideWithProvider(
    ProviderBase<AsyncValue<State>> Function(Arg argument) override,
  ) {
    return FamilyOverride<Arg>(this, (arg, setup) {
      final provider = call(arg);
      setup(origin: provider, override: override(arg));
      setup(origin: provider.stream, override: provider.stream);
      setup(origin: provider.last, override: provider.last);
    });
  }
}
