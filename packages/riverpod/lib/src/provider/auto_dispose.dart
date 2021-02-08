part of '../provider.dart';

/// {@macro riverpod.provider}
@sealed
class AutoDisposeProvider<T> extends AutoDisposeProviderBase<T, T> {
  /// {@macro riverpod.provider}
  AutoDisposeProvider(
    Create<T, T, AutoDisposeProviderReferenceAdvanced<T>> create, {
    String? name,
  }) : super(create, name);

  /// {@macro riverpod.family}
  static const family = AutoDisposeProviderFamilyBuilder();

  @override
  ProviderOverride overrideWithProvider(RootProvider<Object?, T> provider) {
    return ProviderOverride(provider, this);
  }

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
    AutoDisposeProviderReference<T>, AutoDisposeProvider<T>> {
  /// {@macro riverpod.provider.family}
  AutoDisposeProviderFamily(
    T Function(AutoDisposeProviderReferenceAdvanced<T> ref, A a) create, {
    String? name,
  }) : super(
            (ref, a) =>
                create(ref as AutoDisposeProviderReferenceAdvanced<T>, a),
            name);

  @override
  AutoDisposeProvider<T> create(
    A value,
    T Function(AutoDisposeProviderReference<T> ref, A param) builder,
    String? name,
  ) {
    return AutoDisposeProvider<T>((ref) => builder(ref, value), name: name);
  }
}
