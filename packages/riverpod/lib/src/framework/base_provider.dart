part of 'framework.dart';

@immutable
@optionalTypeArgs
abstract class ProviderBase<CombiningValue extends ProviderBaseSubscription,
    ListenedValue extends Object> {
  @visibleForOverriding
  ProviderBaseState<CombiningValue, ListenedValue,
      ProviderBase<CombiningValue, ListenedValue>> createState();

  /// The callback may never get called
  // TODO why the value isn't passed to onChange
  VoidCallback watchOwner(
    ProviderStateOwner owner,
    void Function(ListenedValue value) onChange,
  ) {
    return owner._readProviderState(this).$addListener(onChange);
  }
}

// TODO: prefix internal methods with $ and public methods without
@visibleForOverriding
@optionalTypeArgs
abstract class ProviderBaseState<
    CombiningValue extends ProviderBaseSubscription,
    ListenedValue extends Object,
    P extends ProviderBase<CombiningValue, ListenedValue>> {
  ProviderBaseState() {
    _stateEntryInSortedStateList = _LinkedListEntry(this);
  }

  var _depth = 0;
  int get depth => _depth;

  // Initialised to true to ignore calls to markNeedNotifyListeners inside initState
  var _dirty = true;
  bool get dirty => _dirty;

  P _provider;
  _LinkedListEntry<ProviderBaseState> _stateEntryInSortedStateList;

  var _mounted = true;
  bool get mounted => _mounted;

  @protected
  ListenedValue get state;

  Map<ProviderBase, ProviderBaseSubscription> _dependenciesSubscriptionCache;
  final Set<ProviderBaseState> _dependenciesState = {};

  // TODO multiple owners
  ProviderBase _debugInitialDependOnRequest;

  /// the exception thrown inside initState, if any.
  ///
  /// If [_error] is not `null`, this disable all functionalities of the provider.
  Object _error;

  @protected
  @visibleForTesting
  P get provider => _provider;

  ProviderStateOwner _owner;
  ProviderStateOwner get owner => _owner;

  DoubleLinkedQueue<VoidCallback> _onDisposeCallbacks;
  LinkedList<_LinkedListEntry<void Function(ListenedValue value)>>
      _stateListeners;

  bool get $hasListeners => _stateListeners?.isNotEmpty ?? false;

  @protected
  void initState();

  CombiningValue createProviderSubscription();

  @mustCallSuper
  @protected
  void didUpdateProvider(P oldProvider) {}

  T dependOn<T extends ProviderBaseSubscription>(
    ProviderBase<T, Object> provider,
  ) {
    // verify that we are not in a stack overflow of dependOn calls.
    assert(() {
      if (_debugInitialDependOnRequest == provider) {
        throw CircularDependencyError._();
      }
      _debugInitialDependOnRequest ??= provider;
      return true;
    }(), '');
    _dependenciesSubscriptionCache ??= {};

    try {
      return _dependenciesSubscriptionCache.putIfAbsent(provider, () {
        final targetProviderState = _owner._readProviderState(provider);

        // verify that the new dependency doesn't depend on "this".
        assert(() {
          void recurs(ProviderBaseState state) {
            if (state == this) {
              throw CircularDependencyError._();
            }
            state._dependenciesState.forEach(recurs);
          }

          targetProviderState._dependenciesState.forEach(recurs);
          return true;
        }(), '');

        _dependenciesState.add(targetProviderState);
        redepthAfter(targetProviderState);
        final targetProviderValue =
            targetProviderState.createProviderSubscription();
        onDispose(targetProviderValue.dispose);

        return targetProviderValue;
      }) as T;
    } finally {
      assert(() {
        if (_debugInitialDependOnRequest == provider) {
          _debugInitialDependOnRequest = null;
        }
        return true;
      }(), '');
    }
  }

  /// Reposition this state in the [LinkedList] associated with [_stateEntryInSortedStateList].
  ///
  /// Since the list is sorted, the algorithm starts directly from [_stateEntryInSortedStateList]
  /// and goes to the next item until it either reaches the end of the list or
  /// an item that has a depth == to [from] + 1.
  ///
  /// This only supports increasing the depth, not decreasing it.
  ///
  /// It then proceeds to recursively redepth all the [ProviderBaseState] that
  /// depends on this state.
  ///
  /// Worse case scenario, this is O(N), even on a complex tree.
  void redepthAfter(ProviderBaseState from) {
    final newDepth = max(_depth, from._depth + 1);
    if (newDepth == _depth) {
      return;
    }
    _depth = newDepth;

    /// Where to start the search on where to relocate the [_stateEntryInSortedStateList].
    /// Since this is a sorted linked list, we can start directly from
    /// [from._stateEntryInSortedStateList] instead of [_stateEntryInSortedStateList],
    /// as we will always insert the entry after [from].
    /// This optimisation is only possible if [from] is from the same [ProviderStateOwner]
    /// as otherwise its [_stateEntryInSortedStateList] will point to a different list.
    _LinkedListEntry<ProviderBaseState> entry;
    if (from._owner == _owner) {
      /// unlink before reading [next] so that [next] doesn't point to [_stateEntryInSortedStateList].
      _stateEntryInSortedStateList.unlink();
      entry = from._stateEntryInSortedStateList.next;
    } else {
      entry = _stateEntryInSortedStateList.next;
      _stateEntryInSortedStateList.unlink();
    }

    for (; entry != null && _depth > entry.value._depth; entry = entry.next) {}

    if (entry != null) {
      entry.insertBefore(_stateEntryInSortedStateList);
    } else {
      _owner._providerStatesSortedByDepth.add(_stateEntryInSortedStateList);
    }

    // for (final dep in _dependenciesState) {
    //   dep.redepthAfter(this);
    // }
  }

  void onDispose(VoidCallback cb) {
    _onDisposeCallbacks ??= DoubleLinkedQueue();
    _onDisposeCallbacks.add(cb);
  }

  VoidCallback $addListener(
    void Function(ListenedValue value) listener,
  ) {
    listener(state);
    _stateListeners ??= LinkedList();
    final entry = _LinkedListEntry(listener);
    _stateListeners.add(entry);
    return entry.unlink;
  }

  /// Notify all the listeners in order
  ///
  /// It may be overriden to not notify listeners if the value didn't change
  /// while preserving reactivity.
  @visibleForOverriding
  void notifyListeners() {
    if (_stateListeners != null) {
      for (final listener in _stateListeners) {
        // TODO guard
        listener.value(state);
      }
    }
  }

  void markNeedsNotifyListeners() {
    if (!_mounted) {
      throw StateError(
        'A provider was marked as needing to perform updates when it was already disposed',
      );
    }
    if (_error != null) {
      throw StateError(
        'A provider cannot emit updates if an exception was thrown during the provider creation.',
      );
    }
    if (_dirty == false) {
      _dirty = true;
      owner._scheduleNotification();
    }
  }

  void dispose() {
    if (_onDisposeCallbacks != null) {
      _onDisposeCallbacks.forEach(Zone.current.runGuarded);
    }
    _mounted = false;
  }

  @override
  String toString() {
    return 'ProviderState<$ListenedValue>(depth: $depth)';
  }
}

/// A base class for providers that are never disposed.
///
/// Since they are never disposed, this allows a broader way of consuming them,
/// like with [readOwner], or if using Flutter, with `provider.read(BuildContext)`.
///
/// Similarly, since these providers are never disposed, they can only be
/// overriden by providers that too are never disposed.
/// Otherwise methods like [readOwner] would stop working.
abstract class AlwaysAliveProvider<
        CombiningValue extends ProviderBaseSubscription,
        ListenedValue> extends ProviderBase<CombiningValue, ListenedValue>
    implements ProviderOverride {
  ListenedValue readOwner(ProviderStateOwner owner) {
    return owner._readProviderState(this).state;
  }

  @override
  ProviderBase get _origin => this;
  @override
  ProviderBase get _provider => this;

  // Always alive providers can only be overriden by always alive providers
  // as automatically disposed providers wouldn't work.
  ProviderOverride overrideForSubtree(
    AlwaysAliveProvider<CombiningValue, ListenedValue> provider,
  ) {
    return ProviderOverride._(provider, this);
  }
}

class _LinkedListEntry<T> extends LinkedListEntry<_LinkedListEntry<T>> {
  _LinkedListEntry(this.value);
  final T value;
}
