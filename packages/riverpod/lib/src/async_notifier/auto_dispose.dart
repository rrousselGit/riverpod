part of '../async_notifier.dart';

/// A [AutoDisposeAsyncNotifier] base class shared between family and non-family notifiers.
///
/// Not meant for public consumption outside of riverpod_generator
@internal
abstract class BuildlessAutoDisposeAsyncNotifier<State>
    extends AsyncNotifierBase<State> {
  @override
  late final AutoDisposeAsyncNotifierProviderElement<AsyncNotifierBase<State>,
      State> _element;

  @override
  void _setElement(ProviderElementBase<AsyncValue<State>> element) {
    _element = element as AutoDisposeAsyncNotifierProviderElement<
        AsyncNotifierBase<State>, State>;
  }

  @override
  // ignore: deprecated_member_use_from_same_package
  AutoDisposeAsyncNotifierProviderRef<State> get ref => _element;
}

/// {@macro riverpod.async_notifier_provider}
///
/// {@macro riverpod.async_notifier_provider_modifier}
abstract class AutoDisposeAsyncNotifier<State>
    extends BuildlessAutoDisposeAsyncNotifier<State> {
  /// {@macro riverpod.async_notifier.build}
  @visibleForOverriding
  FutureOr<State> build();
}

/// {@macro riverpod.provider_ref_base}
@Deprecated('will be removed in 3.0.0. Use Ref instead')
abstract class AutoDisposeAsyncNotifierProviderRef<T>
    implements
        AsyncNotifierProviderRef<T>,
        // ignore: deprecated_member_use_from_same_package
        AutoDisposeRef<AsyncValue<T>> {}

/// {@macro riverpod.async_notifier_provider}
///
/// {@macro riverpod.async_notifier_provider_modifier}
typedef AutoDisposeAsyncNotifierProvider<
        NotifierT extends AutoDisposeAsyncNotifier<T>, T>
    = AutoDisposeAsyncNotifierProviderImpl<NotifierT, T>;

/// The implementation of [AutoDisposeAsyncNotifierProvider] but with loosened type constraints
/// that can be shared with [AsyncNotifierProvider].
///
/// This enables tests to execute on both [AutoDisposeAsyncNotifierProvider] and
/// [AsyncNotifierProvider] at the same time.
@internal
class AutoDisposeAsyncNotifierProviderImpl<
    NotifierT extends AsyncNotifierBase<T>,
    T> extends AsyncNotifierProviderBase<NotifierT, T> with AsyncSelector<T> {
  /// {@macro riverpod.notifier}
  AutoDisposeAsyncNotifierProviderImpl(
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
  AutoDisposeAsyncNotifierProviderImpl.internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    super.from,
    super.argument,
  });

  /// {@macro riverpod.family}
  static const family = AutoDisposeAsyncNotifierProviderFamily.new;

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
  @mustBeOverridden
  FutureOr<T> runNotifierBuild(AsyncNotifierBase<T> notifier) {
    return (notifier as AutoDisposeAsyncNotifier<T>).build();
  }

  /// {@macro riverpod.override_with}
  @mustBeOverridden
  Override overrideWith(NotifierT Function() create) {
    return ProviderOverride(
      origin: this,
      override: AutoDisposeAsyncNotifierProviderImpl<NotifierT, T>.internal(
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

/// The element of [AutoDisposeAsyncNotifierProvider].
class AutoDisposeAsyncNotifierProviderElement<
        NotifierT extends AsyncNotifierBase<T>,
        T> extends AsyncNotifierProviderElement<NotifierT, T>
    with
        AutoDisposeProviderElementMixin<AsyncValue<T>>
    implements
        // ignore: deprecated_member_use_from_same_package
        AutoDisposeAsyncNotifierProviderRef<T> {
  /// The [ProviderElementBase] for [AsyncNotifierProvider]
  @internal
  AutoDisposeAsyncNotifierProviderElement(super._provider) : super();
}
