part of '../async_notifier.dart';

/// {@macro riverpod.streamNotifier}
abstract class FamilyStreamNotifier<State, Arg>
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

  /// {@macro riverpod.StreamNotifier.build}
  @visibleForOverriding
  Stream<State> build(Arg arg);
}

/// {@template riverpod.async_notifier_family_provider}
/// The provider for [StreamNotifierProviderFamily].
/// {@endtemplate}
typedef StreamNotifierFamilyProvider<
        NotifierT extends FamilyStreamNotifier<T, Arg>, T, Arg>
    = FamilyStreamNotifierProviderImpl<NotifierT, T, Arg>;

/// An internal implementation of [StreamNotifierFamilyProvider] for testing purpose.
///
/// Not meant for public consumption.
@visibleForTesting
@internal
class FamilyStreamNotifierProviderImpl<NotifierT extends AsyncNotifierBase<T>,
        T, Arg> extends StreamNotifierProviderBase<NotifierT, T>
    with AlwaysAliveProviderBase<AsyncValue<T>>, AlwaysAliveAsyncSelector<T> {
  /// {@macro riverpod.async_notifier_family_provider}
  FamilyStreamNotifierProviderImpl(
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
  FamilyStreamNotifierProviderImpl.internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    super.from,
    super.argument,
  });

  /// {@macro riverpod.autoDispose}
  static const autoDispose = AutoDisposeStreamNotifierProviderFamily.new;

  @override
  late final AlwaysAliveRefreshable<NotifierT> notifier =
      _streamNotifier<NotifierT, T>(this);

  @override
  late final AlwaysAliveRefreshable<Future<T>> future = _streamFuture<T>(this);

  @override
  StreamNotifierProviderElement<NotifierT, T> createElement() {
    return StreamNotifierProviderElement._(this);
  }

  @override
  Stream<T> runNotifierBuild(
    covariant FamilyStreamNotifier<T, Arg> notifier,
  ) {
    return notifier.build(notifier.arg);
  }
}

/// The [Family] of [StreamNotifierProvider].
class StreamNotifierProviderFamily<
        NotifierT extends FamilyStreamNotifier<T, Arg>, T, Arg>
    extends NotifierFamilyBase<StreamNotifierProviderRef<T>, AsyncValue<T>, Arg,
        NotifierT, StreamNotifierFamilyProvider<NotifierT, T, Arg>> {
  /// The [Family] of [StreamNotifierProvider].
  StreamNotifierProviderFamily(
    super.create, {
    super.name,
    super.dependencies,
  }) : super(
          providerFactory: StreamNotifierFamilyProvider.internal,
          allTransitiveDependencies:
              computeAllTransitiveDependencies(dependencies),
          debugGetCreateSourceHash: null,
        );

  /// {@macro riverpod.overridewith}
  Override overrideWith(NotifierT Function() create) {
    return FamilyOverrideImpl<AsyncValue<T>, Arg,
        StreamNotifierFamilyProvider<NotifierT, T, Arg>>(
      this,
      (arg) => StreamNotifierFamilyProvider<NotifierT, T, Arg>.internal(
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
