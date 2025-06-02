part of '../framework.dart';

/// Represents the subscription to a [ProviderListenable].
///
/// {@category Core}
// This always is implemented with ProviderSubscriptionWithOrigin.
// This interface exists to remove the redundant type parameters.
@optionalTypeArgs
sealed class ProviderSubscription<OutT> {
  /// Whether the subscription is closed.
  bool get closed;

  /// Whether the subscription maintains the provider state.
  ///
  /// If false and [ProviderBase.isAutoDispose] is true, the provider
  /// may still be disposed even if this subscription is active.
  bool get weak;

  /// Whether the subscription is paused.
  ///
  /// {@template riverpod.pause}
  /// Upon resuming the subscription, if any event was sent while paused,
  /// the last event will be sent to the listener.
  /// {@endtemplate}
  bool get isPaused;

  /// The object that listens to the associated [ProviderListenable].
  ///
  /// This is typically a [ProviderElement] or a [ProviderContainer],
  /// but may be other values in the future.
  Node get source;

  /// Pauses the subscription.
  ///
  /// {@macro riverpod.pause}
  void pause();

  /// Resumes the subscription.
  ///
  /// {@macro riverpod.pause}
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
sealed class ProviderSubscriptionWithOrigin<OutT, StateT, ValueT>
    extends ProviderSubscription<OutT> implements Pausable {
  ProviderBase<StateT, ValueT> get origin;
  ProviderElement<StateT, ValueT> get _listenedElement;

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
abstract base class ProviderSubscriptionImpl<OutT, OriginT, ValueT>
    extends ProviderSubscriptionWithOrigin<OutT, OriginT, ValueT>
    with _OnPauseMixin {
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

  @override
  void onCancel() {
    _listenedElement.onSubscriptionPause(this);
  }

  @override
  void onResume() {
    _listenedElement.onSubscriptionResume(this);
    if (closed) return;
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
    assert(!closed, 'cannot notify after close');
    if (isPaused) {
      _missedCalled = (data: (prev, next), error: null);
      return;
    }

    _listener(prev, next);
  }

  void _notifyError(Object error, StackTrace stackTrace) {
    assert(!closed, 'cannot notify after close');
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

@internal
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
base class ProviderSubscriptionView<OutT, OriginStateT, OriginValueT>
    extends ProviderSubscriptionImpl<OutT, OriginStateT, OriginValueT> {
  ProviderSubscriptionView({
    required this.innerSubscription,
    required OutT Function() read,
    void Function()? onClose,
    required void Function(OutT? prev, OutT next) listener,
    required OnError? onError,
  })  : _read = read,
        _onClose = onClose,
        _listener = listener,
        _errorListener = onError ??
            innerSubscription._listenedElement.container.defaultOnError;

  final ProviderSubscriptionWithOrigin<Object?, OriginStateT, OriginValueT>
      innerSubscription;
  final OutT Function() _read;
  final void Function()? _onClose;

  @override
  final OnError _errorListener;

  @override
  final void Function(OutT? prev, OutT next) _listener;

  @override
  ProviderBase<OriginStateT, OriginValueT> get origin =>
      innerSubscription.origin;

  @override
  ProviderElement<OriginStateT, OriginValueT> get _listenedElement =>
      innerSubscription._listenedElement;

  @override
  bool get weak => innerSubscription.weak;

  @override
  Node get source => innerSubscription.source;

  @override
  void _onOriginData(OriginStateT? prev, OriginStateT next) {
    innerSubscription._onOriginData(prev, next);
  }

  @override
  void _onOriginError(Object error, StackTrace stackTrace) {
    innerSubscription._onOriginError(error, stackTrace);
  }

  @override
  void onCancel() {}

  @override
  void onResume() {}

  @override
  void pause() {
    super.pause();
    innerSubscription.pause();
  }

  @override
  void resume() {
    super.resume();
    innerSubscription.resume();
  }

  @override
  void close() {
    if (_closed) return;

    _onClose?.call();
    super.close();
    innerSubscription.close();
  }

  @override
  OutT _callRead() => _read();
}

@internal
final class DelegatingProviderSubscription<OutT, InT, OriginStateT,
        OriginValueT>
    extends ProviderSubscriptionImpl<OutT, OriginStateT, OriginValueT> {
  DelegatingProviderSubscription({
    required this.origin,
    required this.source,
    required this.weak,
    required OnError? errorListener,
    required ProviderElement<OriginStateT, OriginValueT> listenedElement,
    required void Function(OutT? prev, OutT next) listener,
    void Function(OriginStateT? prev, OriginStateT next)? onOriginData,
    void Function(Object error, StackTrace stackTrace)? onOriginError,
    required OutT Function() read,
    required void Function()? onClose,
  })  : _errorListener = errorListener ?? source.container.defaultOnError,
        _listenedElement = listenedElement,
        _listener = listener,
        _onOriginDataCb = onOriginData,
        _onOriginErrorCb = onOriginError,
        _readCb = read,
        _onCloseCb = onClose;

  @override
  final ProviderBase<OriginStateT, OriginValueT> origin;
  @override
  final Node source;
  @override
  final bool weak;
  @override
  final OnError _errorListener;
  @override
  final ProviderElement<OriginStateT, OriginValueT> _listenedElement;
  @override
  final void Function(OutT? prev, OutT next) _listener;
  final void Function(OriginStateT? prev, OriginStateT next)? _onOriginDataCb;
  final void Function(Object error, StackTrace stackTrace)? _onOriginErrorCb;
  final OutT Function() _readCb;
  final void Function()? _onCloseCb;

  @override
  void _onOriginData(OriginStateT? prev, OriginStateT next) =>
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
final class ProviderStateSubscription<StateT, ValueT>
    extends ProviderSubscriptionImpl<StateT, StateT, ValueT> {
  ProviderStateSubscription({
    required this.source,
    required this.weak,
    required ProviderElement<StateT, ValueT> listenedElement,
    required void Function(StateT? prev, StateT next) listener,
    required OnError onError,
  })  : _listenedElement = listenedElement,
        _listener = listener,
        _errorListener = onError;

  @override
  ProviderBase<StateT, ValueT> get origin => _listenedElement.origin;

  @override
  final Node source;
  @override
  final ProviderElement<StateT, ValueT> _listenedElement;
  @override
  final bool weak;

  // Why can't this be typed correctly?
  @override
  final void Function(StateT? prev, StateT next) _listener;
  @override
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
  ProviderContainer container,
  $Result<StateT> currentState, {
  required void Function(StateT? previous, StateT current) listener,
  required void Function(Object error, StackTrace stackTrace) onError,
}) {
  switch (currentState) {
    case $ResultData():
      container.runBinaryGuarded(listener, null, currentState.value);
    case $ResultError():
      container.runBinaryGuarded(
        onError,
        currentState.error,
        currentState.stackTrace,
      );
  }
}
