part of '../framework.dart';

/// Represents the subscription to a [ProviderListenable]
abstract class ProviderSubscription<StateT> {
  /// Stops listening to the provider
  @mustCallSuper
  void close();

  /// Obtain the latest value emitted by the provider
  StateT read();
}

/// When a provider listens to another provider using `listen`
class _ProviderListener<StateT> implements ProviderSubscription<StateT> {
  _ProviderListener._({
    required this.listenedElement,
    required this.dependentElement,
    required this.listener,
    required this.onError,
  });

// TODO can't we type it properly?
  final void Function(Object? prev, Object? state) listener;
  final ProviderElementBase<Object?> dependentElement;
  final ProviderElementBase<StateT> listenedElement;
  final OnError onError;

  @override
  void close() {
    dependentElement._listenedProviderSubscriptions.remove(this);
    listenedElement
      .._subscribers.remove(this)
      .._onRemoveListener();
  }

  @override
  StateT read() => listenedElement.readSelf();
}

var _debugIsRunningSelector = false;

class _ExternalProviderSubscription<StateT>
    implements ProviderSubscription<StateT> {
  _ExternalProviderSubscription._(
    this._listenedElement,
    this._listener, {
    required this.onError,
  });

  final void Function(StateT? previous, StateT next) _listener;
  final ProviderElementBase<StateT> _listenedElement;
  final void Function(Object error, StackTrace stackTrace) onError;
  var _closed = false;

  @override
  void close() {
    _closed = true;
    _listenedElement._externalDependents.remove(this);
    _listenedElement._onRemoveListener();
  }

  @override
  StateT read() {
    if (_closed) {
      throw StateError(
        'called ProviderSubscription.read on a subscription that was closed',
      );
    }
    return _listenedElement.readSelf();
  }
}

/// Deals with the internals of synchronously calling the listeners
/// when using `fireImmediately: true`
void _handleFireImmediately<StateT>(
  Result<StateT> currentState, {
  required void Function(StateT? previous, StateT current) listener,
  required void Function(Object error, StackTrace stackTrace) onError,
}) {
  currentState.map(
    data: (data) => runBinaryGuarded(listener, null, data.state),
    error: (error) => runBinaryGuarded(onError, error.error, error.stackTrace),
  );
}
