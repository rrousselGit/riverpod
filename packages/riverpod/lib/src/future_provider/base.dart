part of '../future_provider.dart';

/// {@macro riverpod.futureprovider}
@sealed
class FutureProvider<T>
    extends AlwaysAliveProviderBase<Future<T>, AsyncValue<T>>
    with
        ProviderOverridesMixin<Future<T>, AsyncValue<T>>,
        _FutureProviderMixin<T> {
  /// {@macro riverpod.futureprovider}
  FutureProvider(this._create, {String? name}) : super(name);

  final Create<Future<T>, ProviderReference> _create;

  @override
  Future<T> create(covariant ProviderReference ref) => _create(ref);

  /// {@macro riverpod.family}
  static const family = FutureProviderFamilyBuilder();

  /// {@macro riverpod.autoDispose}
  static const autoDispose = AutoDisposeFutureProviderBuilder();

  AlwaysAliveProviderBase<Future<T>, Future<T>>? _future;

  /// {@template riverpod.futureprovider.future}
  /// A provider that exposes the [Future] created by a [FutureProvider].
  ///
  /// The instance of [Future] obtained may change over time, if the provider
  /// was recreated (such as when using [ProviderReference.watch]).
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
  AlwaysAliveProviderBase<Future<T>, Future<T>> get future {
    return _future ??= CreatedProvider(
      this,
      name: name == null ? null : '$name.future',
    );
  }

  @override
  _FutureProviderState<T> createState() => _FutureProviderState();
}

@sealed
class _FutureProviderState<T> = ProviderStateBase<Future<T>, AsyncValue<T>>
    with _FutureProviderStateMixin<T>;

/// {@template riverpod.futureprovider.family}
/// A class that allows building a [FutureProvider] from an external parameter.
/// {@endtemplate}
@sealed
class FutureProviderFamily<T, A> extends Family<Future<T>, AsyncValue<T>, A,
    ProviderReference, FutureProvider<T>> {
  /// {@macro riverpod.futureprovider.family}
  FutureProviderFamily(
    Future<T> Function(ProviderReference ref, A a) create, {
    String? name,
  }) : super(create, name);

  @override
  FutureProvider<T> create(
    A value,
    Future<T> Function(ProviderReference ref, A param) builder,
    String? name,
  ) {
    return FutureProvider((ref) => builder(ref, value), name: name);
  }
}
