part of '../provider.dart';

/// {@macro riverpod.provider}
@sealed
class Provider<T> extends AlwaysAliveProviderBase<T, T> {
  /// {@macro riverpod.provider}
  Provider(
    Create<T, T, ProviderReference<T>> create, {
    String? name,
  }) : super(create, name);

  /// {@macro riverpod.family}
  static const family = ProviderFamilyBuilder();

  /// {@macro riverpod.autoDispose}
  static const autoDispose = AutoDisposeProviderBuilder();

  @override
  ProviderOverride overrideWithProvider(RootProvider<Object?, T> provider) {
    return ProviderOverride(provider, this);
  }

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
    extends Family<T, T, A, ProviderReference<T>, Provider<T>> {
  /// {@macro riverpod.provider.family}
  ProviderFamily(
    T Function(ProviderReference<T> ref, A a) create, {
    String? name,
  }) : super(create, name);

  @override
  Provider<T> create(
    A value,
    T Function(ProviderReference<T> ref, A param) builder,
    String? name,
  ) {
    return Provider((ref) => builder(ref, value), name: name);
  }
}
