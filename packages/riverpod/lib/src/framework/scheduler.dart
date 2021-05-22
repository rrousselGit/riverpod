part of '../framework.dart';

/// The object that handles when providers are refreshed and disposed.
///
/// Providers are typically refreshed at the end of the frame where they
/// notified that they wanted to rebuild.
///
/// Providers are disposed if they spent at least one full frame without any listener.
class _ProviderScheduler {
  bool _scheduledTask = false;
  final _stateToDispose = <AutoDisposeProviderElementBase>[];
  final _stateToRefresh = <ProviderElementBase>[];

  Future<void>? _pendingFuture;

  void scheduleProviderRefresh(ProviderElementBase element) {
    _stateToRefresh.add(element);

    _scheduleTask();
  }

  void _scheduleTask() {
    if (_scheduledTask) return;

    _scheduledTask = true;
    _pendingFuture = Future(() {
      _performRefresh();
      _performDispose();

      _scheduledTask = false;
      _stateToRefresh.clear();
      _stateToDispose.clear();
      _pendingFuture = null;
    });
  }

  void _performRefresh() {
    /// No need to traverse entries from top to bottom, because refreshing a
    /// child will automatically refresh its parent when it will try to read it
    for (var i = 0; i < _stateToRefresh.length; i++) {
      final element = _stateToRefresh[i];
      element.flush();
    }
  }

  void scheduleProviderDispose(AutoDisposeProviderElementBase element) {
    assert(
      !element.hasListeners,
      'Tried to dispose ${element._provider} , but still has listeners',
    );

    _stateToDispose.add(element);
    _scheduleTask();
  }

  void _performDispose() {
    /// No need to traverse entries from children to parents as a parent cannot
    /// have no listener until its children are disposed first.
    /// Worse case scenario, a parent will be added twice to the list (parent child parent)
    /// but when the parent is traversed first, it will still have listeners,
    /// and the second time it is traversed, it won't anymore.
    for (var i = 0; i < _stateToDispose.length; i++) {
      final element = _stateToDispose[i];

      if (element.maintainState || element.hasListeners || !element._mounted) {
        continue;
      }
      element._container._disposeProvider(element._origin);
    }
  }
}
