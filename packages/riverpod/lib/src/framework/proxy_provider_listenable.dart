part of '../framework.dart';

class _ProxySubscription<T> extends ProviderSubscription<T> {
  _ProxySubscription(
    this._removeListeners,
    this._read, {
    required this.listenRemoveListeners,
    required this.innerSubscription,
  });

  final ProviderSubscription innerSubscription;
  final RemoveListener _removeListeners;
  final RemoveListener? listenRemoveListeners;
  final T Function() _read;

  @override
  void close() {
    innerSubscription.close();
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
    required void Function(Object error, StackTrace stackTrace)? onError,
    required void Function()? onDependencyMayHaveChanged,
    required bool fireImmediately,
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
      onDependencyMayHaveChanged: onDependencyMayHaveChanged,
    );

    return _ProxySubscription(
      removeListener,
      () => read(node),
      listenRemoveListeners: listen?.call(listener, onError: onError),

      // While we don't care about changes to the element, calling _listenElement
      // is necessary to tell the listened element that it is being listened.
      innerSubscription: node._listenElement<Object?>(
        element,
        listener: (prev, next) {},
        onError: (err, stack) {},
      ),
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
