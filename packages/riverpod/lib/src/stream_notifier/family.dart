part of '../async_notifier.dart';

/// {@macro riverpod.streamNotifier}
abstract class FamilyStreamNotifier<State, Arg>
    extends BuildlessStreamNotifier<State> {
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

/// {@macro riverpod.streamNotifier}
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
    with
        // ignore: deprecated_member_use_from_same_package
        AlwaysAliveProviderBase<AsyncValue<T>>,
        AlwaysAliveAsyncSelector<T> {
  /// {@macro riverpod.streamNotifier}
  FamilyStreamNotifierProviderImpl(
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
  // ignore: deprecated_member_use_from_same_package
  late final AlwaysAliveRefreshable<NotifierT> notifier =
      _streamNotifier<NotifierT, T>(this);

  @override
  // ignore: deprecated_member_use_from_same_package
  late final AlwaysAliveRefreshable<Future<T>> future = _streamFuture<T>(this);

  @override
  StreamNotifierProviderElement<NotifierT, T> createElement() {
    return StreamNotifierProviderElement(this);
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
    // ignore: deprecated_member_use_from_same_package
    extends NotifierFamilyBase<StreamNotifierProviderRef<T>, AsyncValue<T>, Arg,
        NotifierT, StreamNotifierFamilyProvider<NotifierT, T, Arg>> {
  /// The [Family] of [StreamNotifierProvider].
  StreamNotifierProviderFamily(
    super._createFn, {
    super.name,
    super.dependencies,
  }) : super(
          providerFactory: StreamNotifierFamilyProvider.internal,
          allTransitiveDependencies:
              computeAllTransitiveDependencies(dependencies),
          debugGetCreateSourceHash: null,
        );

  /// {@macro riverpod.override_with}
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
