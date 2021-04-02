part of '../provider.dart';

/// {@macro riverpod.provider}
@sealed
class Provider<T> extends AlwaysAliveProviderBase<T, T>
    with ProviderOverridesMixin<T, T> {
  /// {@macro riverpod.provider}
  Provider(
    this._create, {
    String? name,
  }) : super(name);

  /// {@macro riverpod.family}
  static const family = ProviderFamilyBuilder();

  /// {@macro riverpod.autoDispose}
  static const autoDispose = AutoDisposeProviderBuilder();

  final Create<T, ProviderReference> _create;

  @override
  T create(ProviderReference ref) => _create(ref);

  @override
  _ProviderState<T> createState() => _ProviderState();
}

@sealed
class _ProviderState<T> = ProviderStateBase<T, T> with _ProviderStateMixin<T>;

/// {@template riverpod.provider.family}
/// A class that allows building a [Provider] from an external parameter.
/// {@endtemplate}
@sealed
class ProviderFamily<T, A>
    extends Family<T, T, A, ProviderReference, Provider<T>> {
  /// {@macro riverpod.provider.family}
  ProviderFamily(
    T Function(ProviderReference ref, A a) create, {
    String? name,
  }) : super(create, name);

  @override
  Provider<T> create(
    A value,
    T Function(ProviderReference ref, A param) builder,
    String? name,
  ) {
    return Provider((ref) => builder(ref, value), name: name);
  }
}
