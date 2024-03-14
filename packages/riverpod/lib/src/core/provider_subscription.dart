part of '../framework.dart';

/// Represents the subscription to a [ProviderListenable]
@optionalTypeArgs
abstract base class ProviderSubscription<StateT> {
  /// Represents the subscription to a [ProviderListenable]
  ProviderSubscription(this.source) {
    final Object listener = source;
    if (listener is ProviderElement) {
      final subs = listener._subscriptions ??= [];
      subs.add(this);
    }
  }

  /// The object that listens to the associated [ProviderListenable].
  ///
  /// This is typically a [ProviderElement] or a [ProviderContainer],
  /// but may be other values in the future.
  final Node source;

  /// Whether the subscription is closed.
  bool get closed => _closed;
  var _closed = false;

  /// Obtain the latest value emitted by the provider.
  ///
  /// This method throws if [closed] is true.
  StateT read();

  /// Stops listening to the provider.
  ///
  /// It is safe to call this method multiple times.
  @mustCallSuper
  void close() {
    if (_closed) return;
    _closed = true;

    final Object listener = source;
    if (listener is ProviderElement) {
      listener._subscriptions?.remove(this);
    }
  }
}

/// When a provider listens to another provider using `listen`
@optionalTypeArgs
final class _ProviderStateSubscription<StateT>
    extends ProviderSubscription<StateT> {
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
  final ProviderElement<StateT> listenedElement;
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

/// Deals with the internals of synchronously calling the listeners
/// when using `fireImmediately: true`
void _handleFireImmediately<StateT>(
  Result<StateT> currentState, {
  required void Function(StateT? previous, StateT current) listener,
  required void Function(Object error, StackTrace stackTrace) onError,
}) {
  switch (currentState) {
    case ResultData():
      runBinaryGuarded(listener, null, currentState.state);
    case ResultError():
      runBinaryGuarded(onError, currentState.error, currentState.stackTrace);
  }
}
