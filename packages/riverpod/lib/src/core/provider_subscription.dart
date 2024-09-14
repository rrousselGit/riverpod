part of '../framework.dart';

/// Represents the subscription to a [ProviderListenable].
///
// This always is implemented with ProviderSubscriptionWithOrigin.
// This interface exists to remove the redundant type parameters.
@optionalTypeArgs
sealed class ProviderSubscription<OutT> {
  /// Whether the subscription is closed.
  bool get closed;
  bool get weak;
  bool get isPaused;

  /// The object that listens to the associated [ProviderListenable].
  ///
  /// This is typically a [ProviderElement] or a [ProviderContainer],
  /// but may be other values in the future.
  Node get source;

  void pause();
  void resume();

  /// Obtain the latest value emitted by the provider.
  ///
  /// This method throws if [closed] is true.
  OutT read();

  /// Stops listening to the provider.
  ///
  /// It is safe to call this method multiple times.
  void close();
}

@optionalTypeArgs
sealed class ProviderSubscriptionWithOrigin<OutT, StateT>
    extends ProviderSubscription<OutT> {
  ProviderBase<StateT> get origin;
  ProviderElement<StateT> get _listenedElement;

  void _notify(StateT? prev, StateT next);

  void _notifyError(Object error, StackTrace stackTrace);
}

@internal
@optionalTypeArgs
abstract base class ProviderSubscriptionImpl<OutT, StateT>
    extends ProviderSubscriptionWithOrigin<OutT, StateT> with _OnPauseMixin {
  @override
  bool get isPaused => _isPaused;

  /// Whether the subscription is closed.
  @override
  bool get closed => _closed;
  var _closed = false;

  /// Stops listening to the provider.
  ///
  /// It is safe to call this method multiple times.
  @override
  @mustCallSuper
  void close() {
    if (_closed) return;
    _closed = true;

    _listenedElement.removeDependentSubscription(this);
  }
}

mixin _OnPauseMixin {
  bool get _isPaused => _pauseCount > 0;
  var _pauseCount = 0;

  @mustCallSuper
  void pause() {
    if (_pauseCount == 0) {
      onCancel();
    }
    _pauseCount++;
  }

  @mustCallSuper
  void resume() {
    if (_pauseCount == 1) {
      onResume();
    }
    _pauseCount = min(_pauseCount - 1, 0);
  }

  void onResume();

  void onCancel();
}

@internal
abstract base class DelegatingProviderSubscription<OutT, StateT>
    extends ProviderSubscriptionImpl<OutT, StateT> {
  @override
  ProviderBase<StateT> get origin => innerSubscription.origin;

  @override
  ProviderElement<StateT> get _listenedElement =>
      innerSubscription._listenedElement;

  ProviderSubscriptionWithOrigin<Object?, StateT> get innerSubscription;

  @override
  bool get weak => innerSubscription.weak;

  @override
  Node get source => innerSubscription.source;

  @override
  void _notify(StateT? prev, StateT next) {
    innerSubscription._notify(prev, next);
  }

  @override
  void _notifyError(Object error, StackTrace stackTrace) {
    innerSubscription._notifyError(error, stackTrace);
  }

  @override
  void onCancel() {
    switch (innerSubscription) {
      case final ProviderSubscriptionImpl<Object?, StateT> sub:
        sub.onCancel();
    }
  }

  @override
  void onResume() {
    switch (innerSubscription) {
      case final ProviderSubscriptionImpl<Object?, StateT> sub:
        sub.onResume();
    }
  }

  @override
  void pause() {
    innerSubscription.pause();
    super.pause();
  }

  @override
  void resume() {
    innerSubscription.resume();
    super.resume();
  }

  @override
  void close() {
    if (_closed) return;

    innerSubscription.close();
    super.close();
  }
}

/// When a provider listens to another provider using `listen`
@internal
final class ProviderStateSubscription<StateT>
    extends ProviderSubscriptionImpl<StateT, StateT> with _OnPauseMixin {
  ProviderStateSubscription({
    required this.source,
    required this.weak,
    required ProviderElement<StateT> listenedElement,
    required this.listener,
    required this.onError,
  }) : _listenedElement = listenedElement;

  @override
  ProviderBase<StateT> get origin => _listenedElement.origin;

  @override
  final Node source;
  @override
  final ProviderElement<StateT> _listenedElement;
  @override
  final bool weak;

  // Why can't this be typed correctly?
  final void Function(Object? prev, Object? state) listener;
  final OnError onError;

  /// Whether an event was sent while this subscription was paused.
  ///
  /// This enables re-rending the last missing event when the subscription is resumed.
  ({
    (StateT?, StateT)? data,
    (Object, StackTrace)? error,
  })? _missedCalled;

  @override
  StateT read() {
    if (_closed) {
      throw StateError(
        'called ProviderSubscription.read on a subscription that was closed',
      );
    }
    _listenedElement.mayNeedDispose();
    return _listenedElement.readSelf();
  }

  @override
  void onCancel() => _listenedElement.onSubscriptionPause(this);

  @override
  void onResume() {
    _listenedElement.onSubscriptionResume(this);
    if (_missedCalled?.data case final event?) {
      final prev = event.$1;
      final next = event.$2;

      _missedCalled = null;
      listener(prev, next);
    } else if (_missedCalled?.error case final event?) {
      final error = event.$1;
      final stackTrace = event.$2;

      _missedCalled = null;
      onError(error, stackTrace);
    }
  }

  @override
  void _notify(StateT? prev, StateT next) {
    if (_isPaused) {
      _missedCalled = (data: (prev, next), error: null);
      return;
    }

    listener(prev, next);
  }

  @override
  void _notifyError(Object error, StackTrace stackTrace) {
    if (_isPaused) {
      _missedCalled = (data: null, error: (error, stackTrace));
      return;
    }

    onError(error, stackTrace);
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
