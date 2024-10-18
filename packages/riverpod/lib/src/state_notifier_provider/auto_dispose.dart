part of '../state_notifier_provider.dart';

/// {@macro riverpod.provider_ref_base}
@Deprecated('will be removed in 3.0.0. Use Ref instead')
abstract class AutoDisposeStateNotifierProviderRef<
        NotifierT extends StateNotifier<T>,
        T> extends StateNotifierProviderRef<NotifierT, T>
    implements AutoDisposeRef<T> {}

/// {@macro riverpod.statenotifierprovider}
class AutoDisposeStateNotifierProvider<NotifierT extends StateNotifier<T>, T>
    extends _StateNotifierProviderBase<NotifierT, T> {
  /// {@macro riverpod.statenotifierprovider}
  AutoDisposeStateNotifierProvider(
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
  AutoDisposeStateNotifierProvider.internal(
    this._createFn, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    super.from,
    super.argument,
  });

  /// {@macro riverpod.family}
  static const family = AutoDisposeStateNotifierProviderFamily.new;

  final NotifierT Function(
    // ignore: deprecated_member_use_from_same_package
    AutoDisposeStateNotifierProviderRef<NotifierT, T> ref,
  ) _createFn;

  @override
  NotifierT _create(AutoDisposeStateNotifierProviderElement<NotifierT, T> ref) {
    return _createFn(ref);
  }

  @override
  AutoDisposeStateNotifierProviderElement<NotifierT, T> createElement() {
    return AutoDisposeStateNotifierProviderElement._(this);
  }

  @override
  late final Refreshable<NotifierT> notifier = _notifier(this);

  /// {@macro riverpod.override_with}
  Override overrideWith(
    // ignore: deprecated_member_use_from_same_package
    Create<NotifierT, AutoDisposeStateNotifierProviderRef<NotifierT, T>> create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AutoDisposeStateNotifierProvider<NotifierT, T>.internal(
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

/// The element of [AutoDisposeStateNotifierProvider].
class AutoDisposeStateNotifierProviderElement<
        NotifierT extends StateNotifier<T>,
        T> extends StateNotifierProviderElement<NotifierT, T>
    with
        AutoDisposeProviderElementMixin<T>
    implements
        // ignore: deprecated_member_use_from_same_package
        AutoDisposeStateNotifierProviderRef<NotifierT, T> {
  /// The [ProviderElementBase] for [StateNotifierProvider]
  AutoDisposeStateNotifierProviderElement._(
    AutoDisposeStateNotifierProvider<NotifierT, T> super._provider,
  ) : super._();
}

/// The [Family] of [AutoDisposeStateNotifierProvider].
class AutoDisposeStateNotifierProviderFamily<NotifierT extends StateNotifier<T>, T, Arg>
    extends AutoDisposeFamilyBase<
        // ignore: deprecated_member_use_from_same_package
        AutoDisposeStateNotifierProviderRef<NotifierT, T>,
        T,
        Arg,
        NotifierT,
        AutoDisposeStateNotifierProvider<NotifierT, T>> {
  /// The [Family] of [AutoDisposeStateNotifierProvider].
  AutoDisposeStateNotifierProviderFamily(
    super._createFn, {
    super.name,
    super.dependencies,
  }) : super(
          providerFactory: AutoDisposeStateNotifierProvider.internal,
          debugGetCreateSourceHash: null,
          allTransitiveDependencies:
              computeAllTransitiveDependencies(dependencies),
        );

  /// {@macro riverpod.override_with}
  Override overrideWith(
    NotifierT Function(
      // ignore: deprecated_member_use_from_same_package
      AutoDisposeStateNotifierProviderRef<NotifierT, T> ref,
      Arg arg,
    ) create,
  ) {
    return FamilyOverrideImpl<T, Arg,
        AutoDisposeStateNotifierProvider<NotifierT, T>>(
      this,
      (arg) => AutoDisposeStateNotifierProvider<NotifierT, T>.internal(
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
