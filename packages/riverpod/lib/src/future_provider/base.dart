part of '../future_provider.dart';

/// {@macro riverpod.providerrefbase}
/// - [ProviderRef.state], the value currently exposed by this providers.
typedef FutureProviderRef<State> = ProviderRef<AsyncValue<State>>;

/// {@macro riverpod.futureprovider}
@sealed
class FutureProvider<State> extends AlwaysAliveProviderBase<AsyncValue<State>>
    with ProviderOverridesMixin<AsyncValue<State>> {
  /// {@macro riverpod.futureprovider}
  FutureProvider(this._create, {String? name}) : super(name);

  /// {@macro riverpod.family}
  static const family = FutureProviderFamilyBuilder();

  /// {@macro riverpod.autoDispose}
  static const autoDispose = AutoDisposeFutureProviderBuilder();

  final Create<Future<State>, FutureProviderRef<State>> _create;

  /// {@template riverpod.futureprovider.future}
  /// A provider that exposes the [Future] created by a [FutureProvider].
  ///
  /// The instance of [Future] obtained may change over time, if the provider
  /// was recreated (such as when using [ProviderRefBase.watch]).
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
      AsyncValueAsFutureProvider(this, modifierName(name, 'future'));

  @override
  AsyncValue<State> create(FutureProviderRef<State> ref) {
    return _listenFuture(() => _create(ref), ref);
  }

  @override
  void setupOverride(SetupOverride setup) {
    setup(origin: this, override: this);
    setup(origin: future, override: future);
  }

  @override
  Override overrideWithProvider(
    AlwaysAliveProviderBase<AsyncValue<State>> provider,
  ) {
    return ProviderOverride((setup) {
      setup(origin: future, override: future);
      setup(origin: this, override: provider);
    });
  }

  @override
  Override overrideWithValue(AsyncValue<State> value) {
    return ProviderOverride((setup) {
      setup(origin: future, override: future);
      setup(origin: this, override: ValueProvider<AsyncValue<State>>(value));
    });
  }

  @override
  bool recreateShouldNotify(
    AsyncValue<State> previousState,
    AsyncValue<State> newState,
  ) {
    return true;
  }

  @override
  ProviderElement<AsyncValue<State>> createElement() => ProviderElement(this);
}

/// {@template riverpod.futureprovider.family}
/// A class that allows building a [FutureProvider] from an external parameter.
/// {@endtemplate}
@sealed
class FutureProviderFamily<State, Arg>
    extends Family<AsyncValue<State>, Arg, FutureProvider<State>> {
  /// {@macro riverpod.futureprovider.family}
  FutureProviderFamily(this._create, {String? name}) : super(name);

  final FamilyCreate<Future<State>, FutureProviderRef<State>, Arg> _create;

  @override
  FutureProvider<State> create(Arg argument) {
    final provider = FutureProvider<State>(
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

  /// Overrides the behavior of a family for a part of the application.
  ///
  /// {@macro riverpod.overideWith}
  Override overrideWithProvider(
    ProviderBase<AsyncValue<State>> Function(Arg argument) override,
  ) {
    return FamilyOverride<Arg>(this, (arg, setup) {
      final futureProvider = call(arg);
      setup(origin: futureProvider, override: override(arg));
      setup(origin: futureProvider.future, override: futureProvider.future);
    });
  }
}
