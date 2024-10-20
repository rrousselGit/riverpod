part of '../state_provider.dart';

/// {@macro riverpod.provider_ref_base}
/// - [controller], the [StateController] currently exposed by this provider.
@Deprecated('will be removed in 3.0.0. Use Ref instead')
abstract class AutoDisposeStateProviderRef<State>
    extends StateProviderRef<State> implements AutoDisposeRef<State> {}

/// {@macro riverpod.stateprovider}
class AutoDisposeStateProvider<T> extends _StateProviderBase<T> {
  /// {@macro riverpod.stateprovider}
  AutoDisposeStateProvider(
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
  AutoDisposeStateProvider.internal(
    this._createFn, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    super.from,
    super.argument,
  });

  /// {@macro riverpod.family}
  static const family = AutoDisposeStateProviderFamily.new;

  // ignore: deprecated_member_use_from_same_package
  final T Function(AutoDisposeStateProviderRef<T> ref) _createFn;

  @override
  T _create(AutoDisposeStateProviderElement<T> ref) => _createFn(ref);

  @override
  AutoDisposeStateProviderElement<T> createElement() {
    return AutoDisposeStateProviderElement._(this);
  }

  @override
  late final Refreshable<StateController<T>> notifier = _notifier(this);

  @Deprecated(
    'Will be removed in 3.0.0. '
    'Use either `ref.watch(provider)` or `ref.read(provider.notifier)` instead',
  )
  @override
  late final Refreshable<StateController<T>> state = _state(this);

  /// {@macro riverpod.override_with}
  Override overrideWith(
    // ignore: deprecated_member_use_from_same_package
    Create<T, AutoDisposeStateProviderRef<T>> create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AutoDisposeStateProvider<T>.internal(
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

/// The element of [StateProvider].
class AutoDisposeStateProviderElement<T> extends StateProviderElement<T>
    with
        AutoDisposeProviderElementMixin<T>
    implements
        // ignore: deprecated_member_use_from_same_package
        AutoDisposeStateProviderRef<T> {
  /// The [ProviderElementBase] for [StateProvider]
  AutoDisposeStateProviderElement._(AutoDisposeStateProvider<T> super._provider)
      : super._();
}

/// The [Family] of [StateProvider].
class AutoDisposeStateProviderFamily<R, Arg> extends AutoDisposeFamilyBase<
    // ignore: deprecated_member_use_from_same_package
    AutoDisposeStateProviderRef<R>,
    R,
    Arg,
    R,
    AutoDisposeStateProvider<R>> {
  /// The [Family] of [StateProvider].
  AutoDisposeStateProviderFamily(
    super._createFn, {
    super.name,
    super.dependencies,
  }) : super(
          providerFactory: AutoDisposeStateProvider.internal,
          debugGetCreateSourceHash: null,
          allTransitiveDependencies:
              computeAllTransitiveDependencies(dependencies),
        );

  /// {@macro riverpod.override_with}
  Override overrideWith(
    // ignore: deprecated_member_use_from_same_package
    R Function(AutoDisposeStateProviderRef<R> ref, Arg arg) create,
  ) {
    return FamilyOverrideImpl<R, Arg, AutoDisposeStateProvider<R>>(
      this,
      (arg) => AutoDisposeStateProvider<R>.internal(
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
