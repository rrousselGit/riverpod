part of '../stream_provider.dart';

/// {@macro riverpod.provider_ref_base}
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
  }) : super(
          allTransitiveDependencies:
              computeAllTransitiveDependencies(dependencies),
          from: null,
          argument: null,
          debugGetCreateSourceHash: null,
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

  final Stream<T> Function(AutoDisposeStreamProviderRef<T> ref) _createFn;

  @override
  Stream<T> _create(AutoDisposeStreamProviderElement<T> ref) => _createFn(ref);

  @override
  AutoDisposeStreamProviderElement<T> createElement(
    ProviderContainer container,
  ) {
    return AutoDisposeStreamProviderElement(this, container);
  }

  @override
  late final Refreshable<Future<T>> future = _future(this);

  /// {@macro riverpod.override_with}
  Override overrideWith(
    Create<Stream<T>, AutoDisposeStreamProviderRef<T>> create,
  ) {
    return ProviderOverride(
      origin: this,
      providerOverride: AutoDisposeStreamProvider<T>.internal(
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
    with AutoDisposeProviderElementMixin<AsyncValue<T>>
    implements AutoDisposeStreamProviderRef<T> {
  /// The [ProviderElementBase] for [StreamProvider]
  AutoDisposeStreamProviderElement(
    AutoDisposeStreamProvider<T> super._provider,
    super.container,
  );
}

/// The [Family] of [AutoDisposeStreamProvider].
class AutoDisposeStreamProviderFamily<R, Arg> extends AutoDisposeFamilyBase<
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
