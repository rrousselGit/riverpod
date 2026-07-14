part of '../../framework.dart';

/// Adds [listenable] to [ProviderListenable].
extension ProviderListenableListenable<T> on ProviderListenable<T> {
  /// Exposes a [ValueListenable] that tracks the state of this provider.
  ProviderListenable<ValueListenable<T>> get listenable {
    return _ListenableListenable(this);
  }
}

@immutable
class _ListenableListenable<T>
    extends CustomProviderListenable<T, ValueListenable<T>> {
  _ListenableListenable(this.source);

  @override
  final ProviderListenable<T> source;

  @override
  _ListenableTransformer2<T> createTransformer() {
    return _ListenableTransformer2();
  }

  @override
  bool operator ==(Object other) =>
      other is _ListenableListenable<T> && other.source == source;

  @override
  int get hashCode => Object.hash(T, source);
}

final class _ListenableTransformer2<T>
    extends
        SyncProviderTransformer2<
          T,
          ValueListenable<T>,
          _ListenableListenable<T>
        >
    with ChangeNotifier
    implements ValueListenable<T> {
  @override
  T get value => read();

  @override
  ValueListenable<T> initState() {
    // Start paused so that if no listener is added to the listenable,
    // the source provider is paused.
    pause();
    return this;
  }

  @override
  void onEvent(
    ProviderTransformer2<T, ValueListenable<T>, _ListenableListenable<T>> self,
    AsyncResult<T> prev,
    AsyncResult<T> next,
  ) {
    notifyListeners();
  }

  @override
  void addListener(VoidCallback listener) {
    if (!hasListeners) resume();

    super.addListener(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    final hadListeners = hasListeners;
    super.removeListener(listener);

    if (!hasListeners && hadListeners) pause();
  }

  @override
  void onClose() {
    dispose();
  }
}
