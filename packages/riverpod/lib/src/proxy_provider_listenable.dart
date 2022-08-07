import '../riverpod.dart';
import 'framework.dart';
import 'listenable.dart';

class _ProviderSubscription<T> extends ProviderSubscription<T> {
  _ProviderSubscription(
    this._removeListeners,
    this._read, {
    this.listenRemoveListeners,
  });

  final RemoveListener _removeListeners;
  final RemoveListener? listenRemoveListeners;
  final T Function() _read;

  @override
  void close() {
    listenRemoveListeners?.call();
    _removeListeners();
  }

  @override
  T read() => _read();
}

typedef Listen<R> = RemoveListener Function(
  void Function(R? previous, R next) listener, {
  void Function(Object error, StackTrace stackTrace)? onError,
});

class ProviderElementProxy<R>
    with ProviderListenable<R>, AlwaysAliveProviderListenable<R> {
  const ProviderElementProxy(this.origin, this.lense);

  final ProviderBase<Object?> origin;
  final ValueNotifier<R> Function(
    ProviderElementBase element,
    void Function(Listen<R> listen)? setListen,
  ) lense;

  @override
  ProviderSubscription<R> addListener(
    Node node,
    void Function(R? previous, R next) listener, {
    void Function(Object error, StackTrace stackTrace)? onError,
    bool fireImmediately = false,
  }) {
    final element = node.readProviderElement(origin);

    // TODO remove
    Listen<R>? listen;
    void setListen(Listen<R> _listen) {
      listen = _listen;
    }

    final removeListener = lense(element, setListen).addListener(
      listener,
      onError: onError,
      fireImmediately: fireImmediately,
    );

    return _ProviderSubscription(
      removeListener,
      () => read(node),
      listenRemoveListeners: listen?.call(listener, onError: onError),
    );
  }

  @override
  R read(Node node) {
    final element = node.readProviderElement(origin);
    return lense(element, null).value;
  }

  @override
  bool operator ==(Object other) =>
      other is ProviderElementProxy<R> && other.origin == origin;

  @override
  int get hashCode => origin.hashCode;
}
