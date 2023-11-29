part of 'framework.dart';

class Ref<StateT> {
  Ref._(this._element);

  final ProviderElement<StateT> _element;

  ProviderContainer get container => _element.container;

  abstract StateT state;

  FutureOr<StateT> get future;

  @useResult
  T refresh<T>(Refreshable<T> provider);
  void invalidate(ProviderOrFamily provider);
  void invalidateSelf({bool isReload = false});

  void notifyListeners();

  void onAddListener(VoidCallback cb);
  void onRemoveListener(VoidCallback cb);
  void onResume(VoidCallback cb);
  void onCancel(VoidCallback cb);
  void onDispose(VoidCallback cb);

  bool exists(Provider<Object?> provider);

  T read<T>(ProviderListenable<T> provider);
  T watch<T>(ProviderListenable<T> provider);

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
