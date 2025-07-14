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

extension<StateT> on ProviderSubscription<StateT> {
  ProviderSubscriptionImpl<StateT> get impl {
    final that = this;
    switch (that) {
      case ProviderSubscriptionImpl<StateT>():
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
extension ProviderSubX<StateT> on ProviderSubscription<StateT> {
  @useResult
  $Result<StateT> readSafe() {
    if (closed) {
      throw StateError(
        'called ProviderSubscription.read on a subscription that was closed',
      );
    }
    final that = impl;
    that._listenedElement.mayNeedDispose();
    that._listenedElement.flush();

    return that._callRead();
  }
}

@internal
sealed class ProviderSubscriptionImpl<OutT> extends ProviderSubscription<OutT>
    with _OnPauseMixin {
  /// The object that listens to the associated [ProviderListenable].
  ///
  /// This is typically a [ProviderElement] or a [ProviderContainer],
  /// but may be other values in the future.
  Node get source;

  @override
  bool get isPaused => _isPaused;

  /// Whether the subscription is closed.
  @override
  bool get closed => _closed;
  var _closed = false;

  /// Whether this subscription is indirectly attached to an element.
  bool get $hasParent => _parent != null;

  ProviderSubscriptionImpl<void>? _parent;

  /// Whether an event was sent while this subscription was paused.
  ///
  /// This enables re-rending the last missing event when the subscription is resumed.
  ({
    (OutT?, OutT)? data,
    (Object, StackTrace)? error,
  })? _missedCalled;
  void Function(OutT? prev, OutT next) get _listener;
  OnError get _errorListener;

  ProviderElement<Object?, Object?> get _listenedElement;

  void _attach(ProviderSubscriptionImpl<void> parent) {
    assert(_parent == null, 'Already attached to a parent: $_parent');
    _parent = parent;
  }

  $Result<OutT> _callRead();

  @override
  OutT read() => readSafe().valueOrProviderException;

  @mustCallSuper
  @override
  void pause() {
    _listenedElement.onSubscriptionPauseOrDeactivate(this, super.pause);
  }

  @mustCallSuper
  @override
  void resume() {
    _listenedElement.onSubscriptionResumeOrReactivate(this, () {
      final wasPaused = _isPaused;
      super.resume();

      if (wasPaused && !isPaused) {
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
    });
  }

  @mustCallSuper
  @override
  void deactivate() {
    _listenedElement.onSubscriptionPauseOrDeactivate(this, super.deactivate);
  }

  @mustCallSuper
  @override
  void reactivate() {
    _listenedElement.onSubscriptionResumeOrReactivate(this, super.reactivate);
  }

  void _notifyData(OutT? prev, OutT next) {
    assert(!closed, 'cannot notify after close');
    if (isPaused) {
      _missedCalled = (data: (prev, next), error: null);
      return;
    }

    _listenedElement.container.runBinaryGuarded(_listener, prev, next);
  }

  void _notifyError(Object error, StackTrace stackTrace) {
    assert(!closed, 'cannot notify after close');
    if (isPaused) {
      _missedCalled = (data: null, error: (error, stackTrace));
      return;
    }

    _listenedElement.container.runBinaryGuarded(
      _errorListener,
      error,
      stackTrace,
    );
  }

  /// Stops listening to the provider.
  ///
  /// It is safe to call this method multiple times.
  @override
  @mustCallSuper
  void close() {
    if (_closed) return;

    _listenedElement.removeDependentSubscription(this, () => _closed = true);
  }

  @override
  String toString() {
    final listenedDisplay = _listenedElement.origin.toString();
    final listenerDisplay = switch (source) {
      final ProviderElement e => e.origin.toString(),
      ProviderContainer() => source.toString(),
    };
    return '''
$runtimeType#${shortHash(this)}(
  listened: $listenedDisplay,
  listener: $listenerDisplay,
  pauseCount: $_pauseCount,
  hasParent: ${$hasParent},
  childSub: ${switch (this) {
      final ExternalProviderSubscription<Object?, Object?> e =>
        e._innerSubscription.toString().indentAfterFirstLine(1),
      _ => null
    }}
  active: $active,
  weak: $weak,
  closed: $closed,
)''';
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
  $Result<StateT> _callRead() => _listenedElement.readSelf();
}

/// Subscriptions obtained from listening to a [ProviderListenable]
/// that is not a [ProviderBase].
@internal
final class ExternalProviderSubscription<InT, OutT>
    extends ProviderSubscriptionImpl<OutT> {
  ExternalProviderSubscription.fromSub({
    required ProviderSubscription<InT> innerSubscription,
    required $Result<OutT> Function() read,
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
            innerSubscription.impl._listenedElement.container.defaultOnError {
    innerSubscription.impl._attach(this);
  }

  final ProviderSubscription<InT> _innerSubscription;
  final $Result<OutT> Function() _read;
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
  Node get source => _innerSubscription.impl.source;

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
  $Result<OutT> _callRead() => _read();
}

mixin _OnPauseMixin {
  bool get _isPaused => _pauseCount > 0;
  var _pauseCount = 0;

  int _deactivateCount = 0;
  bool get active => _deactivateCount == 0;

  bool get pausedOrDeactivated => _isPaused || !active;

  @mustCallSuper
  void pause() {
    _pauseCount++;
  }

  @mustCallSuper
  void resume() {
    _pauseCount = math.max(_pauseCount - 1, 0);
  }

  @internal
  void deactivate() {
    _deactivateCount++;
  }

  @internal
  void reactivate() {
    _deactivateCount = math.max(_deactivateCount - 1, 0);
  }
}

/// Deals with the internals of synchronously calling the listeners
/// when using `fireImmediately: true`
void _handleFireImmediately<StateT>(
  ProviderContainer container,
  ProviderSubscription<StateT> sub, {
  required bool fireImmediately,
}) {
  if (!fireImmediately) return;

  switch (sub.readSafe()) {
    case $ResultData<StateT>(:final value):
      sub.impl._notifyData(null, value);
    case $ResultError<StateT>(:final error, :final stackTrace):
      sub.impl._notifyError(error, stackTrace);
  }
}
