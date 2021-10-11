part of '../future_provider.dart';

/// {@macro riverpod.providerrefbase}
/// - [ProviderRef.state], the value currently exposed by this providers.
typedef AutoDisposeFutureProviderRef<State> = AutoDisposeProviderRefBase;

/// {@macro riverpod.futureprovider}
@sealed
class AutoDisposeFutureProvider<State> extends AutoDisposeAsyncProvider<State>
    with AutoDisposeOverrideWithValueMixin<AsyncValue<State>> {
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

  @override
  ProviderBase<AsyncValue<State>> get originProvider => this;

  /// {@macro riverpod.futureprovider.future}
  late final AutoDisposeProviderBase<Future<State>> future =
      AutoDisposeAsyncValueAsFutureProvider(
    this,
    name: modifierName(name, 'future'),
  );

  @override
  AsyncValue<State> create(
    AutoDisposeProviderElementBase<AsyncValue<State>> ref,
  ) {
    return _listenFuture(() => _create(ref), ref);
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

  /// Overrides the behavior of a family for a part of the application.
  ///
  /// {@macro riverpod.overideWith}
  Override overrideWithProvider(
    AutoDisposeProviderBase<AsyncValue<State>> Function(Arg argument) override,
  ) {
    return FamilyOverride<Arg>(this, (arg, setup) {
      final futureProvider = call(arg);
      setup(origin: futureProvider, override: override(arg));
      setup(origin: futureProvider.future, override: futureProvider.future);
    });
  }

  @override
  void setupOverride(Arg argument, SetupOverride setup) {
    final futureProvider = call(argument);
    setup(origin: futureProvider, override: futureProvider);
    setup(origin: futureProvider.future, override: futureProvider.future);
  }
}
