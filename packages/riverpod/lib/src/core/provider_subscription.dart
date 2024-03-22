part of '../framework.dart';

/// Represents the subscription to a [ProviderListenable]
@optionalTypeArgs
abstract base class ProviderSubscription<StateT> {
  /// Represents the subscription to a [ProviderListenable]
  ProviderSubscription(this.source) {
    final source = this.source;
    if (source is ProviderElement) {
      final subs = source._subscriptions ??= [];
      subs.add(this);
    }
  }

  /// Whether the subscription is closed.
  bool get closed => _closed;
  var _closed = false;

  bool get isPaused;

  /// The object that listens to the associated [ProviderListenable].
  ///
  /// This is typically a [ProviderElement] or a [ProviderContainer],
  /// but may be other values in the future.
  final Node source;

  void pause();
  void resume();

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

mixin _OnPauseMixin {
  bool get _isPaused => _pauseCount > 0;
  var _pauseCount = 0;

  @mustCallSuper
  void pause() {
    if (_pauseCount == 0) {
      _onCancel();
    }
    _pauseCount++;
  }

  @mustCallSuper
  void resume() {
    if (_pauseCount == 1) {
      _onResume();
    }
    _pauseCount = min(_pauseCount - 1, 0);
  }

  void _onResume();

  void _onCancel();
}

/// When a provider listens to another provider using `listen`
@optionalTypeArgs
final class _ProviderStateSubscription<StateT>
    extends ProviderSubscription<StateT> with _OnPauseMixin {
  _ProviderStateSubscription(
    super.source, {
    required this.listenedElement,
    required this.listener,
    required this.onError,
  }) {
    switch (source) {
      case WeakNode():
        listenedElement._weakDependents.add(this);
      case _:
        final dependents = listenedElement._dependents ??= [];
        dependents.add(this);
    }
  }

  @override
  bool get isPaused => _isPaused;

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
    listenedElement._mayNeedDispose();
    return listenedElement.readSelf();
  }

  @override
  void close() {
    if (!closed) {
      // if (isPaused) {
      //   listenedElement._onSubscriptionResume(weak: source.weak);
      // }
      listenedElement._onRemoveListener(
        () {
          switch (source) {
            case WeakNode():
              listenedElement._weakDependents.remove(this);
            case _:
              listenedElement._dependents?.remove(this);
          }

          return this;
        },
      );
    }

    super.close();
  }

  @override
  void _onCancel() => listenedElement._onSubscriptionPause(weak: source.weak);

  @override
  void _onResume() => listenedElement._onSubscriptionResume(weak: source.weak);
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
