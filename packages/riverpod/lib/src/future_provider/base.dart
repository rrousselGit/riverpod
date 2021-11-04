part of '../future_provider.dart';

/// {@macro riverpod.providerrefbase}
/// - [ProviderRef.state], the value currently exposed by this providers.
abstract class FutureProviderRef<State> implements Ref {
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
class FutureProvider<State> extends AlwaysAliveProviderBase<AsyncValue<State>>
    with
        OverrideWithValueMixin<AsyncValue<State>>,
        OverrideWithProviderMixin<AsyncValue<State>,
            AlwaysAliveProviderBase<AsyncValue<State>>> {
  /// {@macro riverpod.futureprovider}
  FutureProvider(
    this._create, {
    String? name,
    this.dependencies,
    Family? from,
    Object? argument,
  }) : super(name: name, from: from, argument: argument);

  /// {@macro riverpod.family}
  static const family = FutureProviderFamilyBuilder();

  /// {@macro riverpod.autoDispose}
  static const autoDispose = AutoDisposeFutureProviderBuilder();

  @override
  ProviderBase<AsyncValue<State>> get originProvider => this;

  @override
  final List<ProviderOrFamily>? dependencies;

  final Create<FutureOr<State>, FutureProviderRef<State>> _create;

  /// {@template riverpod.futureprovider.future}
  /// A provider that exposes the [Future] created by a [FutureProvider].
  ///
  /// The instance of [Future] obtained may change over time, if the provider
  /// was recreated (such as when using [Ref.watch]).
  ///
  /// This provider allows using `async`/`await` to easily combine
  /// [FutureProvider] together:
  ///
  /// ```dart
  /// final configsProvider = FutureProvider((ref) async => Configs());
  ///
  /// final productsProvider = FutureProvider((ref) async {
  ///   // Wait for the configurations to resolve
  ///   final configs = await ref.watch(configsProvider.future);
  ///
  ///   // Do something with the result
  ///   return await http.get('${configs.host}/products');
  /// });
  /// ```
  /// {@endtemplate}
  late final AlwaysAliveProviderBase<Future<State>> future =
      AsyncValueAsFutureProvider(this, from: from, argument: argument);

  @override
  AsyncValue<State> create(
    covariant FutureProviderElement<State> ref,
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
  FutureProviderElement<State> createElement() => FutureProviderElement(this);
}

/// The element of a [FutureProvider]
class FutureProviderElement<State>
    extends ProviderElementBase<AsyncValue<State>>
    with _FutureProviderElementMixin<State>
    implements FutureProviderRef<State> {
  /// The element of a [FutureProvider]
  FutureProviderElement(FutureProvider<State> provider) : super(provider);

  @override
  AsyncValue<State> get state => requireState;

  @override
  set state(AsyncValue<State> newState) => setState(newState);
}

/// {@template riverpod.futureprovider.family}
/// A class that allows building a [FutureProvider] from an external parameter.
/// {@endtemplate}
@sealed
class FutureProviderFamily<State, Arg>
    extends Family<AsyncValue<State>, Arg, FutureProvider<State>> {
  /// {@macro riverpod.futureprovider.family}
  FutureProviderFamily(
    this._create, {
    String? name,
    List<ProviderOrFamily>? dependencies,
  }) : super(name: name, dependencies: dependencies);

  final FamilyCreate<FutureOr<State>, FutureProviderRef<State>, Arg> _create;

  @override
  FutureProvider<State> create(Arg argument) {
    return FutureProvider<State>(
      (ref) => _create(ref, argument),
      name: name,
      from: this,
      argument: argument,
    );
  }

  @override
  void setupOverride(Arg argument, SetupOverride setup) {
    final futureProvider = call(argument);
    setup(origin: futureProvider, override: futureProvider);
  }

  /// {@macro riverpod.overridewithprovider}
  Override overrideWithProvider(
    AlwaysAliveProviderBase<AsyncValue<State>> Function(Arg argument) override,
  ) {
    return FamilyOverride<Arg>(this, (arg, setup) {
      final futureProvider = call(arg);
      setup(origin: futureProvider, override: override(arg));
    });
  }
}
