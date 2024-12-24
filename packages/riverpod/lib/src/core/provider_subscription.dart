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

@internal
@optionalTypeArgs
sealed class ProviderSubscriptionWithOrigin<OutT, StateT>
    extends ProviderSubscription<OutT> implements Pausable {
  ProviderBase<StateT> get origin;
  ProviderElement<StateT> get _listenedElement;

  void _onOriginData(StateT? prev, StateT next);
  void _onOriginError(Object error, StackTrace stackTrace);

  OutT _callRead();

  @override
  OutT read() {
    if (closed) {
      throw StateError(
        'called ProviderSubscription.read on a subscription that was closed',
      );
    }
    _listenedElement.mayNeedDispose();
    _listenedElement.flush();

    return _callRead();
  }
}

@internal
@optionalTypeArgs
abstract base class ProviderSubscriptionImpl<OutT, OriginT>
    extends ProviderSubscriptionWithOrigin<OutT, OriginT> with _OnPauseMixin {
  @override
  bool get isPaused => _isPaused;

  /// Whether the subscription is closed.
  @override
  bool get closed => _closed;
  var _closed = false;

  /// Whether an event was sent while this subscription was paused.
  ///
  /// This enables re-rending the last missing event when the subscription is resumed.
  ({
    (OutT?, OutT)? data,
    (Object, StackTrace)? error,
  })? _missedCalled;
  void Function(OutT? prev, OutT next) get _listener;
  OnError get _errorListener;

  @mustCallSuper
  @override
  void onCancel() {
    _listenedElement.onSubscriptionPause(this);
  }

  @mustCallSuper
  @override
  void onResume() {
    _listenedElement.onSubscriptionResume(this);
    if (_missedCalled?.data case final event?) {
      final prev = event.$1;
      final next = event.$2;

      _missedCalled = null;
      _notifyData(prev, next);
    } else if (_missedCalled?.error case final event?) {
      final error = event.$1;
      final stackTrace = event.$2;

      _missedCalled = null;
      _notifyError(error, stackTrace);
    }
  }

  void _notifyData(OutT? prev, OutT next) {
    if (isPaused) {
      _missedCalled = (data: (prev, next), error: null);
      return;
    }

    _listener(prev, next);
  }

  void _notifyError(Object error, StackTrace stackTrace) {
    if (isPaused) {
      _missedCalled = (data: null, error: (error, stackTrace));
      return;
    }

    _errorListener(error, stackTrace);
  }

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

abstract class Pausable {
  bool get isPaused;

  void pause();
  void resume();

  void onCancel();
  void onResume();
}

mixin _OnPauseMixin on Pausable {
  bool get _isPaused => _pauseCount > 0;
  var _pauseCount = 0;

  @override
  @mustCallSuper
  void pause() {
    final shouldCallCancel = _pauseCount == 0;
    _pauseCount++;

    if (shouldCallCancel) onCancel();
  }

  @override
  @mustCallSuper
  void resume() {
    final shouldCallResume = _pauseCount == 1;
    _pauseCount = math.max(_pauseCount - 1, 0);

    if (shouldCallResume) onResume();
  }

  @override
  void onResume();

  @override
  void onCancel();
}

@internal
base class ProviderSubscriptionView<OutT, OriginT>
    extends ProviderSubscriptionImpl<OutT, OriginT> {
  ProviderSubscriptionView({
    required this.innerSubscription,
    required OutT Function() read,
    void Function()? onClose,
  })  : _read = read,
        _onClose = onClose;

  final ProviderSubscriptionWithOrigin<Object?, OriginT> innerSubscription;
  final OutT Function() _read;
  final void Function()? _onClose;

  @override
  OnError get _errorListener {
    return switch (innerSubscription) {
      final ProviderSubscriptionImpl<Object?, OriginT> sub =>
        sub._errorListener,
    };
  }

  @override
  void Function(OutT? prev, OutT next) get _listener {
    return switch (innerSubscription) {
      final ProviderSubscriptionImpl<Object?, OriginT> sub => sub._listener,
    };
  }

  @override
  ProviderBase<OriginT> get origin => innerSubscription.origin;

  @override
  ProviderElement<OriginT> get _listenedElement =>
      innerSubscription._listenedElement;

  @override
  bool get weak => innerSubscription.weak;

  @override
  Node get source => innerSubscription.source;

  @override
  void _onOriginData(OriginT? prev, OriginT next) {
    innerSubscription._onOriginData(prev, next);
  }

  @override
  void _onOriginError(Object error, StackTrace stackTrace) {
    innerSubscription._onOriginError(error, stackTrace);
  }

  @override
  void onCancel() {
    super.onCancel();
    switch (innerSubscription) {
      case final ProviderSubscriptionImpl<Object?, OriginT> sub:
        sub.onCancel();
    }
  }

  @override
  void onResume() {
    super.onResume();
    switch (innerSubscription) {
      case final ProviderSubscriptionImpl<Object?, OriginT> sub:
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

    _onClose?.call();
    innerSubscription.close();
    super.close();
  }

  @override
  OutT _callRead() => _read();
}

final class DelegatingProviderSubscription<OutT, InT, OriginT>
    extends ProviderSubscriptionImpl<OutT, OriginT> {
  DelegatingProviderSubscription({
    required this.origin,
    required this.source,
    required this.weak,
    required OnError? errorListener,
    required ProviderElement<OriginT> listenedElement,
    required void Function(OutT? prev, OutT next) listener,
    void Function(OriginT? prev, OriginT next)? onOriginData,
    void Function(Object error, StackTrace stackTrace)? onOriginError,
    required OutT Function() read,
    required void Function()? onClose,
  })  : _errorListener = errorListener ?? Zone.current.handleUncaughtError,
        _listenedElement = listenedElement,
        _listener = listener,
        _onOriginDataCb = onOriginData,
        _onOriginErrorCb = onOriginError,
        _readCb = read,
        _onCloseCb = onClose;

  @override
  final ProviderBase<OriginT> origin;
  @override
  final Node source;
  @override
  final bool weak;
  @override
  final OnError _errorListener;
  @override
  final ProviderElement<OriginT> _listenedElement;
  @override
  final void Function(OutT? prev, OutT next) _listener;
  final void Function(OriginT? prev, OriginT next)? _onOriginDataCb;
  final void Function(Object error, StackTrace stackTrace)? _onOriginErrorCb;
  final OutT Function() _readCb;
  final void Function()? _onCloseCb;

  @override
  void _onOriginData(OriginT? prev, OriginT next) =>
      _onOriginDataCb?.call(prev, next);

  @override
  void _onOriginError(Object error, StackTrace stackTrace) =>
      _onOriginErrorCb?.call(error, stackTrace);

  @override
  OutT _callRead() => _readCb();

  @override
  void close() {
    if (_closed) return;

    _onCloseCb?.call();
    super.close();
  }
}

/// When a provider listens to another provider using `listen`
@internal
final class ProviderStateSubscription<StateT>
    extends ProviderSubscriptionImpl<StateT, StateT> {
  ProviderStateSubscription({
    required this.source,
    required this.weak,
    required ProviderElement<StateT> listenedElement,
    required void Function(StateT? prev, StateT next) listener,
    required OnError onError,
  })  : _listenedElement = listenedElement,
        _listener = listener,
        _errorListener = onError;

  @override
  ProviderBase<StateT> get origin => _listenedElement.origin;

  @override
  final Node source;
  @override
  final ProviderElement<StateT> _listenedElement;
  @override
  final bool weak;

  // Why can't this be typed correctly?
  final void Function(StateT? prev, StateT next) _listener;
  final OnError _errorListener;

  @override
  StateT _callRead() => _listenedElement.readSelf();

  @override
  void _onOriginData(StateT? prev, StateT next) => _notifyData(prev, next);

  @override
  void _onOriginError(Object error, StackTrace stackTrace) =>
      _notifyError(error, stackTrace);
}

/// Deals with the internals of synchronously calling the listeners
/// when using `fireImmediately: true`
void _handleFireImmediately<StateT>(
  $Result<StateT> currentState, {
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
