part of 'framework.dart';

class Ref<StateT> {
  Ref._(this._element);

  final ProviderElement<StateT> _element;

  ProviderContainer get container => _element.container;

  // TODO deprecate state=
  StateT get state;

  FutureOr<StateT> get future;

  @useResult
  T refresh<T>(Refreshable<T> provider);
  void invalidate(ProviderOrFamily provider);
  void reload(ProviderOrFamily provider);
  void invalidateSelf() => _element.markNeedsRefresh();
  void reloadSelf() => _element.markNeedsReload();

  void notifyListeners();

  void onAddListener(OnAddListener cb);
  void onRemoveListener(OnRemoveListener cb);
  void onResume(OnResume cb);
  void onCancel(OnCancel cb);
  void onDispose(OnDispose cb);

  bool exists(Provider<Object?> provider);

  T read<T>(ProviderListenable<T> provider) {
    final subscription = _listen<T>(
      provider,
      (_, value) {},
      onError: null,
      onCancel: null,
      fireImmediately: false,
      debugDependentSource: kDebugMode
          ? DebugRefReadDependentSource(provider: _element.provider)
          : null,
    );
    try {
      return subscription.read();
    } finally {
      subscription.close();
    }
  }

  T watch<T>(ProviderListenable<T> provider) {
    final subscription = _listen<T>(
      provider,
      (_, value) => reloadSelf(),
      onError: null,
      onCancel: null,
      fireImmediately: false,
      debugDependentSource: kDebugMode
          ? DebugRefWatchDependentSource(provider: _element.provider)
          : null,
    );

    return subscription.read();
  }

  ProviderSubscription<T> _listen<T>(
    ProviderListenable<T> provider,
    ProviderListener<T> listener, {
    required OnError? onError,
    required VoidCallback? onCancel,
    required bool fireImmediately,
    required DebugDependentSource? debugDependentSource,
  }) {
    return provider.addListener(
      container,
      listener,
      fireImmediately: fireImmediately,
      onError: onError,
      onCancel: onCancel,
      dependent: _element,
      debugDependentSource: debugDependentSource,
    );
  }

  ProviderSubscription<T> listen<T>(
    ProviderListenable<T> provider,
    ProviderListener<T> listener, {
    OnError? onError,
    VoidCallback? onCancel,
    bool fireImmediately = false,
  }) {
    return _listen(
      provider,
      listener,
      onError: onError,
      onCancel: onCancel,
      fireImmediately: fireImmediately,
      debugDependentSource: kDebugMode
          ? DebugRefListenDependentSource(provider: _element.provider)
          : null,
    );
  }

  void listenSelf(
    ProviderListener<StateT> listener, {
    OnError? onError,
  });
}
