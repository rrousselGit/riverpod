part of '../async_notifier.dart';

/// {@macro riverpod.streamNotifier}
abstract class AutoDisposeFamilyStreamNotifier<State, Arg>
    extends BuildlessAutoDisposeStreamNotifier<State> {
  /// {@macro riverpod.notifier.family_arg}
  late final Arg arg;

  @override
  void _setElement(ProviderElementBase<AsyncValue<State>> element) {
    super._setElement(element);
    arg = element.origin.argument as Arg;
  }

  /// {@macro riverpod.StreamNotifier.build}
  @visibleForOverriding
  Stream<State> build(Arg arg);
}

/// {@macro riverpod.StreamNotifier}
typedef AutoDisposeFamilyStreamNotifierProvider<
        NotifierT extends AutoDisposeFamilyStreamNotifier<T, Arg>, T, Arg>
    = AutoDisposeFamilyStreamNotifierProviderImpl<NotifierT, T, Arg>;

/// The implementation of [AutoDisposeStreamNotifierProvider] but with loosened type constraints
/// that can be shared with [StreamNotifierProvider].
///
/// This enables tests to execute on both [AutoDisposeStreamNotifierProvider] and
/// [StreamNotifierProvider] at the same time.
@internal
class AutoDisposeFamilyStreamNotifierProviderImpl<
        NotifierT extends AsyncNotifierBase<T>, T, Arg>
    extends StreamNotifierProviderBase<NotifierT, T> with AsyncSelector<T> {
  /// {@macro riverpod.streamNotifier}
  AutoDisposeFamilyStreamNotifierProviderImpl(
    super._createNotifier, {
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
  AutoDisposeFamilyStreamNotifierProviderImpl.internal(
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
      _streamNotifier<NotifierT, T>(this);

  @override
  late final Refreshable<Future<T>> future = _streamFuture<T>(this);

  @override
  AutoDisposeStreamNotifierProviderElement<NotifierT, T> createElement() {
    return AutoDisposeStreamNotifierProviderElement(this);
  }

  @override
  Stream<T> runNotifierBuild(
    covariant AutoDisposeFamilyStreamNotifier<T, Arg> notifier,
  ) {
    return notifier.build(notifier.arg);
  }
}

/// The [Family] of [StreamNotifierProvider].
class AutoDisposeStreamNotifierProviderFamily<
        NotifierT extends AutoDisposeFamilyStreamNotifier<T, Arg>, T, Arg>
    extends AutoDisposeNotifierFamilyBase<
        // ignore: deprecated_member_use_from_same_package
        AutoDisposeStreamNotifierProviderRef<T>,
        AsyncValue<T>,
        Arg,
        NotifierT,
        AutoDisposeFamilyStreamNotifierProvider<NotifierT, T, Arg>> {
  /// The [Family] of [AutoDisposeStreamNotifierProvider].
  AutoDisposeStreamNotifierProviderFamily(
    super._createFn, {
    super.name,
    super.dependencies,
  }) : super(
          providerFactory: AutoDisposeFamilyStreamNotifierProvider.internal,
          allTransitiveDependencies:
              computeAllTransitiveDependencies(dependencies),
          debugGetCreateSourceHash: null,
        );

  /// {@macro riverpod.override_with}
  Override overrideWith(NotifierT Function() create) {
    return FamilyOverrideImpl<AsyncValue<T>, Arg,
        AutoDisposeFamilyStreamNotifierProvider<NotifierT, T, Arg>>(
      this,
      (arg) =>
          AutoDisposeFamilyStreamNotifierProvider<NotifierT, T, Arg>.internal(
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
