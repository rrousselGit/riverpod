part of '../stream_provider.dart';

/// {@macro riverpod.providerrefbase}
/// - [ProviderRef.state], the value currently exposed by this providers.
abstract class StreamProviderRef<State> implements Ref {
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
class StreamProvider<State> extends AsyncProvider<State>
    with
        _StreamProviderMixin<State>,
        OverrideWithValueMixin<AsyncValue<State>> {
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
  late final AlwaysAliveProviderBase<Stream<State>> stream =
      AsyncValueAsStreamProvider(this, name: modifierName(name, 'stream'));

  @override
  late final AlwaysAliveProviderBase<Future<State>> last =
      AsyncValueAsFutureProvider(this, name: modifierName(name, 'last'));

  @override
  AsyncValue<State> create(covariant StreamProviderRef<State> ref) {
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
  StreamProviderElement<State> createElement() => StreamProviderElement(this);
}

/// The Element of a [StreamProvider]
class StreamProviderElement<State> extends AsyncProviderElement<State>
    with _StreamProviderElementMixin<State>
    implements StreamProviderRef<State> {
  /// The Element of a [StreamProvider]
  StreamProviderElement(StreamProvider<State> provider) : super(provider);

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
}
