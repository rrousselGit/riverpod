part of '../framework.dart';

/// A listener used to determine when providers should rebuild.
/// This is used to synchronize provider rebuilds when widget rebuilds.
@internal
typedef Vsync = void Function(void Function());

void Function()? _defaultVsync(void Function() task) {
  final timer = Timer(Duration.zero, task);

  return timer.cancel;
}

/// The object that handles when providers are refreshed and disposed.
///
/// Providers are typically refreshed at the end of the frame where they
/// notified that they wanted to rebuild.
///
/// Providers are disposed if they spent at least one full frame without any listener.
@internal
class ProviderScheduler {
  var _disposed = false;

  /// A way to override [vsync], used by Flutter to synchronize a container
  /// with the widget tree.
  final flutterVsyncs = <Vsync>{};

  /// A function that controls the refresh rate of providers.
  ///
  /// Defaults to refreshing providers at the end of the next event-loop.
  void Function()? Function(void Function()) get vsync {
    if (flutterVsyncs.isNotEmpty) {
      // Notify all InheritedWidgets of a possible rebuild.
      // At the same time, we only execute the task once, in whichever
      // InheritedWidget that rebuilds first.
      return (task) {
        var invoked = false;
        void invoke() {
          if (invoked) return;
          invoked = true;
          task();
        }

        for (final flutterVsync in flutterVsyncs) {
          flutterVsync(invoke);
        }

        return;
      };
    }

    return _defaultVsync;
  }

  final _stateToDispose = <ProviderElement>[];
  final _stateToRefresh = <ProviderElement>[];

  Completer<void>? _pendingTaskCompleter;

  /// A future that completes when the next task is done.
  Future<void>? get pendingFuture => _pendingTaskCompleter?.future;

  void Function()? _cancel;

  /// Schedules a provider to be refreshed.
  ///
  /// The refresh will happen at the end of the next event-loop,
  /// and only if the provider is active.
  void scheduleProviderRefresh(ProviderElement element) {
    _stateToRefresh.add(element);

    _scheduleTask();
  }

  void _scheduleTask() {
    // Don't schedule a task if there is already one pending or if the scheduler
    // is disposed.
    // It is possible that during disposal of a ProviderContainer, if a provider
    // uses ref.keepAlive(), the keepAlive closure will try to schedule a task.
    // In this case, we don't want to schedule a task as the container is already
    // disposed.
    if (_pendingTaskCompleter != null || _disposed) return;
    _pendingTaskCompleter = Completer<void>();
    _cancel = vsync(_task);
  }

  void _task() {
    _cancel = null;
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
      if (element.isActive) element.flush();
    }
  }

  /// Schedules a provider to be disposed.
  ///
  /// The provider will be disposed at the end of the next event-loop,
  void scheduleProviderDispose(ProviderElement element) {
    assert(
      !element.isActive,
      'Tried to dispose ${element.origin} , but still has listeners',
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
      final links = element.ref?._keepAliveLinks;

      if ((links != null && links.isNotEmpty) ||
          element.container._disposed ||
          element.hasNonWeakListeners) {
        continue;
      }

      if (element.weakDependents.isEmpty) {
        element.container._disposeProvider(element.origin);
      } else {
        // Don't delete the pointer if there are some "weak" listeners active.
        element.clearState();
      }
    }
  }

  /// Disposes the scheduler.
  void dispose() {
    _disposed = true;
    _pendingTaskCompleter?.complete();
    _pendingTaskCompleter = null;
    _cancel?.call();
  }
}
