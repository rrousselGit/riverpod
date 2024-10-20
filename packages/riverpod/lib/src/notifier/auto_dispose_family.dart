part of '../notifier.dart';

/// {@macro riverpod.notifier}
///
/// {@macro riverpod.notifier_provider_modifier}
abstract class AutoDisposeFamilyNotifier<State, Arg>
    extends BuildlessAutoDisposeNotifier<State> {
  /// {@macro riverpod.notifier.family_arg}
  late final Arg arg;

  @override
  void _setElement(ProviderElementBase<State> element) {
    super._setElement(element);
    arg = element.origin.argument as Arg;
  }

  /// {@macro riverpod.async_notifier.build}
  @visibleForOverriding
  State build(Arg arg);
}

/// {@macro riverpod.notifier_provider}
///
/// {@macro riverpod.notifier_provider_modifier}
typedef AutoDisposeFamilyNotifierProvider<
        NotifierT extends AutoDisposeFamilyNotifier<T, Arg>, T, Arg>
    = AutoDisposeFamilyNotifierProviderImpl<NotifierT, T, Arg>;

/// The implementation of [AutoDisposeNotifierProvider] but with loosened type constraints
/// that can be shared with [NotifierProvider].
///
/// This enables tests to execute on both [AutoDisposeNotifierProvider] and
/// [NotifierProvider] at the same time.
@internal
class AutoDisposeFamilyNotifierProviderImpl<NotifierT extends NotifierBase<T>,
    T, Arg> extends NotifierProviderBase<NotifierT, T> {
  /// {@macro riverpod.notifier_provider}
  ///
  /// {@macro riverpod.notifier_provider_modifier}
  AutoDisposeFamilyNotifierProviderImpl(
    super._createNotifier, {
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
  AutoDisposeFamilyNotifierProviderImpl.internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    super.from,
    super.argument,
  });

  @override
  late final Refreshable<NotifierT> notifier = _notifier<NotifierT, T>(this);

  @override
  AutoDisposeNotifierProviderElement<NotifierT, T> createElement() {
    return AutoDisposeNotifierProviderElement(this);
  }

  @override
  T runNotifierBuild(
    covariant AutoDisposeFamilyNotifier<T, Arg> notifier,
  ) {
    return notifier.build(notifier.arg);
  }
}

/// The [Family] of [NotifierProvider].
class AutoDisposeNotifierProviderFamily<
        NotifierT extends AutoDisposeFamilyNotifier<T, Arg>, T, Arg>
    // ignore: deprecated_member_use_from_same_package
    extends AutoDisposeNotifierFamilyBase<AutoDisposeNotifierProviderRef<T>, T,
        Arg, NotifierT, AutoDisposeFamilyNotifierProvider<NotifierT, T, Arg>> {
  /// The [Family] of [AutoDisposeNotifierProvider].
  AutoDisposeNotifierProviderFamily(
    super._createFn, {
    super.name,
    super.dependencies,
  }) : super(
          providerFactory: AutoDisposeFamilyNotifierProvider.internal,
          debugGetCreateSourceHash: null,
          allTransitiveDependencies:
              computeAllTransitiveDependencies(dependencies),
        );

  /// An implementation detail of Riverpod
  @internal
  AutoDisposeNotifierProviderFamily.internal(
    super._createFn, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
  }) : super(providerFactory: AutoDisposeFamilyNotifierProvider.internal);

  /// {@macro riverpod.override_with}
  Override overrideWith(NotifierT Function() create) {
    return FamilyOverrideImpl<T, Arg,
        AutoDisposeFamilyNotifierProvider<NotifierT, T, Arg>>(
      this,
      (arg) => AutoDisposeFamilyNotifierProvider<NotifierT, T, Arg>.internal(
        create,
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
