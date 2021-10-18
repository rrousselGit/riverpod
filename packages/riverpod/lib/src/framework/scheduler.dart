part of '../framework.dart';

class _ElementLink extends LinkedListEntry<_ElementLink> {
  _ElementLink(this.element);
  final ProviderElementBase element;
}

/// The object that handles when providers are refreshed and disposed.
///
/// Providers are typically refreshed at the end of the frame where they
/// notified that they wanted to rebuild.
///
/// Providers are disposed if they spent at least one full frame without any listener.
class _ProviderScheduler {
  _ProviderScheduler(this.vsync);

  static void _insertAtCorrectDepth(
    _ElementLink link,
    LinkedList<_ElementLink> list,
  ) {
    if (list.isEmpty) {
      list.add(link);
      return;
    }

    final depth = link.element._approximatedDepth;
    _ElementLink? node = list.last;

    while (node != null) {
      if (node.element._isScheduledForRedepth) continue;
      if (node.element._approximatedDepth < depth) break;
      node = node.previous;
    }

    if (node == null) {
      list.addFirst(link);
      return;
    }

    assert(
      node.element._approximatedDepth < depth &&
          !node.element._isScheduledForRedepth,
      'unknown error',
    );

    node.insertAfter(link);
  }

  final void Function(void Function() onDone) vsync;

  bool _disposed = false;
  bool _scheduledTask = false;
  final _elementsToRedepth = LinkedList<_ElementLink>();
  final _stateToDispose = LinkedList<_ElementLink>();
  final _stateToRefresh = LinkedList<_ElementLink>();

  // TODO can we remove this?
  Completer<void>? _pendingTaskCompleter;
  Future<void>? get pendingFuture => _pendingTaskCompleter?.future;

  /// Program a provider to be refreshed.
  void scheduleProviderRefresh(ProviderElementBase element) {
    final link = element._scheduledRefreshLink;
    assert(link.list == null, '$element is already scheduled to refresh');
    _insertAtCorrectDepth(link, _stateToRefresh);

    _scheduleTask();
  }

  /// Program a provider to be disposed of.
  void scheduleProviderDispose(AutoDisposeProviderElementBase element) {
    assert(
      !element.hasListeners,
      'Tried to dispose ${element._provider} , but still has listeners',
    );
    final link = element._scheduledDisposeLink;
    if (link.list != null) {
      // already scheduled to dispose
      return;
    }

    _insertAtCorrectDepth(link, _stateToDispose);
    _scheduleTask();
  }

  /// A provider moved deeper in the graph
  void scheduleElementDepthIncreased(ProviderElementBase element) {
    _elementsToRedepth.add(_ElementLink(element));
  }

  void _scheduleTask() {
    assert(!_disposed, 'tried to emit updates with a disposed Scheduler');
    if (_scheduledTask) return;

    _scheduledTask = true;
    assert(_pendingTaskCompleter == null, 'bad state');
    _pendingTaskCompleter = Completer<void>();
    vsync(_task);
  }

  /// Force providers to rebuild but won't cause them to dispose
  void flush() {
    _performRedepth();
    _performRefresh();
  }

  void _task() {
    if (_pendingTaskCompleter != null && _pendingTaskCompleter!.isCompleted) {
      return;
    }
    _pendingTaskCompleter?.complete();
    if (_disposed) return;

    _performRedepth();
    _performRefresh();
    _performDispose();

    _scheduledTask = false;
    _pendingTaskCompleter = null;
  }

  void _performRedepth() {
    while (_elementsToRedepth.isNotEmpty) {
      final link = _elementsToRedepth.first;
      link.unlink();
      final element = link.element;
      final depth = element._approximatedDepth;

      void relocateScheduledEntryToNewDepth(_ElementLink relocatedLink) {
        // Since the depth can only increase, we only try to move the links
        // further in their respective list.
        var targetNode = relocatedLink.next;
        for (; targetNode != null; targetNode = targetNode.next) {
          if (targetNode.element._isScheduledForRedepth) continue;
          if (depth < targetNode.element._approximatedDepth) break;
        }

        final list = relocatedLink.list;
        if (targetNode != null &&
            depth < targetNode.element._approximatedDepth) {
          targetNode.insertBefore(relocatedLink);
        } else {
          list!.add(relocatedLink);
        }
      }

      if (element._scheduledRefreshLink.list != null) {
        relocateScheduledEntryToNewDepth(element._scheduledRefreshLink);
      }
      if (element._scheduledDisposeLink.list != null) {
        relocateScheduledEntryToNewDepth(element._scheduledDisposeLink);
      }

      element.visitChildren((child) {
        if (depth >= child.approximatedDepth) {
          child._approximatedDepth = depth + 1;
          _elementsToRedepth.add(_ElementLink(child));
        }
      });

      element._isScheduledForRedepth = false;
    }
  }

  void _performRefresh() {
    // TODO assert elements are in order
    /// No need to traverse entries from top to bottom, because refreshing a
    /// child will automatically refresh its parent when it will try to read it
    while (_stateToRefresh.isNotEmpty) {
      final link = _stateToRefresh.first..unlink();
      if (link.element.hasListeners) link.element.performRebuild();
    }
  }

  void _performDispose() {
    // TODO assert elements are in order
    /// No need to traverse entries from children to parents as a parent cannot
    /// have no listener until its children are disposed first.
    /// Worse case scenario, a parent will be added twice to the list (parent child parent)
    /// but when the parent is traversed first, it will still have listeners,
    /// and the second time it is traversed, it won't anymore.
    while (_stateToDispose.isNotEmpty) {
      final link = _stateToDispose.first..unlink();
      final element = link.element as AutoDisposeProviderElementBase;
      if (element.maintainState || element.hasListeners || !element._mounted) {
        continue;
      }
      element._container._disposeProvider(element._origin);
    }
  }

  void dispose() {
    _disposed = true;
  }
}
