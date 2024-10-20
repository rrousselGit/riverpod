part of '../async_notifier.dart';

/// {@macro riverpod.async_notifier_provider}
///
/// {@macro riverpod.async_notifier_provider_modifier}
abstract class AutoDisposeFamilyAsyncNotifier<State, Arg>
    extends BuildlessAutoDisposeAsyncNotifier<State> {
  /// {@macro riverpod.notifier.family_arg}
  late final Arg arg;

  @override
  void _setElement(ProviderElementBase<AsyncValue<State>> element) {
    super._setElement(element);
    arg = element.origin.argument as Arg;
  }

  /// {@macro riverpod.async_notifier.build}
  @visibleForOverriding
  FutureOr<State> build(Arg arg);
}

/// {@macro riverpod.async_notifier_provider}
///
/// {@macro riverpod.async_notifier_provider_modifier}
typedef AutoDisposeFamilyAsyncNotifierProvider<
        NotifierT extends AutoDisposeFamilyAsyncNotifier<T, Arg>, T, Arg>
    = AutoDisposeFamilyAsyncNotifierProviderImpl<NotifierT, T, Arg>;

/// The implementation of [AutoDisposeAsyncNotifierProvider] but with loosened type constraints
/// that can be shared with [AsyncNotifierProvider].
///
/// This enables tests to execute on both [AutoDisposeAsyncNotifierProvider] and
/// [AsyncNotifierProvider] at the same time.
@internal
class AutoDisposeFamilyAsyncNotifierProviderImpl<
    NotifierT extends AsyncNotifierBase<T>,
    T,
    Arg> extends AsyncNotifierProviderBase<NotifierT, T> with AsyncSelector<T> {
  /// {@macro riverpod.async_notifier_family_provider}
  AutoDisposeFamilyAsyncNotifierProviderImpl(
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
  AutoDisposeFamilyAsyncNotifierProviderImpl.internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    super.from,
    super.argument,
  });

  @override
  late final Refreshable<NotifierT> notifier =
      _asyncNotifier<NotifierT, T>(this);

  @override
  late final Refreshable<Future<T>> future = _asyncFuture<T>(this);

  @override
  AutoDisposeAsyncNotifierProviderElement<NotifierT, T> createElement() {
    return AutoDisposeAsyncNotifierProviderElement(this);
  }

  @override
  FutureOr<T> runNotifierBuild(
    covariant AutoDisposeFamilyAsyncNotifier<T, Arg> notifier,
  ) {
    return notifier.build(notifier.arg);
  }
}

/// The [Family] of [AsyncNotifierProvider].
class AutoDisposeAsyncNotifierProviderFamily<
        NotifierT extends AutoDisposeFamilyAsyncNotifier<T, Arg>, T, Arg>
    extends AutoDisposeNotifierFamilyBase<
        // ignore: deprecated_member_use_from_same_package
        AutoDisposeAsyncNotifierProviderRef<T>,
        AsyncValue<T>,
        Arg,
        NotifierT,
        AutoDisposeFamilyAsyncNotifierProvider<NotifierT, T, Arg>> {
  /// The [Family] of [AutoDisposeAsyncNotifierProvider].
  AutoDisposeAsyncNotifierProviderFamily(
    super._createFn, {
    super.name,
    super.dependencies,
  }) : super(
          providerFactory: AutoDisposeFamilyAsyncNotifierProvider.internal,
          allTransitiveDependencies:
              computeAllTransitiveDependencies(dependencies),
          debugGetCreateSourceHash: null,
        );

  /// {@macro riverpod.override_with}
  Override overrideWith(NotifierT Function() create) {
    return FamilyOverrideImpl<AsyncValue<T>, Arg,
        AutoDisposeFamilyAsyncNotifierProvider<NotifierT, T, Arg>>(
      this,
      (arg) =>
          AutoDisposeFamilyAsyncNotifierProvider<NotifierT, T, Arg>.internal(
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
