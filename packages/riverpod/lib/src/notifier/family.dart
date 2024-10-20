part of '../notifier.dart';

/// {@macro riverpod.notifier}
///
/// {@macro riverpod.notifier_provider_modifier}
abstract class FamilyNotifier<State, Arg> extends BuildlessNotifier<State> {
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

/// The provider for [NotifierProviderFamily].
typedef NotifierFamilyProvider<NotifierT extends FamilyNotifier<T, Arg>, T, Arg>
    = FamilyNotifierProviderImpl<NotifierT, T, Arg>;

/// The implementation of [NotifierFamilyProvider] but with loosened type constraints
/// that can be shared with [AutoDisposeNotifierProvider].
///
/// This enables tests to execute on both [NotifierProvider] and
/// [AutoDisposeNotifierProvider] at the same time.
@visibleForTesting
@internal
class FamilyNotifierProviderImpl<NotifierT extends NotifierBase<T>, T, Arg>
    extends NotifierProviderBase<NotifierT, T>
    with
        // ignore: deprecated_member_use_from_same_package
        AlwaysAliveProviderBase<T> {
  /// {@macro riverpod.notifier}
  FamilyNotifierProviderImpl(
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
  FamilyNotifierProviderImpl.internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    super.from,
    super.argument,
  });

  /// {@macro riverpod.autoDispose}
  // ignore: prefer_const_declarations
  static final autoDispose = AutoDisposeNotifierProviderFamily.new;

  // /// {@macro riverpod.family}
  // static const family = NotifierProviderFamilyBuilder();

  @override
  // ignore: deprecated_member_use_from_same_package
  late final AlwaysAliveRefreshable<NotifierT> notifier =
      _notifier<NotifierT, T>(this);

  @override
  NotifierProviderElement<NotifierT, T> createElement() {
    return NotifierProviderElement(this);
  }

  @override
  T runNotifierBuild(
    covariant FamilyNotifier<T, Arg> notifier,
  ) {
    return notifier.build(notifier.arg);
  }
}

/// The [Family] of [NotifierProvider].
class NotifierProviderFamily<NotifierT extends FamilyNotifier<T, Arg>, T, Arg>
    // ignore: deprecated_member_use_from_same_package
    extends NotifierFamilyBase<NotifierProviderRef<T>, T, Arg, NotifierT,
        NotifierFamilyProvider<NotifierT, T, Arg>> {
  /// The [Family] of [NotifierProvider].
  NotifierProviderFamily(
    super._createFn, {
    super.name,
    super.dependencies,
  }) : super(
          providerFactory: NotifierFamilyProvider.internal,
          allTransitiveDependencies:
              computeAllTransitiveDependencies(dependencies),
          debugGetCreateSourceHash: null,
        );

  /// An implementation detail of Riverpod
  @internal
  NotifierProviderFamily.internal(
    super._createFn, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
  }) : super(providerFactory: NotifierFamilyProvider.internal);

  /// {@macro riverpod.override_with}
  Override overrideWith(NotifierT Function() create) {
    return FamilyOverrideImpl<T, Arg,
        NotifierFamilyProvider<NotifierT, T, Arg>>(
      this,
      (arg) => NotifierFamilyProvider<NotifierT, T, Arg>.internal(
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
