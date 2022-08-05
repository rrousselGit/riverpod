part of '../framework.dart';

/// The object that handles when providers are refreshed and disposed.
///
/// Providers are typically refreshed at the end of the frame where they
/// notified that they wanted to rebuild.
///
/// Providers are disposed if they spent at least one full frame without any listener.
class _ProviderScheduler {
  _ProviderScheduler(this.vsync);

  final void Function(void Function() onDone) vsync;

  final _stateToDispose = <AutoDisposeProviderElementMixin>[];
  final _stateToRefresh = <ProviderElementBase>[];

  Completer<void>? _pendingTaskCompleter;
  Future<void>? get pendingFuture => _pendingTaskCompleter?.future;

  void scheduleProviderRefresh(ProviderElementBase element) {
    _stateToRefresh.add(element);

    _scheduleTask();
  }

  void _scheduleTask() {
    if (_pendingTaskCompleter != null) return;
    _pendingTaskCompleter = Completer<void>();
    vsync(_task);
  }

  void _task() {
    final pendingTaskCompleter = _pendingTaskCompleter;
    if (pendingTaskCompleter == null) return;
    pendingTaskCompleter.complete();

    _performRefresh();
    _performDispose();
    _stateToRefresh.clear();
    _stateToDispose.clear();
    _pendingTaskCompleter = null;
  }

  void _performRefresh() {
    /// No need to traverse entries from top to bottom, because refreshing a
    /// child will automatically refresh its parent when it will try to read it
    for (var i = 0; i < _stateToRefresh.length; i++) {
      final element = _stateToRefresh[i];
      if (element.hasListeners) element.flush();
    }
  }

  void scheduleProviderDispose(AutoDisposeProviderElementMixin element) {
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

      final links = element._keepAliveLinks;

      // ignore: deprecated_member_use_from_same_package
      if (element.maintainState ||
          (links != null && links.isNotEmpty) ||
          element.hasListeners ||
          element._container._disposed) {
        continue;
      }
      element._container._disposeProvider(element._origin);
    }
  }

  void dispose() {
    _pendingTaskCompleter?.complete();
    _pendingTaskCompleter = null;
  }
}
