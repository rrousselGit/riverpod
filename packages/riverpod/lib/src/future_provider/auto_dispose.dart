part of '../future_provider.dart';

/// {@macro riverpod.providerrefbase}
/// - [FutureProviderRef.state], the value currently exposed by this provider.
abstract class AutoDisposeFutureProviderRef<State>
    extends FutureProviderRef<State>
    implements AutoDisposeRef<AsyncValue<State>> {}

/// {@macro riverpod.futureprovider}
class AutoDisposeFutureProvider<T> extends _FutureProviderBase<T>
    with AsyncSelector<T> {
  /// {@macro riverpod.futureprovider}
  AutoDisposeFutureProvider(
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
  AutoDisposeFutureProvider.internal(
    this._createFn, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    super.from,
    super.argument,
  });

  /// {@macro riverpod.family}
  static const family = AutoDisposeFutureProviderFamily.new;

  final Create<FutureOr<T>, AutoDisposeFutureProviderRef<T>> _createFn;

  @override
  FutureOr<T> _create(AutoDisposeFutureProviderElement<T> ref) =>
      _createFn(ref);

  @override
  AutoDisposeFutureProviderElement<T> createElement() {
    return AutoDisposeFutureProviderElement._(this);
  }

  @override
  late final Refreshable<Future<T>> future = _future(this);

  /// {@macro riverpod.overridewith}
  Override overrideWith(
    Create<FutureOr<T>, AutoDisposeFutureProviderRef<T>> create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AutoDisposeFutureProvider.internal(
        create,
        from: from,
        argument: argument,
        debugGetCreateSourceHash: null,
        dependencies: null,
        allTransitiveDependencies: null,
        name: null,
      ),
    );
  }
}

/// The [ProviderElementBase] of [AutoDisposeFutureProvider]
class AutoDisposeFutureProviderElement<T> extends FutureProviderElement<T>
    with AutoDisposeProviderElementMixin<AsyncValue<T>>
    implements AutoDisposeFutureProviderRef<T> {
  /// The [ProviderElementBase] for [FutureProvider]
  AutoDisposeFutureProviderElement._(
    AutoDisposeFutureProvider<T> super._provider,
  ) : super._();
}

/// The [Family] of an [AutoDisposeFutureProvider]
class AutoDisposeFutureProviderFamily<R, Arg> extends AutoDisposeFamilyBase<
    AutoDisposeFutureProviderRef<R>,
    AsyncValue<R>,
    Arg,
    FutureOr<R>,
    AutoDisposeFutureProvider<R>> {
  /// The [Family] of an [AutoDisposeFutureProvider]
  AutoDisposeFutureProviderFamily(
    super._createFn, {
    super.name,
    super.dependencies,
  }) : super(
          providerFactory: AutoDisposeFutureProvider.internal,
          allTransitiveDependencies:
              computeAllTransitiveDependencies(dependencies),
          debugGetCreateSourceHash: null,
        );

  /// Implementation detail of the code-generator.
  @internal
  AutoDisposeFutureProviderFamily.generator(
    super._createFn, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
  }) : super(providerFactory: AutoDisposeFutureProvider<R>.internal);

  /// {@macro riverpod.overridewith}
  Override overrideWith(
    FutureOr<R> Function(AutoDisposeFutureProviderRef<R> ref, Arg arg) create,
  ) {
    return FamilyOverrideImpl<AsyncValue<R>, Arg, AutoDisposeFutureProvider<R>>(
      this,
      (arg) => AutoDisposeFutureProvider<R>.internal(
        (ref) => create(ref, arg),
        from: from,
        argument: arg,
        debugGetCreateSourceHash: null,
        dependencies: null,
        allTransitiveDependencies: null,
        name: null,
      ),
    );
  }
}
