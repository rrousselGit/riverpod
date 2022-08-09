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

class ProviderElementProxy<State>
    with ProviderListenable<State>, AlwaysAliveProviderListenable<State>
    implements AlwaysAliveRefreshable<State> {
  const ProviderElementProxy(this._origin, this.lense);

  final ProviderBase<Object?> _origin;
  final ValueNotifier<State> Function(
    ProviderElementBase element,
    void Function(Listen<State> listen)? setListen,
  ) lense;

  @override
  ProviderSubscription<State> addListener(
    Node node,
    void Function(State? previous, State next) listener, {
    void Function(Object error, StackTrace stackTrace)? onError,
    bool fireImmediately = false,
  }) {
    final element = node.readProviderElement(_origin);

    // TODO does this need a "flush"?

    // TODO remove
    Listen<State>? listen;
    void setListen(Listen<State> _listen) {
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
  State read(Node node) {
    final element = node.readProviderElement(_origin);
    element.flush();
    return lense(element, null).value;
  }

  @override
  bool operator ==(Object other) =>
      other is ProviderElementProxy<State> && other._origin == _origin;

  @override
  int get hashCode => _origin.hashCode;
}
