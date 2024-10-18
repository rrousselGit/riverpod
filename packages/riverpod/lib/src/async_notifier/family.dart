part of '../async_notifier.dart';

/// {@macro riverpod.async_notifier}
///
/// {@macro riverpod.async_notifier_provider_modifier}
abstract class FamilyAsyncNotifier<State, Arg>
    extends BuildlessAsyncNotifier<State> {
  /// {@template riverpod.notifier.family_arg}
  /// The argument that was passed to this family.
  ///
  /// For example, when doing:
  ///
  /// ```dart
  /// ref.watch(provider(0));
  /// ```
  ///
  /// then [arg] will be `0`.
  /// {@endtemplate}
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
typedef AsyncNotifierFamilyProvider<
        NotifierT extends FamilyAsyncNotifier<T, Arg>, T, Arg>
    = FamilyAsyncNotifierProviderImpl<NotifierT, T, Arg>;

/// An internal implementation of [AsyncNotifierFamilyProvider] for testing purpose.
///
/// Not meant for public consumption.
@visibleForTesting
@internal
class FamilyAsyncNotifierProviderImpl<NotifierT extends AsyncNotifierBase<T>, T,
        Arg> extends AsyncNotifierProviderBase<NotifierT, T>
    with
        // ignore: deprecated_member_use_from_same_package
        AlwaysAliveProviderBase<AsyncValue<T>>,
        AlwaysAliveAsyncSelector<T> {
  /// {@macro riverpod.async_notifier_family_provider}
  FamilyAsyncNotifierProviderImpl(
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
  FamilyAsyncNotifierProviderImpl.internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    super.from,
    super.argument,
  });

  /// {@macro riverpod.autoDispose}
  static const autoDispose = AutoDisposeAsyncNotifierProviderFamily.new;

  @override
  // ignore: deprecated_member_use_from_same_package
  late final AlwaysAliveRefreshable<NotifierT> notifier =
      _asyncNotifier<NotifierT, T>(this);

  @override
  // ignore: deprecated_member_use_from_same_package
  late final AlwaysAliveRefreshable<Future<T>> future = _asyncFuture<T>(this);

  @override
  AsyncNotifierProviderElement<NotifierT, T> createElement() {
    return AsyncNotifierProviderElement(this);
  }

  @override
  FutureOr<T> runNotifierBuild(
    covariant FamilyAsyncNotifier<T, Arg> notifier,
  ) {
    return notifier.build(notifier.arg);
  }
}

/// The [Family] of [AsyncNotifierProvider].
class AsyncNotifierProviderFamily<NotifierT extends FamilyAsyncNotifier<T, Arg>,
        T, Arg>
    // ignore: deprecated_member_use_from_same_package
    extends NotifierFamilyBase<AsyncNotifierProviderRef<T>, AsyncValue<T>, Arg,
        NotifierT, AsyncNotifierFamilyProvider<NotifierT, T, Arg>> {
  /// The [Family] of [AsyncNotifierProvider].
  AsyncNotifierProviderFamily(
    super._createFn, {
    super.name,
    super.dependencies,
  }) : super(
          providerFactory: AsyncNotifierFamilyProvider.internal,
          allTransitiveDependencies:
              computeAllTransitiveDependencies(dependencies),
          debugGetCreateSourceHash: null,
        );

  /// {@macro riverpod.override_with}
  Override overrideWith(NotifierT Function() create) {
    return FamilyOverrideImpl<AsyncValue<T>, Arg,
        AsyncNotifierFamilyProvider<NotifierT, T, Arg>>(
      this,
      (arg) => AsyncNotifierFamilyProvider<NotifierT, T, Arg>.internal(
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
