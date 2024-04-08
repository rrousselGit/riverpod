part of '../framework.dart';

/// A listener used to determine when providers should rebuild.
/// This is used to synchronize provider rebuilds when widget rebuilds.
@internal
typedef Vsync = void Function(void Function());

void _defaultVsync(void Function() task) {
  Future(task);
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
  @internal
  final flutterVsyncs = <Vsync>{};

  /// A function that controls the refresh rate of providers.
  ///
  /// Defaults to refreshing providers at the end of the next event-loop.
  @internal
  void Function(void Function()) get vsync {
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
      };
    }

    return _defaultVsync;
  }

  final _stateToDispose = <AutoDisposeProviderElementMixin<Object?>>[];
  final _stateToRefresh = <ProviderElementBase>[];

  Completer<void>? _pendingTaskCompleter;

  /// A future that completes when the next task is done.
  Future<void>? get pendingFuture => _pendingTaskCompleter?.future;

  /// Schedules a provider to be refreshed.
  ///
  /// The refresh will happen at the end of the next event-loop,
  /// and only if the provider is active.
  void scheduleProviderRefresh(ProviderElementBase element) {
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

  /// Schedules a provider to be disposed.
  ///
  /// The provider will be disposed at the end of the next event-loop,
  void scheduleProviderDispose(
    AutoDisposeProviderElementMixin<Object?> element,
  ) {
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

  /// Disposes the scheduler.
  void dispose() {
    _disposed = true;
    _pendingTaskCompleter?.complete();
    _pendingTaskCompleter = null;
  }
}
