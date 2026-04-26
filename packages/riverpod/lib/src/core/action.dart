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
Future<ResultT> action<ResultT>(Future<ResultT> Function() cb) {
  if (_currentAction() != null) return cb();

  final action = _ActionExecution();

  try {
    return runZoned<Future<ResultT>>(() async {
      try {
        return await cb();
      } finally {
        action._close();
      }
    }, zoneValues: {_actionZoneKey: action});
  } catch (_) {
    action._close();
    rethrow;
  }
}

/// Returns a callback that executes [cb] inside [action].
///
/// This is equivalent to writing `() => action(cb)`.
Future<T> Function() voidAction<T>(Future<T> Function() cb) => () => action(cb);

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
