part of '../provider.dart';

/// {@macro riverpod.provider}
class AutoDisposeProvider<T> extends AutoDisposeProviderBase<T, T> {
  /// {@macro riverpod.provider}
  AutoDisposeProvider(
    Create<T, AutoDisposeProviderReference> create, {
    String name,
  }) : super(create, name);

  /// {@macro riverpod.family}
  static const family = AutoDisposeProviderFamilyBuilder();

  @override
  ProviderOverride overrideAsProvider(ProviderBase<Object, T> provider) {
    return ProviderOverride(provider, this);
  }

  @override
  _AutoDisposeProviderState<T> createState() => _AutoDisposeProviderState();
}

/// The internal state of a [Provider].
class _AutoDisposeProviderState<T> = ProviderStateBase<T, T>
    with _ProviderStateMixin<T>;

class AutoDisposeProviderFamily<T, A> extends Family<T, T, A,
    AutoDisposeProviderReference, AutoDisposeProvider<T>> {
  AutoDisposeProviderFamily(
    T Function(AutoDisposeProviderReference ref, A a) create, {
    String name,
  }) : super(create, name);

  @override
  AutoDisposeProvider<T> create(
    A value,
    T Function(AutoDisposeProviderReference ref, A param) builder,
  ) {
    return AutoDisposeProvider((ref) => builder(ref, value), name: name);
  }
}
