part of '../async_notifier.dart';

/// {@macro riverpod.streamNotifier}
abstract class AutoDisposeStreamNotifier<State>
    extends BuildlessAutoDisposeAsyncNotifier<State> {
  /// {@macro riverpod.StreamNotifier.build}
  @visibleForOverriding
  Stream<State> build();
}

/// {@macro riverpod.providerrefbase}
abstract class AutoDisposeStreamNotifierProviderRef<T>
    implements StreamNotifierProviderRef<T>, AutoDisposeRef<AsyncValue<T>> {}

/// {@macro riverpod.StreamNotifier}
typedef AutoDisposeStreamNotifierProvider<
        NotifierT extends AutoDisposeStreamNotifier<T>, T>
    = AutoDisposeStreamNotifierProviderImpl<NotifierT, T>;

/// The implementation of [AutoDisposeStreamNotifierProvider] but with loosened type constraints
/// that can be shared with [StreamNotifierProvider].
///
/// This enables tests to execute on both [AutoDisposeStreamNotifierProvider] and
/// [StreamNotifierProvider] at the same time.
@internal
class AutoDisposeStreamNotifierProviderImpl<
    NotifierT extends AsyncNotifierBase<T>,
    T> extends StreamNotifierProviderBase<NotifierT, T> with AsyncSelector<T> {
  /// {@macro riverpod.notifier}
  AutoDisposeStreamNotifierProviderImpl(
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
  AutoDisposeStreamNotifierProviderImpl.internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    super.from,
    super.argument,
  });

  /// {@macro riverpod.family}
  static const family = AutoDisposeStreamNotifierProviderFamily.new;

  @override
  late final Refreshable<NotifierT> notifier =
      _streamNotifier<NotifierT, T>(this);

  @override
  late final Refreshable<Future<T>> future = _streamFuture<T>(this);

  @override
  AutoDisposeStreamNotifierProviderElement<NotifierT, T> createElement() {
    return AutoDisposeStreamNotifierProviderElement._(this);
  }

  @override
  Stream<T> runNotifierBuild(covariant AutoDisposeStreamNotifier<T> notifier) {
    return notifier.build();
  }

  /// {@macro riverpod.overridewith}
  Override overrideWith(NotifierT Function() create) {
    return ProviderOverride(
      origin: this,
      override: AutoDisposeStreamNotifierProviderImpl<NotifierT, T>.internal(
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

/// The element of [AutoDisposeStreamNotifierProvider].
class AutoDisposeStreamNotifierProviderElement<
        NotifierT extends AsyncNotifierBase<T>,
        T> extends StreamNotifierProviderElement<NotifierT, T>
    with AutoDisposeProviderElementMixin<AsyncValue<T>>
    implements AutoDisposeStreamNotifierProviderRef<T> {
  /// The [ProviderElementBase] for [StreamNotifierProvider]
  AutoDisposeStreamNotifierProviderElement._(super.provider) : super._();
}
