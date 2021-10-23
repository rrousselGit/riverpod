part of '../future_provider.dart';

/// {@macro riverpod.providerrefbase}
/// - [ProviderRef.state], the value currently exposed by this providers.
abstract class AutoDisposeFutureProviderRef<State> implements AutoDisposeRef {
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

/// {@macro riverpod.futureprovider}
@sealed
class AutoDisposeFutureProvider<State> extends AutoDisposeAsyncProvider<State>
    with OverrideWithValueMixin<AsyncValue<State>> {
  /// {@macro riverpod.futureprovider}
  AutoDisposeFutureProvider(
    this._create, {
    String? name,
    this.dependencies,
  }) : super(name: name);

  /// {@macro riverpod.family}
  static const family = AutoDisposeFutureProviderFamilyBuilder();

  final Create<FutureOr<State>, AutoDisposeFutureProviderRef<State>> _create;

  @override
  final List<ProviderOrFamily>? dependencies;

  /// {@macro riverpod.futureprovider.future}
  late final AutoDisposeProviderBase<Future<State>> future =
      AutoDisposeAsyncValueAsFutureProvider(
    this,
    name: modifierName(name, 'future'),
  );

  @override
  AsyncValue<State> create(
    covariant AutoDisposeFutureProviderRef<State> ref,
  ) {
    return ref._listenFuture(() => _create(ref));
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
  AutoDisposeFutureProviderElement<State> createElement() {
    return AutoDisposeFutureProviderElement(this);
  }
}

/// The element of a [AutoDisposeFutureProvider]
class AutoDisposeFutureProviderElement<State>
    extends AutoDisposeAsyncProviderElement<State>
    with _FutureProviderElementMixin<State>
    implements AutoDisposeFutureProviderRef<State> {
  /// The element of a [AutoDisposeFutureProvider]
  AutoDisposeFutureProviderElement(AutoDisposeFutureProvider<State> provider)
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

/// {@template riverpod.futureprovider.family}
/// A class that allows building a [AutoDisposeFutureProvider] from an external parameter.
/// {@endtemplate}
@sealed
class AutoDisposeFutureProviderFamily<State, Arg>
    extends Family<AsyncValue<State>, Arg, AutoDisposeFutureProvider<State>> {
  /// {@macro riverpod.futureprovider.family}
  AutoDisposeFutureProviderFamily(
    this._create, {
    String? name,
    List<ProviderOrFamily>? dependencies,
  }) : super(name: name, dependencies: dependencies);

  final FamilyCreate<FutureOr<State>, AutoDisposeFutureProviderRef<State>, Arg>
      _create;

  @override
  AutoDisposeFutureProvider<State> create(Arg argument) {
    final provider = AutoDisposeFutureProvider<State>(
      (ref) => _create(ref, argument),
      name: name,
    );

    registerProvider(provider.future, argument);

    return provider;
  }

  @override
  void setupOverride(Arg argument, SetupOverride setup) {
    final futureProvider = call(argument);
    setup(origin: futureProvider, override: futureProvider);
    setup(origin: futureProvider.future, override: futureProvider.future);
  }
}
