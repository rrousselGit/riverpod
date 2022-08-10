part of '../provider.dart';

/// {@macro riverpod.providerrefbase}
/// - [controller], the [StateController] currently exposed by this provider.
abstract class AutoDisposeProviderRef<State> extends ProviderRef<State>
    implements AutoDisposeRef<State> {}

class AutoDisposeProvider<T> extends _ProviderBase<T> {
  AutoDisposeProvider(
    this._createFn, {
    super.name,
    super.from,
    super.argument,
    super.dependencies,
    super.cacheTime,
    super.disposeDelay,
  });

  final T Function(AutoDisposeProviderRef<T> ref) _createFn;

  @override
  T _create(AutoDisposeProviderElement<T> ref) => _createFn(ref);

  @override
  AutoDisposeProviderElement<T> createElement() {
    return AutoDisposeProviderElement(this);
  }
}

class AutoDisposeProviderElement<T> = ProviderElement<T>
    with AutoDisposeProviderElementMixin<T>
    implements AutoDisposeProviderRef<T>;

class AutoDisposeProviderFamily<R, Arg> extends AutoDisposeFamilyBase<
    AutoDisposeProviderRef<R>, R, Arg, R, AutoDisposeProvider<R>> {
  AutoDisposeProviderFamily(
    super.create, {
    super.name,
    super.dependencies,
    super.cacheTime,
    super.disposeDelay,
  }) : super(providerFactory: AutoDisposeProvider.new);
}
