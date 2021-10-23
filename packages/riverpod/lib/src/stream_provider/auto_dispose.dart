part of '../stream_provider.dart';

/// {@macro riverpod.providerrefbase}
/// - [ProviderRef.state], the value currently exposed by this providers.
abstract class AutoDisposeStreamProviderRef<State> implements AutoDisposeRef {
  /// Obtains the state currently exposed by this provider.
  ///
  /// Mutating this property will notify the provider listeners.
  ///
  /// Cannot be called while a provider is creating, unless the setter was called first.
  ///
  /// Will throw if the provider threw during creation.
  AsyncValue<State> get state;
  set state(AsyncValue<State> newState);
}

/// {@macro riverpod.streamprovider}
@sealed
class AutoDisposeStreamProvider<State> extends AutoDisposeAsyncProvider<State>
    with
        _StreamProviderMixin<State>,
        OverrideWithValueMixin<AsyncValue<State>>,
        OverrideWithProviderMixin<AsyncValue<State>,
            AutoDisposeProviderBase<AsyncValue<State>>> {
  /// {@macro riverpod.streamprovider}
  AutoDisposeStreamProvider(
    this._create, {
    String? name,
    this.dependencies,
  }) : super(name: name);

  /// {@macro riverpod.family}
  static const family = AutoDisposeStreamProviderFamilyBuilder();

  @override
  ProviderBase<AsyncValue<State>> get originProvider => this;

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
    covariant AutoDisposeStreamProviderElement<State> ref,
  ) {
    return ref._listenStream(() => _create(ref));
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
  AutoDisposeStreamProviderElement<State> createElement() {
    return AutoDisposeStreamProviderElement(this);
  }
}

/// The Element of a [AutoDisposeStreamProvider]
class AutoDisposeStreamProviderElement<State>
    extends AutoDisposeAsyncProviderElement<State>
    with _StreamProviderElementMixin<State>
    implements AutoDisposeStreamProviderRef<State> {
  /// The Element of a [AutoDisposeStreamProvider]
  AutoDisposeStreamProviderElement(AutoDisposeStreamProvider<State> provider)
      : super(provider);

  @override
  AsyncValue<State> get state => requireState;

  @override
  set state(AsyncValue<State> newState) {
    assert(
      newState is AsyncData ||
          (newState is AsyncLoading &&
              (newState as AsyncLoading).previous == null) ||
          (newState is AsyncError && (newState as AsyncError).previous == null),
      'Cannot specify "previous" for AsyncValue but got $newState',
    );
    setState(newState);
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

  /// {@macro riverpod.overridewithprovider}
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
