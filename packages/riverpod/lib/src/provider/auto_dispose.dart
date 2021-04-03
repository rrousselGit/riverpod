part of '../provider.dart';

/// {@macro riverpod.provider}
@sealed
class AutoDisposeProvider<T> extends AutoDisposeProviderBase<T, T>
    with AutoDisposeProviderOverridesMixin<T, T> {
  /// {@macro riverpod.provider}
  AutoDisposeProvider(this._create, {String? name}) : super(name);

  /// {@macro riverpod.family}
  static const family = AutoDisposeProviderFamilyBuilder();

  final Create<T, AutoDisposeProviderReference> _create;

  @override
  T create(covariant AutoDisposeProviderReference ref) => _create(ref);

  @override
  _AutoDisposeProviderState<T> createState() => _AutoDisposeProviderState();
}

/// The internal state of a [Provider].
@sealed
class _AutoDisposeProviderState<T> = ProviderStateBase<T, T>
    with _ProviderStateMixin<T>;

/// {@macro riverpod.provider.family}
@sealed
class AutoDisposeProviderFamily<T, A> extends Family<T, T, A,
    AutoDisposeProviderReference, AutoDisposeProvider<T>> {
  /// {@macro riverpod.provider.family}
  AutoDisposeProviderFamily(
    T Function(AutoDisposeProviderReference ref, A a) create, {
    String? name,
  }) : super(create, name);

  @override
  AutoDisposeProvider<T> create(
    A value,
    T Function(AutoDisposeProviderReference ref, A param) builder,
    String? name,
  ) {
    return AutoDisposeProvider((ref) => builder(ref, value), name: name);
  }
}
