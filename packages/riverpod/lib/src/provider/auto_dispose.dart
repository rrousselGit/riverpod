part of '../provider.dart';

/// {@macro riverpod.providerrefbase}
abstract class AutoDisposeProviderRef<State> extends ProviderRef<State>
    implements AutoDisposeRef<State> {}

/// {@macro riverpod.provider}
class AutoDisposeProvider<T> extends InternalProvider<T> {
  /// {@macro riverpod.provider}
  AutoDisposeProvider(
    this._createFn, {
    super.name,
    super.from,
    super.argument,
    super.dependencies,
    super.debugGetCreateSourceHash,
  });

  /// {@macro riverpod.family}
  static const family = AutoDisposeProviderFamily.new;

  final T Function(AutoDisposeProviderRef<T> ref) _createFn;

  @override
  T _create(AutoDisposeProviderElement<T> ref) => _createFn(ref);

  @override
  AutoDisposeProviderElement<T> createElement() {
    return AutoDisposeProviderElement._(this);
  }
}

/// The element of [AutoDisposeProvider]
class AutoDisposeProviderElement<T> = ProviderElement<T>
    with AutoDisposeProviderElementMixin<T>
    implements AutoDisposeProviderRef<T>;

/// The [Family] of [AutoDisposeProvider]
class AutoDisposeProviderFamily<R, Arg> extends AutoDisposeFamilyBase<
    AutoDisposeProviderRef<R>, R, Arg, R, AutoDisposeProvider<R>> {
  /// The [Family] of [AutoDisposeProvider]
  AutoDisposeProviderFamily(
    super.create, {
    super.name,
    super.dependencies,
  }) : super(providerFactory: AutoDisposeProvider.new);
}
