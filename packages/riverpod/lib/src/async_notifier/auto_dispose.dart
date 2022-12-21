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
  AutoDisposeAsyncNotifierProviderRef<State> get ref => _element;
}

/// {@macro riverpod.asyncnotifier}
abstract class AutoDisposeAsyncNotifier<State>
    extends BuildlessAutoDisposeAsyncNotifier<State> {
  /// {@macro riverpod.asyncnotifier.build}
  @visibleForOverriding
  FutureOr<State> build();
}

/// {@macro riverpod.providerrefbase}
abstract class AutoDisposeAsyncNotifierProviderRef<T>
    implements AsyncNotifierProviderRef<T>, AutoDisposeRef<AsyncValue<T>> {}

/// {@macro riverpod.asyncnotifier}
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
    super.from,
    super.argument,
    super.dependencies,
    super.debugGetCreateSourceHash,
  });

  /// {@macro riverpod.family}
  static const family = AutoDisposeAsyncNotifierProviderFamily.new;

  @override
  late final Refreshable<NotifierT> notifier = _notifier<NotifierT, T>(this);

  @override
  late final Refreshable<Future<T>> future = _future<T>(this);

  @override
  AutoDisposeAsyncNotifierProviderElement<NotifierT, T> createElement() {
    return AutoDisposeAsyncNotifierProviderElement._(this);
  }

  @override
  FutureOr<T> runNotifierBuild(AsyncNotifierBase<T> notifier) {
    return (notifier as AutoDisposeAsyncNotifier<T>).build();
  }

  /// {@macro riverpod.overridewith}
  Override overrideWith(NotifierT Function() create) {
    return ProviderOverride(
      origin: this,
      override: AutoDisposeAsyncNotifierProviderImpl<NotifierT, T>(
        create,
        from: from,
        argument: argument,
      ),
    );
  }
}

/// The element of [AutoDisposeAsyncNotifierProvider].
class AutoDisposeAsyncNotifierProviderElement<
        NotifierT extends AsyncNotifierBase<T>,
        T> extends AsyncNotifierProviderElement<NotifierT, T>
    with AutoDisposeProviderElementMixin<AsyncValue<T>>
    implements AutoDisposeAsyncNotifierProviderRef<T> {
  /// The [ProviderElementBase] for [AsyncNotifierProvider]
  AutoDisposeAsyncNotifierProviderElement._(super.provider) : super._();
}
