part of '../future_provider.dart';

/// {@macro riverpod.futureprovider}
class AutoDisposeFutureProvider<T>
    extends AutoDisposeProviderBase<Future<T>, AsyncValue<T>> {
  /// {@macro riverpod.futureprovider}
  AutoDisposeFutureProvider(
      Create<Future<T>, AutoDisposeProviderReference> create,
      {String name})
      : super(create, name);

  /// {@macro riverpod.family}
  static const family = AutoDisposeFutureProviderFamilyBuilder();

  @override
  _AutoDisposeFutureProviderState<T> createState() =>
      _AutoDisposeFutureProviderState();
}

class _AutoDisposeFutureProviderState<T> = ProviderStateBase<Future<T>,
    AsyncValue<T>> with _FutureProviderStateMixin<T>;

class AutoDisposeFutureProviderFamily<T, A> extends Family<
    Future<T>,
    AsyncValue<T>,
    A,
    AutoDisposeProviderReference,
    AutoDisposeFutureProvider<T>> {
  AutoDisposeFutureProviderFamily(
    Future<T> Function(AutoDisposeProviderReference ref, A a) create, {
    String name,
  }) : super(create, name);

  @override
  AutoDisposeFutureProvider<T> create(
    A value,
    Future<T> Function(AutoDisposeProviderReference ref, A param) builder,
  ) {
    return AutoDisposeFutureProvider((ref) => builder(ref, value), name: name);
  }
}
