part of '../framework.dart';

class _ProxySubscription<T> extends ProviderSubscription<T> {
  _ProxySubscription(
    this._removeListeners,
    this._read, {
    required this.listenRemoveListeners,
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

    // TODO does this need a "flush"?

    // TODO remove
    Listen<R>? listen;
    void setListen(Listen<R> _listen) {
      listen = _listen;
    }

    final notifier = lense(element, setListen);
    if (fireImmediately) {
      notifier.result?.when(
        data: (data) {
          runBinaryGuarded(listener, null, data);
        },
        error: (err, stack) {
          if (onError != null) {
            runBinaryGuarded(onError, err, stack);
          }
        },
      );
    }

    final removeListener = notifier.addListener(
      listener,
      onError: onError,
    );

    return _ProxySubscription(
      removeListener,
      () => read(node),
      listenRemoveListeners: listen?.call(listener, onError: onError),
    );
  }

  @override
  R read(Node node) {
    final element = node.readProviderElement(origin);
    element.flush();
    return lense(element, null).value;
  }

  @override
  bool operator ==(Object other) =>
      other is ProviderElementProxy<R> && other.origin == origin;

  @override
  int get hashCode => origin.hashCode;
}
