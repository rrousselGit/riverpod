part of '../framework.dart';

const _actionZoneKey = #_action;

_ActionExecution? _currentAction() {
  final current = Zone.current[_actionZoneKey];
  if (current case final _ActionExecution action when !action._closed) {
    return action;
  }

  return null;
}

/// Returns `true` if the current code is running inside a [run] callback.
@publicInCodegen
bool $isInAction() => _currentAction() != null;

/// Runs [cb] while keeping providers read inside it alive until completion.
///
/// Providers accessed through [Ref.read] or [ProviderContainer.read] while the
/// callback is pending are kept alive and active for the duration of the
/// run callback.
Future<ResultT> _runInternal<ResultT>(Future<ResultT> Function() cb) {
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

/// Runs [cb] while keeping providers read inside it alive until completion.
///
/// Providers accessed through [Ref.read] or [ProviderContainer.read] while the
/// callback is pending are kept alive and active for the duration of the
/// run callback.
Future<ResultT> run<ResultT>(Future<ResultT> Function() cb) => _runInternal(cb);

/// Returns a callback that executes [cb] inside [run].
///
/// This is equivalent to writing `() => run(cb)`.
Future<T> Function() voidRun<T>(Future<T> Function() cb) =>
    () => _runInternal(cb);

final class _ActionExecution {
  var _closed = false;

  final _subscriptions = <ProviderSubscription>[];

  void register(ProviderSubscription subscription) {
    assert(!_closed, 'Cannot register subscriptions on a closed run');
    _subscriptions.add(subscription);
  }

  void _close() {
    if (_closed) return;
    _closed = true;

    _closeSubscriptions(_subscriptions);
    _subscriptions.clear();
  }
}
