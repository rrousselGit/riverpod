part of '../async_notifier.dart';

abstract class AutoDisposeAsyncNotifier<State>
    extends AsyncNotifierBase<State> {
  late final AutoDisposeAsyncNotifierProviderElement<
      AutoDisposeAsyncNotifier<State>, State> _element;

  @override
  void _setElement(ProviderElementBase<AsyncValue<State>> element) {
    _element = element as AutoDisposeAsyncNotifierProviderElement<
        AutoDisposeAsyncNotifier<State>, State>;
  }

  @override
  AutoDisposeAsyncNotifierProviderRef<State> get ref => _element;
}

/// {@macro riverpod.providerrefbase}
abstract class AutoDisposeAsyncNotifierProviderRef<T>
    implements AsyncNotifierProviderRef<T>, AutoDisposeRef<AsyncValue<T>> {}

/// {@macro riverpod.asyncnotifier}
typedef AutoDisposeAsyncNotifierProvider<
        NotifierT extends AutoDisposeAsyncNotifier<T>, T>
    = TestAutoDisposeAsyncNotifierProvider<NotifierT, T>;

/// The implementation of [AutoDisposeAsyncNotifierProvider] but with loosened type constraints
/// that can be shared with [AsyncNotifierProvider].
///
/// This enables tests to execute on both [AutoDisposeAsyncNotifierProvider] and
/// [AsyncNotifierProvider] at the same time.
class TestAutoDisposeAsyncNotifierProvider<
        NotifierT extends AsyncNotifierBase<T>,
        T> extends AsyncNotifierProviderBase<NotifierT, T>
    with AlwaysAliveProviderBase<AsyncValue<T>>, AlwaysAliveAsyncSelector<T> {
  /// {@macro riverpod.notifier}
  TestAutoDisposeAsyncNotifierProvider(
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
  AutoDisposeAsyncNotifierProviderElement<NotifierT, T> createElement() {
    return AutoDisposeAsyncNotifierProviderElement._(this);
  }

  @override
  late final AlwaysAliveRefreshable<NotifierT> notifier =
      _notifier<NotifierT, T>(this);

  @override
  late final AlwaysAliveProviderListenable<Future<T>> future = _future<T>(this);
}

class AutoDisposeAsyncNotifierProviderElement<
        NotifierT extends AsyncNotifierBase<T>,
        T> = AsyncNotifierProviderElement<NotifierT, T>
    with AutoDisposeProviderElementMixin<AsyncValue<T>>
    implements AutoDisposeAsyncNotifierProviderRef<T>;
