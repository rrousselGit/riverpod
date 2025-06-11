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

extension<T> on ProviderSubscription<T> {
  ProviderSubscriptionImpl<T> get impl {
    final that = this;
    switch (that) {
      case ProviderSubscriptionImpl<T>():
        return that;
    }
  }

  ProviderProviderSubscription<Object?> get providerSub {
    final that = impl;
    switch (that) {
      case final ProviderProviderSubscription<Object?> sub:
        return sub;
      case final ExternalProviderSubscription<Object?, Object?> sub:
        return sub._source;
    }
  }
}

@internal
sealed class ProviderSubscriptionImpl<OutT> extends ProviderSubscription<OutT>
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

  // ProviderBase<StateT> get origin;
  ProviderElement<Object?, Object?> get _listenedElement;

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

/// Subscriptions obtained from listening to a [ProviderBase]
@internal
final class ProviderProviderSubscription<StateT>
    extends ProviderSubscriptionImpl<StateT> {
  ProviderProviderSubscription({
    required ProviderElement<StateT, Object?> listenedElement,
    required OnError onError,
    required this.source,
    required this.weak,
    required void Function(StateT? prev, StateT next) listener,
  })  : _errorListener = onError,
        _listener = listener,
        _listenedElement = listenedElement;

  @override
  final OnError _errorListener;

  @override
  final void Function(StateT? prev, StateT next) _listener;

  @override
  final ProviderElement<StateT, Object?> _listenedElement;

  @override
  final Node source;

  @override
  final bool weak;

  @override
  StateT _callRead() => _listenedElement.readSelf();
}

/// Subscriptions obtained from listening to a [ProviderListenable]
/// that is not a [ProviderBase].
@internal
final class ExternalProviderSubscription<InT, OutT>
    extends ProviderSubscriptionImpl<OutT> {
  ExternalProviderSubscription({
    required ProviderSubscription<InT> innerSubscription,
    required OutT Function() read,
    void Function()? onClose,
    required void Function(OutT? prev, OutT next) listener,
    required OnError? onError,
  })  : _read = read,
        _innerSubscription = innerSubscription,
        _onClose = onClose,
        _listener = listener,
        _source = switch (innerSubscription.impl) {
          final ProviderProviderSubscription<Object?> sub => sub,
          final ExternalProviderSubscription<Object?, Object?> sub =>
            sub._source,
        },
        _errorListener = onError ??
            innerSubscription.impl._listenedElement.container.defaultOnError;

  final ProviderSubscription<InT> _innerSubscription;
  final OutT Function() _read;
  final void Function()? _onClose;
  final ProviderProviderSubscription<Object?> _source;

  @override
  final OnError _errorListener;

  @override
  final void Function(OutT? prev, OutT next) _listener;

  @override
  ProviderElement<Object?, Object?> get _listenedElement =>
      _innerSubscription.impl._listenedElement;

  @override
  bool get weak => _innerSubscription.weak;

  @override
  Node get source => _innerSubscription.source;

  @override
  void onCancel() {}

  @override
  void onResume() {}

  @override
  void pause() {
    super.pause();
    _innerSubscription.pause();
  }

  @override
  void resume() {
    super.resume();
    _innerSubscription.resume();
  }

  @override
  void close() {
    if (_closed) return;

    _onClose?.call();
    super.close();
    _innerSubscription.close();
  }

  @override
  OutT _callRead() => _read();
}

@internal
abstract class Pausable {
  bool get isPaused;

  void pause();
  void resume();

  void onCancel();
  void onResume();
}

mixin _OnPauseMixin implements Pausable {
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

/// Deals with the internals of synchronously calling the listeners
/// when using `fireImmediately: true`
void _handleFireImmediately<StateT>(
  ProviderContainer container,
  ProviderSubscription<StateT> sub, {
  required bool fireImmediately,
  required void Function(StateT? previous, StateT current) listener,
  required void Function(Object error, StackTrace stackTrace)? onError,
}) {
  if (!fireImmediately) return;

  onError ??= container.defaultOnError;

  try {
    container.runBinaryGuarded(listener, null, sub.read());
  } on ProviderException catch (error) {
    // If the read fails, we call the error listener
    container.runBinaryGuarded(
      onError,
      error.exception,
      error.stackTrace,
    );
  }
}
