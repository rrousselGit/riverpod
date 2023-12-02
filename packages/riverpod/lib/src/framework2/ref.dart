part of 'framework.dart';

class Ref<StateT> {
  Ref._(this._element);

  final ProviderElement<StateT> _element;

  ProviderContainer get container => _element.container;

  // Explain that calling `state=` while the provider is synchronously building will not notify listeners
  // And that if no state= is called, then after the synchronous execution has completed, the current state will be emitted
  abstract StateT state;

  FutureOr<StateT> get future;

  @useResult
  T refresh<T>(Refreshable<T> provider);
  void invalidate(ProviderOrFamily provider);
  void invalidateSelf() => _element.markNeedsRefresh();
  void reloadSelf() => _element.markNeedsReload();

  void notifyListeners();

  void onAddListener(VoidCallback cb);
  void onRemoveListener(VoidCallback cb);
  void onResume(VoidCallback cb);
  void onCancel(VoidCallback cb);
  void onDispose(VoidCallback cb);

  bool exists(Provider<Object?> provider);

  T read<T>(ProviderListenable<T> provider) {
    final subscription = listen<T>(provider, (_, value) {});
    try {
      return subscription.read();
    } finally {
      subscription.close();
    }
  }

  T watch<T>(ProviderListenable<T> provider) {
    final subscription = listen<T>(provider, (_, value) => reloadSelf());
    onDispose(subscription.close);

    return subscription.read();
  }

  ProviderSubscription<T> listen<T>(
    ProviderListenable<T> provider,
    ProviderListener<T> listener, {
    OnError? onError,
    bool fireImmediately = false,
  });
  void listenSelf(
    ProviderListener<StateT> listener, {
    OnError? onError,
  });
}
