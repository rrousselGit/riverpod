part of '../async_notifier.dart';

abstract class AutoDisposeAsyncNotifierFamily<State, Arg>
    extends AsyncNotifierBase<State> {
  late final Arg arg;

  late final AutoDisposeAsyncNotifierProviderElement<
      AutoDisposeAsyncNotifierFamily<State, Arg>, State> _element;

  @override
  void _setElement(ProviderElementBase<AsyncValue<State>> element) {
    _element = element as AutoDisposeAsyncNotifierProviderElement<
        AutoDisposeAsyncNotifierFamily<State, Arg>, State>;
    arg = element.origin.argument as Arg;
  }

  @override
  AutoDisposeAsyncNotifierProviderRef<State> get ref => _element;

  @visibleForOverriding
  FutureOr<State> build(Arg arg);
}

/// {@macro riverpod.asyncnotifier}
typedef AutoDisposeAsyncNotifierProviderFamily<
        NotifierT extends AutoDisposeAsyncNotifierFamily<T, Arg>, T, Arg>
    = TestAutoDisposeAsyncNotifierProviderFamily<NotifierT, T, Arg>;

/// The implementation of [AutoDisposeAsyncNotifierProvider] but with loosened type constraints
/// that can be shared with [AsyncNotifierProvider].
///
/// This enables tests to execute on both [AutoDisposeAsyncNotifierProvider] and
/// [AsyncNotifierProvider] at the same time.
class TestAutoDisposeAsyncNotifierProviderFamily<
    NotifierT extends AsyncNotifierBase<T>,
    T,
    Arg> extends AsyncNotifierProviderBase<NotifierT, T> with AsyncSelector<T> {
  /// {@macro riverpod.notifier}
  TestAutoDisposeAsyncNotifierProviderFamily(
    super._createNotifier, {
    super.name,
    super.from,
    super.argument,
    super.dependencies,
  }) : super(cacheTime: null, disposeDelay: null);

  // /// {@macro riverpod.autoDispose}
  // static const autoDispose = AutoDisposeAutoDisposeAsyncNotifierProviderBuilder();

  // /// {@macro riverpod.family}
  // static const family = AutoDisposeAsyncNotifierProviderFamilyBuilder();

  @override
  late final AlwaysAliveRefreshable<NotifierT> notifier =
      _notifier<NotifierT, T>(this);

  @override
  late final AlwaysAliveProviderListenable<Future<T>> future = _future<T>(this);

  @override
  AutoDisposeAsyncNotifierProviderElement<NotifierT, T> createElement() {
    return AutoDisposeAsyncNotifierProviderElement._(this);
  }

  @override
  FutureOr<T> _runNotifierBuild(
    covariant AutoDisposeAsyncNotifierFamily<T, Arg> notifier,
  ) {
    return notifier.build(notifier.arg);
  }
}
