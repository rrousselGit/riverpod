part of '../future_provider.dart';

/// {@macro riverpod.provider_ref_base}
/// - [state], the value currently exposed by this provider.
@Deprecated('will be removed in 3.0.0. Use Ref instead')
abstract class FutureProviderRef<State> implements Ref<AsyncValue<State>> {
  /// Obtains the state currently exposed by this provider.
  ///
  /// Mutating this property will notify the provider listeners.
  ///
  /// Cannot be called while a provider is creating, unless the setter was called first.
  ///
  /// Will return [AsyncLoading] if used during the first initialization.
  /// Subsequent initializations will contain an [AsyncValue] with the previous
  /// state and [AsyncValueX.isRefreshing]/[AsyncValueX.isReloading] set accordingly.
  AsyncValue<State> get state;
  set state(AsyncValue<State> newState);

  /// Obtains the [Future] associated to this provider.
  ///
  /// This is equivalent to doing `ref.read(myProvider.future)`.
  /// See also [FutureProvider.future].
  Future<State> get future;
}

/// {@macro riverpod.future_provider}
class FutureProvider<T> extends _FutureProviderBase<T>
    with
        // ignore: deprecated_member_use_from_same_package
        AlwaysAliveProviderBase<AsyncValue<T>>,
        AlwaysAliveAsyncSelector<T> {
  /// {@macro riverpod.future_provider}
  FutureProvider(
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
  FutureProvider.internal(
    this._createFn, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    super.from,
    super.argument,
  });

  /// {@macro riverpod.autoDispose}
  static const autoDispose = AutoDisposeFutureProviderBuilder();

  /// {@macro riverpod.family}
  static const family = FutureProviderFamilyBuilder();

  // ignore: deprecated_member_use_from_same_package
  final Create<FutureOr<T>, FutureProviderRef<T>> _createFn;

  @override
  // ignore: deprecated_member_use_from_same_package
  late final AlwaysAliveRefreshable<Future<T>> future = _future(this);

  @override
  FutureOr<T> _create(FutureProviderElement<T> ref) => _createFn(ref);

  @override
  FutureProviderElement<T> createElement() => FutureProviderElement(this);

  /// {@macro riverpod.override_with}
  // ignore: deprecated_member_use_from_same_package
  Override overrideWith(Create<FutureOr<T>, FutureProviderRef<T>> create) {
    return ProviderOverride(
      origin: this,
      override: FutureProvider.internal(
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

/// The element of a [FutureProvider]
class FutureProviderElement<T> extends ProviderElementBase<AsyncValue<T>>
    with
        FutureHandlerProviderElementMixin<T>
    implements
        // ignore: deprecated_member_use_from_same_package
        FutureProviderRef<T> {
  /// The element of a [FutureProvider]
  @internal
  // ignore: library_private_types_in_public_api
  FutureProviderElement(_FutureProviderBase<T> super._provider);

  @override
  Future<T> get future {
    flush();
    return futureNotifier.value;
  }

  @override
  void create({required bool didChangeDependency}) {
    final provider = this.provider as _FutureProviderBase<T>;

    handleFuture(
      () => provider._create(this),
      didChangeDependency: didChangeDependency,
    );
  }
}

/// The [Family] of a [FutureProvider]
// ignore: deprecated_member_use_from_same_package
class FutureProviderFamily<R, Arg> extends FamilyBase<FutureProviderRef<R>,
    AsyncValue<R>, Arg, FutureOr<R>, FutureProvider<R>> {
  /// The [Family] of a [FutureProvider]
  FutureProviderFamily(
    super._createFn, {
    super.name,
    super.dependencies,
  }) : super(
          providerFactory: FutureProvider<R>.internal,
          allTransitiveDependencies:
              computeAllTransitiveDependencies(dependencies),
          debugGetCreateSourceHash: null,
        );

  /// Implementation detail of the code-generator.
  @internal
  FutureProviderFamily.generator(
    super._createFn, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
  }) : super(providerFactory: FutureProvider<R>.internal);

  /// {@macro riverpod.override_with}
  Override overrideWith(
    // ignore: deprecated_member_use_from_same_package
    FutureOr<R> Function(FutureProviderRef<R> ref, Arg arg) create,
  ) {
    return FamilyOverrideImpl<AsyncValue<R>, Arg, FutureProvider<R>>(
      this,
      (arg) => FutureProvider<R>.internal(
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
