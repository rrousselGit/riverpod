part of '../stream_provider.dart';

/// {@macro riverpod.provider_ref_base}
@Deprecated('will be removed in 3.0.0. Use Ref instead')
abstract class AutoDisposeStreamProviderRef<State>
    extends StreamProviderRef<State>
    implements AutoDisposeRef<AsyncValue<State>> {}

/// {@macro riverpod.stream_provider}
class AutoDisposeStreamProvider<T> extends _StreamProviderBase<T>
    with AsyncSelector<T> {
  /// {@macro riverpod.stream_provider}
  AutoDisposeStreamProvider(
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
  AutoDisposeStreamProvider.internal(
    this._createFn, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    super.from,
    super.argument,
  });

  /// {@macro riverpod.family}
  static const family = AutoDisposeStreamProviderFamily.new;

  // ignore: deprecated_member_use_from_same_package
  final Stream<T> Function(AutoDisposeStreamProviderRef<T> ref) _createFn;

  @override
  Stream<T> _create(AutoDisposeStreamProviderElement<T> ref) => _createFn(ref);

  @override
  AutoDisposeStreamProviderElement<T> createElement() {
    return AutoDisposeStreamProviderElement(this);
  }

  @override
  late final Refreshable<Future<T>> future = _future(this);

  @Deprecated(
    '.stream will be removed in 3.0.0. As a replacement, either listen to the '
    'provider itself (AsyncValue) or .future.',
  )
  @override
  late final Refreshable<Stream<T>> stream = _stream(this);

  /// {@macro riverpod.override_with}
  Override overrideWith(
    // ignore: deprecated_member_use_from_same_package
    Create<Stream<T>, AutoDisposeStreamProviderRef<T>> create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AutoDisposeStreamProvider<T>.internal(
        create,
        from: from,
        argument: argument,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        name: null,
      ),
    );
  }
}

/// The element of [AutoDisposeStreamProvider].
class AutoDisposeStreamProviderElement<T> extends StreamProviderElement<T>
    with
        AutoDisposeProviderElementMixin<AsyncValue<T>>
    implements
        // ignore: deprecated_member_use_from_same_package
        AutoDisposeStreamProviderRef<T> {
  /// The [ProviderElementBase] for [StreamProvider]
  AutoDisposeStreamProviderElement(
    AutoDisposeStreamProvider<T> super._provider,
  );
}

/// The [Family] of [AutoDisposeStreamProvider].
class AutoDisposeStreamProviderFamily<R, Arg> extends AutoDisposeFamilyBase<
    // ignore: deprecated_member_use_from_same_package
    AutoDisposeStreamProviderRef<R>,
    AsyncValue<R>,
    Arg,
    Stream<R>,
    AutoDisposeStreamProvider<R>> {
  /// The [Family] of [AutoDisposeStreamProvider].
  AutoDisposeStreamProviderFamily(
    super._createFn, {
    super.name,
    super.dependencies,
  }) : super(
          providerFactory: AutoDisposeStreamProvider.internal,
          allTransitiveDependencies:
              computeAllTransitiveDependencies(dependencies),
          debugGetCreateSourceHash: null,
        );

  /// {@macro riverpod.override_with}
  Override overrideWith(
    // ignore: deprecated_member_use_from_same_package
    Stream<R> Function(AutoDisposeStreamProviderRef<R> ref, Arg arg) create,
  ) {
    return FamilyOverrideImpl<AsyncValue<R>, Arg, AutoDisposeStreamProvider<R>>(
      this,
      (arg) => AutoDisposeStreamProvider<R>.internal(
        (ref) => create(ref, arg),
        from: from,
        argument: arg,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        name: null,
      ),
    );
  }
}
