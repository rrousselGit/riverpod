part of 'framework.dart';

class Ref<StateT> {
  Ref._(this._element);

  bool get mounted => !_element.disposed;
  var _mounted = false;

  ProviderContainer get container {
    _assertNotDisposed();
    return _element.container;
  }

  // TODO deprecate state=
  // StateT get state {
  //   _assertNotDisposed();
  // }

  // TODO
  // FutureOr<StateT> get future {
  //   _assertNotDisposed();
  // }

  final ProviderElement<StateT> _element;

  void _assertNotDisposed() {
    assert(
      !_mounted,
      '''
Cannot use a disposed "ref". This may happen is:
- You are using a "ref" on a provider that was disposed (such as because it was no-longer listened).
- Your provider rebuilt, and therefore a more up-to-date "ref" is available.
''',
    );
  }

  @useResult
  T refresh<T>(Refreshable<T> provider) {
    _assertNotDisposed();
    return container.refresh(
      provider,
      debugDependentSource: kDebugMode
          ? DebugRefRefreshDependentSource(provider: _element.provider)
          : null,
    );
  }

  void invalidate(ProviderOrFamily provider, {bool asReload = false}) {
    _assertNotDisposed();
    container.invalidate(
      provider,
      asReload: asReload,
      debugDependentSource: kDebugMode
          ? DebugRefInvalidateDependentSource(provider: _element.provider)
          : null,
    );
  }

  // TODO remove Reload dependent source

  bool exists(Provider<Object?> provider) {
    _assertNotDisposed();
    return container.exists(
      provider,
      debugDependentSource: kDebugMode
          ? DebugRefExistsDependentSource(provider: _element.provider)
          : null,
    );
  }

  void invalidateSelf() {
    _assertNotDisposed();
    _element.markNeedsRebuild();
  }

  void reloadSelf() {
    _assertNotDisposed();
    _element.markNeedsRebuild(asReload: true);
  }

  // TODO
  // void notifyListeners() => _element.notifyListeners();

  // void onAddListener(OnAddListener cb) {
  //   _assertNotDisposed();
  //   _element.onAddListener(cb);
  // }

  // void onRemoveListener(OnRemoveListener cb) {
  //   _assertNotDisposed();
  //   _element.onRemoveListener(cb);
  // }

  // void onResume(OnResume cb) {
  //   _assertNotDisposed();
  //   _element.onResume(cb);
  // }

  // void onCancel(OnCancel cb) {
  //   _assertNotDisposed();
  //   _element.onCancel(cb);
  // }

  // void onDispose(OnDispose cb) {
  //   _assertNotDisposed();
  //   _element.onDispose(cb);
  // }

  T read<T>(ProviderListenable<T> provider) {
    _assertNotDisposed();
    final subscription = container.listen<T>(
      provider,
      (_, value) {},
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
    final subscription = container.listen<T>(
      provider,
      (_, value) => reloadSelf(),
      debugDependentSource: kDebugMode
          ? DebugRefWatchDependentSource(provider: _element.provider)
          : null,
    );

    return subscription.read();
  }

  ProviderSubscription<T> listen<T>(
    ProviderListenable<T> provider,
    ProviderListener<T> listener, {
    OnError? onError,
    VoidCallback? onCancel,
    bool fireImmediately = false,
  }) {
    _assertNotDisposed();
    return container.listen(
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

  // Mention bout listening to self does not cause a provider to be "unpaused".
  // TODO void listenSelf(
  //   ProviderListener<StateT> listener, {
  //   OnError? onError,
  // }) {
  //   _assertNotDisposed();
  //   _element._listenSelf(listener, onError);
  // }

  void _dispose() => _mounted = true;
}
