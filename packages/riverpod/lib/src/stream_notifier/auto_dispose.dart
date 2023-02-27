part of '../stream_notifier.dart';

/// A [AutoDisposeStreamNotifier] base class shared between family and non-family notifiers.
///
/// Not meant for public consumption outside of riverpod_generator
@internal
abstract class BuildlessAutoDisposeStreamNotifier<State>
    extends StreamNotifierBase<State> {
  @override
  late final AutoDisposeStreamNotifierProviderElement<StreamNotifierBase<State>,
      State> _element;

  @override
  void _setElement(ProviderElementBase<AsyncValue<State>> element) {
    _element = element as AutoDisposeStreamNotifierProviderElement<
        StreamNotifierBase<State>, State>;
  }

  @override
  AutoDisposeStreamNotifierProviderRef<State> get ref => _element;
}

/// {@macro riverpod.StreamNotifier}
abstract class AutoDisposeStreamNotifier<State>
    extends BuildlessAutoDisposeStreamNotifier<State> {
  /// {@macro riverpod.StreamNotifier.build}
  @visibleForOverriding
  FutureOr<State> build();
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
    NotifierT extends StreamNotifierBase<T>,
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
  late final Refreshable<NotifierT> notifier = _notifier<NotifierT, T>(this);

  @override
  late final Refreshable<Future<T>> future = _future<T>(this);

  @override
  AutoDisposeStreamNotifierProviderElement<NotifierT, T> createElement() {
    return AutoDisposeStreamNotifierProviderElement._(this);
  }

  @override
  FutureOr<T> runNotifierBuild(StreamNotifierBase<T> notifier) {
    return (notifier as AutoDisposeStreamNotifier<T>).build();
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
        NotifierT extends StreamNotifierBase<T>,
        T> extends StreamNotifierProviderElement<NotifierT, T>
    with AutoDisposeProviderElementMixin<AsyncValue<T>>
    implements AutoDisposeStreamNotifierProviderRef<T> {
  /// The [ProviderElementBase] for [StreamNotifierProvider]
  AutoDisposeStreamNotifierProviderElement._(super.provider) : super._();
}
