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

  /// {@macro riverpod.overridewith}
  Override overrideWith(
    Create<T, AutoDisposeProviderRef<T>> create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AutoDisposeProvider<T>(
        create,
        from: from,
        argument: argument,
      ),
    );
  }
}

/// The element of [AutoDisposeProvider]
class AutoDisposeProviderElement<T> extends ProviderElement<T>
    with AutoDisposeProviderElementMixin<T>
    implements AutoDisposeProviderRef<T> {
  /// The [ProviderElementBase] for [Provider]
  AutoDisposeProviderElement._(AutoDisposeProvider<T> super.provider)
      : super._();
}

/// The [Family] of [AutoDisposeProvider]
class AutoDisposeProviderFamily<R, Arg> extends AutoDisposeFamilyBase<
    AutoDisposeProviderRef<R>, R, Arg, R, AutoDisposeProvider<R>> {
  /// The [Family] of [AutoDisposeProvider]
  AutoDisposeProviderFamily(
    super.create, {
    super.name,
    super.dependencies,
  }) : super(providerFactory: AutoDisposeProvider.new);

  /// {@macro riverpod.overridewith}
  Override overrideWith(
    R Function(AutoDisposeProviderRef<R> ref, Arg arg) create,
  ) {
    return FamilyOverrideImpl<R, Arg, AutoDisposeProvider<R>>(
      this,
      (arg) => AutoDisposeProvider<R>(
        (ref) => create(ref, arg),
        from: from,
        argument: arg,
      ),
    );
  }
}
