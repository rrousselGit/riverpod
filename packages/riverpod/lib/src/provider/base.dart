part of '../provider.dart';

/// {@macro riverpod.provider}
class Provider<T> extends AlwaysAliveProviderBase<T, T> {
  /// {@macro riverpod.provider}
  Provider(
    Create<T, ProviderReference> create, {
    String name,
  }) : super(create, name);

  /// {@macro riverpod.family}
  static const family = ProviderFamilyBuilder();

  /// {@macro riverpod.autoDispose}
  static const autoDispose = AutoDisposeProviderBuilder();

  @override
  _ProviderState<T> createState() => _ProviderState();
}

class _ProviderState<T> = ProviderStateBase<T, T> with _ProviderStateMixin<T>;

class ProviderFamily<T, A>
    extends Family<T, T, A, ProviderReference, Provider<T>> {
  ProviderFamily(
    T Function(ProviderReference ref, A a) create, {
    String name,
  }) : super(create, name);

  @override
  Provider<T> create(
    A value,
    T Function(ProviderReference ref, A param) builder,
  ) {
    return Provider((ref) => builder(ref, value), name: name);
  }
}
