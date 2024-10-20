part of '../async_notifier.dart';

/// A [AutoDisposeStreamNotifier] base class shared between family and non-family notifiers.
///
/// Not meant for public consumption outside of riverpod_generator
@internal
abstract class BuildlessAutoDisposeStreamNotifier<State>
    extends AsyncNotifierBase<State> {
  @override
  late final AutoDisposeStreamNotifierProviderElement<AsyncNotifierBase<State>,
      State> _element;

  @override
  void _setElement(ProviderElementBase<AsyncValue<State>> element) {
    _element = element as AutoDisposeStreamNotifierProviderElement<
        AsyncNotifierBase<State>, State>;
  }

  @override
  // ignore: deprecated_member_use_from_same_package
  AutoDisposeStreamNotifierProviderRef<State> get ref => _element;
}

/// {@macro riverpod.streamNotifier}
abstract class AutoDisposeStreamNotifier<State>
    extends BuildlessAutoDisposeStreamNotifier<State> {
  /// {@macro riverpod.StreamNotifier.build}
  @visibleForOverriding
  Stream<State> build();
}

/// {@macro riverpod.provider_ref_base}
@Deprecated('will be removed in 3.0.0. Use Ref instead')
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
  /// {@macro riverpod.streamNotifier}
  AutoDisposeStreamNotifierProviderImpl(
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
    return AutoDisposeStreamNotifierProviderElement(this);
  }

  @override
  Stream<T> runNotifierBuild(AsyncNotifierBase<T> notifier) {
    // Not using "covariant" as riverpod_generator subclasses this with a
    // different notifier type
    return (notifier as AutoDisposeStreamNotifier<T>).build();
  }

  /// {@macro riverpod.override_with}
  @mustBeOverridden
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
    with
        AutoDisposeProviderElementMixin<AsyncValue<T>>
    implements
        // ignore: deprecated_member_use_from_same_package
        AutoDisposeStreamNotifierProviderRef<T> {
  /// The [ProviderElementBase] for [StreamNotifierProvider]
  @internal
  AutoDisposeStreamNotifierProviderElement(super._provider);
}
