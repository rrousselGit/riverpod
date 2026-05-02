part of '../framework.dart';

@internal
abstract class BaseWidgetRef {
  void watch<StateT>(ProviderListenable<StateT> provider);
  void exists(ProviderBase<Object?> provider);
  void listen<StateT>(
    ProviderListenable<StateT> provider,
    void Function(StateT? previous, StateT next) listener, {
    void Function(Object error, StackTrace stackTrace)? onError,
  });
  void listenManual<StateT>(
    ProviderListenable<StateT> provider,
    void Function(StateT? previous, StateT next) listener, {
    void Function(Object error, StackTrace stackTrace)? onError,
    bool fireImmediately,
  });
  void read<StateT>(ProviderListenable<StateT> provider);
  void refresh<StateT>(Refreshable<StateT> provider);
  void invalidate(ProviderOrFamily provider, {bool asReload});
}

@internal
abstract class BaseRef {
  void keepAlive();
  void refresh<StateT>(Refreshable<StateT> refreshable);
  void invalidate(ProviderOrFamily providerOrFamily, {bool asReload});
  void invalidateSelf({bool asReload});
  void notifyListeners();
  void onAddListener(void Function() cb);
  void onRemoveListener(void Function() cb);
  void onCancel(void Function() cb);
  void onResume(void Function() cb);
  void onDispose(void Function() listener);
  void read<StateT>(ProviderListenable<StateT> listenable);
  void exists(ProviderBase<Object?> provider);
  void watch<StateT>(ProviderListenable<StateT> listenable);
  void listen<StateT>(
    ProviderListenable<StateT> provider,
    void Function(StateT? previous, StateT next) listener, {
    void Function(Object error, StackTrace stackTrace)? onError,
    bool weak,
    bool fireImmediately,
  });
}
