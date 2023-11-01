// ignore_for_file: invalid_use_of_internal_member

part of '../change_notifier_provider.dart';

/// {@macro riverpod.provider_ref_base}
abstract class AutoDisposeChangeNotifierProviderRef<
        NotifierT extends ChangeNotifier?>
    extends ChangeNotifierProviderRef<NotifierT>
    implements AutoDisposeRef<NotifierT> {}

// ignore: subtype_of_sealed_class
/// {@macro riverpod.change_notifier_provider}
class AutoDisposeChangeNotifierProvider<NotifierT extends ChangeNotifier?>
    extends _ChangeNotifierProviderBase<NotifierT> {
  /// {@macro riverpod.change_notifier_provider}
  AutoDisposeChangeNotifierProvider(
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
  AutoDisposeChangeNotifierProvider.internal(
    this._createFn, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    super.from,
    super.argument,
  });

  /// {@macro riverpod.family}
  static const family = AutoDisposeChangeNotifierProviderFamily.new;

  final NotifierT Function(AutoDisposeChangeNotifierProviderRef<NotifierT> ref)
      _createFn;

  @override
  NotifierT _create(AutoDisposeChangeNotifierProviderElement<NotifierT> ref) {
    return _createFn(ref);
  }

  @override
  AutoDisposeChangeNotifierProviderElement<NotifierT> createElement() {
    return AutoDisposeChangeNotifierProviderElement<NotifierT>._(this);
  }

  @override
  late final Refreshable<NotifierT> notifier = _notifier<NotifierT>(this);

  /// {@macro riverpod.override_with}
  Override overrideWith(
    Create<NotifierT, AutoDisposeChangeNotifierProviderRef<NotifierT>> create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AutoDisposeChangeNotifierProvider<NotifierT>.internal(
        create,
        from: from,
        argument: argument,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
      ),
    );
  }
}

/// The element of [AutoDisposeChangeNotifierProvider].
class AutoDisposeChangeNotifierProviderElement<
        NotifierT extends ChangeNotifier?>
    extends ChangeNotifierProviderElement<NotifierT>
    with AutoDisposeProviderElementMixin<NotifierT>
    implements AutoDisposeChangeNotifierProviderRef<NotifierT> {
  /// The [ProviderElementBase] for [ChangeNotifier]
  AutoDisposeChangeNotifierProviderElement._(
    AutoDisposeChangeNotifierProvider<NotifierT> super._provider,
  ) : super._();
}

// ignore: subtype_of_sealed_class
/// The [Family] of [AutoDisposeChangeNotifierProvider].
class AutoDisposeChangeNotifierProviderFamily<NotifierT extends ChangeNotifier?,
        Arg>
    extends AutoDisposeFamilyBase<
        AutoDisposeChangeNotifierProviderRef<NotifierT>,
        NotifierT,
        Arg,
        NotifierT,
        AutoDisposeChangeNotifierProvider<NotifierT>> {
  /// The [Family] of [AutoDisposeChangeNotifierProvider].
  AutoDisposeChangeNotifierProviderFamily(
    super._createFn, {
    super.name,
    super.dependencies,
  }) : super(
          providerFactory: AutoDisposeChangeNotifierProvider.internal,
          debugGetCreateSourceHash: null,
          allTransitiveDependencies:
              computeAllTransitiveDependencies(dependencies),
        );

  /// {@macro riverpod.override_with}
  Override overrideWith(
    NotifierT Function(
      AutoDisposeChangeNotifierProviderRef<NotifierT> ref,
      Arg arg,
    ) create,
  ) {
    return FamilyOverrideImpl<NotifierT, Arg,
        AutoDisposeChangeNotifierProvider<NotifierT>>(
      this,
      (arg) => AutoDisposeChangeNotifierProvider<NotifierT>.internal(
        (ref) => create(ref, arg),
        from: from,
        argument: arg,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
      ),
    );
  }
}
