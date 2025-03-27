part of '../framework.dart';

/// Represents the subscription to a [ProviderListenable]
@optionalTypeArgs
abstract class ProviderSubscription<State> {
  /// Represents the subscription to a [ProviderListenable]
  ProviderSubscription(this.source) {
    final Object listener = source;
    if (listener is ProviderElementBase) {
      final subs = listener._subscriptions ??= [];
      subs.add(this);
    }
  }

  /// The object that listens to the associated [ProviderListenable].
  ///
  /// This is typically a [ProviderElementBase] or a [ProviderContainer],
  /// but may be other values in the future.
  @internal
  final Node source;

  /// Whether the subscription is closed.
  bool get closed => _closed;
  var _closed = false;

  /// Obtain the latest value emitted by the provider.
  ///
  /// This method throws if [closed] is true.
  State read();

  /// Stops listening to the provider.
  ///
  /// It is safe to call this method multiple times.
  @mustCallSuper
  void close() {
    if (_closed) return;
    _closed = true;

    final Object listener = source;
    if (listener is ProviderElementBase) {
      listener._subscriptions?.remove(this);
    }
  }
}

/// When a provider listens to another provider using `listen`
@optionalTypeArgs
class _ProviderStateSubscription<StateT> extends ProviderSubscription<StateT> {
  _ProviderStateSubscription(
    super.source, {
    required this.listenedElement,
    required this.listener,
    required this.onError,
  }) {
    final dependents = listenedElement._dependents ??= [];
    dependents.add(this);
  }

  // Why can't this be typed correctly?
  final void Function(Object? prev, Object? state) listener;
  final ProviderElementBase<StateT> listenedElement;
  final OnError onError;

  @override
  StateT read() {
    if (_closed) {
      throw StateError(
        'called ProviderSubscription.read on a subscription that was closed',
      );
    }
    return listenedElement.readSelf();
  }

  @override
  void close() {
    if (!closed) {
      listenedElement._dependents?.remove(this);
      listenedElement._onRemoveListener();
    }

    super.close();
  }
}

class _ProxySubscription<T> extends ProviderSubscription<T> {
  _ProxySubscription(
    super.source,
    this._removeListeners,
    this._read, {
    required this.innerSubscription,
  });

  final ProviderSubscription<Object?> innerSubscription;
  final RemoveListener _removeListeners;
  final T Function() _read;

  @override
  T read() {
    if (_closed) {
      throw StateError(
        'called ProviderSubscription.read on a subscription that was closed',
      );
    }
    return _read();
  }

  @override
  void close() {
    if (!closed) {
      innerSubscription.close();
      _removeListeners();
    }

    super.close();
  }
}

class _SelectorSubscription<Input, Output>
    extends ProviderSubscription<Output> {
  _SelectorSubscription(
    super.source,
    this._internalSub,
    this._read, {
    this.onClose,
  });

  final ProviderSubscription<Input> _internalSub;
  final Output Function() _read;
  final void Function()? onClose;

  @override
  void close() {
    if (!closed) {
      onClose?.call();
      _internalSub.close();
    }
    super.close();
  }

  @override
  Output read() {
    if (closed) {
      throw StateError(
        'called ProviderSubscription.read on a subscription that was closed',
      );
    }
    // flushes the provider
    _internalSub.read();

    return _read();
  }
}
