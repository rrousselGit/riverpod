part of '../async_notifier.dart';

/// A [StreamNotifier] base class shared between family and non-family notifiers.
///
/// Not meant for public consumption outside of riverpod_generator
@internal
abstract class BuildlessStreamNotifier<State> extends AsyncNotifierBase<State> {
  @override
  late final StreamNotifierProviderElement<AsyncNotifierBase<State>, State>
      _element;

  @override
  void _setElement(ProviderElementBase<AsyncValue<State>> element) {
    _element = element
        as StreamNotifierProviderElement<AsyncNotifierBase<State>, State>;
  }

  @override
  // ignore: deprecated_member_use_from_same_package
  StreamNotifierProviderRef<State> get ref => _element;
}

/// {@template riverpod.streamNotifier}
/// A variant of [AsyncNotifier] which has [build] creating a [Stream].
///
/// This can be considered as a [StreamProvider] that can mutate its value over time.
///
/// The syntax for using this provider is slightly different from the others
/// in that the provider's function doesn't receive a "ref" (and in case
/// of `family`, doesn't receive an argument either).
/// Instead the ref (and argument) are directly accessible in the associated
/// [AsyncNotifier].
///
/// This can be considered as a [StreamProvider] that can mutate its value over time.
/// When using `autoDispose` or `family`, your notifier type changes.
/// Instead of extending [StreamNotifier], you should extend either:
/// - [AutoDisposeStreamNotifier] for `autoDispose`
/// - [FamilyStreamNotifier] for `family`
/// - [AutoDisposeFamilyStreamNotifier] for `autoDispose.family`
///
/// {@endtemplate}
abstract class StreamNotifier<State> extends BuildlessStreamNotifier<State> {
  /// {@macro riverpod.async_notifier.build}
  @visibleForOverriding
  Stream<State> build();
}

/// {@macro riverpod.provider_ref_base}
@Deprecated('will be removed in 3.0.0. Use Ref instead')
abstract class StreamNotifierProviderRef<T> implements Ref<AsyncValue<T>> {}

/// {@macro riverpod.streamNotifier}
typedef StreamNotifierProvider<NotifierT extends StreamNotifier<T>, T>
    = StreamNotifierProviderImpl<NotifierT, T>;

/// The implementation of [StreamNotifierProvider] but with loosened type constraints
/// that can be shared with [AutoDisposeStreamNotifierProvider].
///
/// This enables tests to execute on both [StreamNotifierProvider] and
/// [AutoDisposeStreamNotifierProvider] at the same time.
@visibleForTesting
@internal
class StreamNotifierProviderImpl<NotifierT extends AsyncNotifierBase<T>, T>
    extends StreamNotifierProviderBase<NotifierT, T>
    with
        // ignore: deprecated_member_use_from_same_package
        AlwaysAliveProviderBase<AsyncValue<T>>,
        AlwaysAliveAsyncSelector<T> {
  /// {@macro riverpod.streamNotifier}
  StreamNotifierProviderImpl(
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
  StreamNotifierProviderImpl.internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    super.from,
    super.argument,
  });

  /// {@macro riverpod.autoDispose}
  static const autoDispose = AutoDisposeStreamNotifierProviderBuilder();

  /// {@macro riverpod.family}
  static const family = StreamNotifierProviderFamilyBuilder();

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
  Stream<T> runNotifierBuild(AsyncNotifierBase<T> notifier) {
    // Not using "covariant" as riverpod_generator subclasses this with a
    // different notifier type
    return (notifier as StreamNotifier<T>).build();
  }

  /// {@macro riverpod.override_with}
  @mustBeOverridden
  Override overrideWith(NotifierT Function() create) {
    return ProviderOverride(
      origin: this,
      override: StreamNotifierProviderImpl<NotifierT, T>.internal(
        create,
        from: from,
        argument: argument,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
      ),
    );
  }
}

/// The element of [StreamNotifierProvider].
class StreamNotifierProviderElement<NotifierT extends AsyncNotifierBase<T>, T>
    extends AsyncNotifierProviderElementBase<NotifierT, T>
    implements
        // ignore: deprecated_member_use_from_same_package
        StreamNotifierProviderRef<T> {
  /// The element of [StreamNotifierProvider].
  @internal
  StreamNotifierProviderElement(
    StreamNotifierProviderBase<NotifierT, T> super._provider,
  );

  @override
  void create({required bool didChangeDependency}) {
    final provider = this.provider as StreamNotifierProviderBase<NotifierT, T>;

    final notifierResult = _notifierNotifier.result ??= Result.guard(() {
      return provider._createNotifier().._setElement(this);
    });

    notifierResult.when(
      error: (error, stackTrace) {
        onError(AsyncError(error, stackTrace), seamless: !didChangeDependency);
      },
      data: (notifier) {
        handleStream(
          () => provider.runNotifierBuild(notifier),
          didChangeDependency: didChangeDependency,
        );
      },
    );
  }
}
