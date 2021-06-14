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
  /// final configsProvider = FutureProvider((ref, state, setState) async => Configs());
  ///
  /// final productsProvider = FutureProvider((ref, state, setState) async {
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
    return FutureProvider(
      (ref) => _create(ref, argument),
      name: name,
    );
  }
}
