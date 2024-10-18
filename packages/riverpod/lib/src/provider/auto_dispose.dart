part of '../provider.dart';

/// {@macro riverpod.provider_ref_base}
@Deprecated('will be removed in 3.0.0. Use Ref instead')
abstract class AutoDisposeProviderRef<State> extends ProviderRef<State>
    implements AutoDisposeRef<State> {}

/// {@macro riverpod.provider}
class AutoDisposeProvider<T> extends InternalProvider<T> {
  /// {@macro riverpod.provider}
  AutoDisposeProvider(
    this._createFn, {
    super.name,
    super.dependencies,
    @Deprecated('Will be removed in 3.0.0') super.from,
    @Deprecated('Will be removed in 3.0.0') super.argument,
    @Deprecated('Will be removed in 3.0.0') super.debugGetCreateSourceHash,
  }) : super(
          allTransitiveDependencies:
              computeAllTransitiveDependencies(dependencies),
        );

  /// An implementation detail of Riverpod
  @internal
  const AutoDisposeProvider.internal(
    this._createFn, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    super.from,
    super.argument,
  });

  /// {@macro riverpod.family}
  static const family = AutoDisposeProviderFamily.new;

  // ignore: deprecated_member_use_from_same_package
  final T Function(AutoDisposeProviderRef<T> ref) _createFn;

  @override
  T _create(AutoDisposeProviderElement<T> ref) => _createFn(ref);

  @override
  AutoDisposeProviderElement<T> createElement() {
    return AutoDisposeProviderElement(this);
  }

  /// {@macro riverpod.override_with}
  Override overrideWith(
    // ignore: deprecated_member_use_from_same_package
    Create<T, AutoDisposeProviderRef<T>> create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AutoDisposeProvider<T>.internal(
        create,
        from: from,
        argument: argument,
        allTransitiveDependencies: null,
        dependencies: null,
        debugGetCreateSourceHash: null,
        name: null,
      ),
    );
  }
}

/// The element of [AutoDisposeProvider]
class AutoDisposeProviderElement<T> extends ProviderElement<T>
    with
        AutoDisposeProviderElementMixin<T>
    implements
        // ignore: deprecated_member_use_from_same_package
        AutoDisposeProviderRef<T> {
  /// The [ProviderElementBase] for [Provider]
  @internal
  AutoDisposeProviderElement(AutoDisposeProvider<T> super._provider);
}

/// The [Family] of [AutoDisposeProvider]
class AutoDisposeProviderFamily<R, Arg> extends AutoDisposeFamilyBase<
    // ignore: deprecated_member_use_from_same_package
    AutoDisposeProviderRef<R>,
    R,
    Arg,
    R,
    AutoDisposeProvider<R>> {
  /// The [Family] of [AutoDisposeProvider]
  AutoDisposeProviderFamily(
    super._createFn, {
    super.name,
    super.dependencies,
  }) : super(
          providerFactory: AutoDisposeProvider.internal,
          allTransitiveDependencies:
              computeAllTransitiveDependencies(dependencies),
          debugGetCreateSourceHash: null,
        );

  /// {@macro riverpod.override_with}
  Override overrideWith(
    // ignore: deprecated_member_use_from_same_package
    R Function(AutoDisposeProviderRef<R> ref, Arg arg) create,
  ) {
    return FamilyOverrideImpl<R, Arg, AutoDisposeProvider<R>>(
      this,
      (arg) => AutoDisposeProvider<R>.internal(
        (ref) => create(ref, arg),
        from: from,
        argument: arg,
        name: null,
        debugGetCreateSourceHash: null,
        dependencies: null,
        allTransitiveDependencies: null,
      ),
    );
  }
}
