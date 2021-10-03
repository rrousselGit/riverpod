part of '../stream_provider.dart';

/// {@macro riverpod.providerrefbase}
/// - [ProviderRef.state], the value currently exposed by this providers.
typedef AutoDisposeStreamProviderRef<State> = AutoDisposeProviderRefBase;

/// {@macro riverpod.streamprovider}
@sealed
class AutoDisposeStreamProvider<State> extends AutoDisposeAsyncProvider<State>
    with
        AutoDisposeProviderOverridesMixin<AsyncValue<State>>,
        _StreamProviderMixin<State> {
  /// {@macro riverpod.streamprovider}
  AutoDisposeStreamProvider(this._create, {String? name}) : super(name);

  /// {@macro riverpod.family}
  static const family = AutoDisposeStreamProviderFamilyBuilder();

  final Create<Stream<State>, AutoDisposeStreamProviderRef<State>> _create;

  @override
  late final AutoDisposeProviderBase<Stream<State>> stream =
      AutoDisposeAsyncValueAsStreamProvider(this, modifierName(name, 'stream'));

  @override
  late final AutoDisposeProviderBase<Future<State>> last =
      AutoDisposeAsyncValueAsFutureProvider(this, modifierName(name, 'last'));

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
  Override overrideWithProvider(
    AutoDisposeProviderBase<AsyncValue<State>> provider,
  ) {
    return ProviderOverride((setup) {
      setup(origin: this, override: provider);
      setup(origin: stream, override: stream);
      setup(origin: last, override: last);
    });
  }

  @override
  Override overrideWithValue(AsyncValue<State> value) {
    return ProviderOverride((setup) {
      setup(origin: this, override: ValueProvider<AsyncValue<State>>(value));
      setup(origin: stream, override: stream);
      setup(origin: last, override: last);
    });
  }

  @override
  void setupOverride(SetupOverride setup) {
    setup(origin: this, override: this);
    setup(origin: stream, override: stream);
    setup(origin: last, override: last);
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
  AutoDisposeStreamProviderFamily(this._create, {String? name}) : super(name);

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

  /// Overrides the behavior of a family for a part of the application.
  ///
  /// {@macro riverpod.overideWith}
  Override overrideWithProvider(
    AutoDisposeProviderBase<AsyncValue<State>> Function(Arg argument) override,
  ) {
    return FamilyOverride<Arg>(this, (arg, setup) {
      final provider = call(arg);
      setup(origin: provider, override: override(arg));
      setup(origin: provider.stream, override: provider.stream);
      setup(origin: provider.last, override: provider.last);
    });
  }
}
