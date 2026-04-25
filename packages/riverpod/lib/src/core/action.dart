part of '../framework.dart';

const _actionZoneKey = #_action;

_ActionExecution? _currentAction() {
  final current = Zone.current[_actionZoneKey];
  if (current case final _ActionExecution action when !action._closed) {
    return action;
  }

  return null;
}

/// Returns `true` if the current code is running inside an [action].
@publicInCodegen
bool $isInAction() => _currentAction() != null;

/// Runs [cb] while keeping providers read inside it alive until completion.
///
/// Providers accessed through [Ref.read] or [ProviderContainer.read] while the
/// callback is pending are kept alive and active for the duration of the
/// action.
FutureOr<ResultT> action<ResultT>(FutureOr<ResultT> Function() cb) {
  if (_currentAction() != null) return cb();

  final action = _ActionExecution();

  try {
    return runZoned<FutureOr<ResultT>>(() {
      final result = cb();

      if (result is Future<ResultT>) {
        return result.whenComplete(action._close);
      }

      action._close();
      return result;
    }, zoneValues: {_actionZoneKey: action});
  } catch (_) {
    action._close();
    rethrow;
  }
}

/// Returns a callback that executes [cb] inside [action].
///
/// This is equivalent to writing `() => action(cb)`.
void Function() voidAction(FutureOr<void> Function() cb) {
  return () {
    action(cb);
  };
}

final class _ActionExecution {
  var _closed = false;

  final _subscriptions = <ProviderSubscription>[];

  void register(ProviderSubscription subscription) {
    assert(!_closed, 'Cannot register subscriptions on a closed action');
    _subscriptions.add(subscription);
  }

  void _close() {
    if (_closed) return;
    _closed = true;

    _closeSubscriptions(_subscriptions);
    _subscriptions.clear();
  }
}
