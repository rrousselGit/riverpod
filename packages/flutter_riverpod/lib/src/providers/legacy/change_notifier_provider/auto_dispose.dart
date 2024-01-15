// ignore_for_file: invalid_use_of_internal_member

part of '../change_notifier_provider.dart';

/// {@macro riverpod.provider_ref_base}
abstract class AutoDisposeChangeNotifierProviderRef<
        NotifierT extends ChangeNotifier?>
    extends ChangeNotifierProviderRef<NotifierT>
    implements AutoDisposeRef<NotifierT> {}

/// {@macro riverpod.change_notifier_provider}
class AutoDisposeChangeNotifierProvider<NotifierT extends ChangeNotifier?>
    extends _ChangeNotifierProviderBase<NotifierT> {
  /// {@macro riverpod.change_notifier_provider}
  AutoDisposeChangeNotifierProvider(
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
  AutoDisposeChangeNotifierProviderElement<NotifierT> createElement(
    ProviderContainer container,
  ) {
    return AutoDisposeChangeNotifierProviderElement<NotifierT>._(
      this,
      container,
    );
  }

  @override
  late final Refreshable<NotifierT> notifier = _notifier<NotifierT>(this);

  /// {@macro riverpod.override_with}
  Override overrideWith(
    Create<NotifierT, AutoDisposeChangeNotifierProviderRef<NotifierT>> create,
  ) {
    return ProviderOverride(
      origin: this,
      providerOverride: AutoDisposeChangeNotifierProvider<NotifierT>.internal(
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
    AutoDisposeChangeNotifierProvider<NotifierT> super.provider,
    super.container,
  ) : super._();
}

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
    return FamilyOverride(
      from: this,
      createElement: (container, provider) {
        provider as AutoDisposeChangeNotifierProvider<NotifierT>;

        return AutoDisposeChangeNotifierProvider<NotifierT>.internal(
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
