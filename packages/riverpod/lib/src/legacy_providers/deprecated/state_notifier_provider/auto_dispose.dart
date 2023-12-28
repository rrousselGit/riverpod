part of '../state_notifier_provider.dart';

/// {@macro riverpod.provider_ref_base}
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
  }) : super(
          allTransitiveDependencies:
              computeAllTransitiveDependencies(dependencies),
          from: null,
          argument: null,
          debugGetCreateSourceHash: null,
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
    AutoDisposeStateNotifierProviderRef<NotifierT, T> ref,
  ) _createFn;

  @override
  NotifierT _create(AutoDisposeStateNotifierProviderElement<NotifierT, T> ref) {
    return _createFn(ref);
  }

  @override
  AutoDisposeStateNotifierProviderElement<NotifierT, T> createElement(
    ProviderContainer container,
  ) {
    return AutoDisposeStateNotifierProviderElement._(this, container);
  }

  @override
  late final Refreshable<NotifierT> notifier = _notifier(this);

  /// {@macro riverpod.override_with}
  Override overrideWith(
    Create<NotifierT, AutoDisposeStateNotifierProviderRef<NotifierT, T>> create,
  ) {
    return ProviderOverride(
      origin: this,
      providerOverride: AutoDisposeStateNotifierProvider<NotifierT, T>.internal(
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
    with AutoDisposeProviderElementMixin<T>
    implements AutoDisposeStateNotifierProviderRef<NotifierT, T> {
  /// The [ProviderElementBase] for [StateNotifierProvider]
  AutoDisposeStateNotifierProviderElement._(
    AutoDisposeStateNotifierProvider<NotifierT, T> super.provider,
    super.container,
  ) : super._();
}

/// The [Family] of [AutoDisposeStateNotifierProvider].
class AutoDisposeStateNotifierProviderFamily<NotifierT extends StateNotifier<T>,
        T, Arg>
    extends AutoDisposeFamilyBase<
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
      AutoDisposeStateNotifierProviderRef<NotifierT, T> ref,
      Arg arg,
    ) create,
  ) {
    return FamilyOverride(
      from: this,
      createElement: (container, provider) {
        provider as AutoDisposeStateNotifierProvider<NotifierT, T>;

        return AutoDisposeStateNotifierProvider<NotifierT, T>.internal(
          (ref) => create(ref, provider.argument as Arg),
          from: provider.from,
          argument: provider.argument,
          dependencies: null,
          allTransitiveDependencies: null,
          debugGetCreateSourceHash: null,
          name: null,
        ).createElement(container);
      },
    );
  }
}
