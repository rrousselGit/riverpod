part of 'framework.dart';

/// Internal utility to visit the graph of providers in an order where it is
/// safe to perform operations on their state (such as dispose/updates).
///
/// This basically visits the dependencies of a provider before the provider
/// itself, while ensuring that a given provider is visited only once.
@visibleForTesting
void visitNodesInDependencyOrder(
  Set<ProviderBaseState> nodesToVisit,
  void Function(ProviderBaseState value) visitor,
) {
  final inResult = <ProviderBaseState>{};

  void recurs(ProviderBaseState node) {
    if (!nodesToVisit.contains(node) || inResult.contains(node)) {
      return;
    }

    node._dependenciesState.forEach(recurs);

    inResult.add(node);
    visitor(node);
  }

  nodesToVisit.forEach(recurs);
}

@immutable
@optionalTypeArgs
abstract class ProviderBase<CombiningValue extends ProviderBaseSubscription,
    ListenedValue extends Object> {
  @visibleForOverriding
  ProviderBaseState<CombiningValue, ListenedValue,
      ProviderBase<CombiningValue, ListenedValue>> createState();

  /// The callback may never get called
  VoidCallback watchOwner(
    ProviderStateOwner owner,
    void Function(ListenedValue value) listener,
  ) {
    final state = owner._readProviderState(this);
    return state.$addStateListener(listener);
  }
}

@visibleForOverriding
@optionalTypeArgs
abstract class ProviderBaseState<
    CombiningValue extends ProviderBaseSubscription,
    ListenedValue extends Object,
    P extends ProviderBase<CombiningValue, ListenedValue>> {
  P _provider;

  var _mounted = true;
  bool get mounted => _mounted;

  ListenedValue _$state;
  ListenedValue get $state => _$state;
  set $state(ListenedValue $state) {
    _$state = $state;
    if (_stateListeners != null) {
      for (final listener in _stateListeners) {
        // TODO guard
        listener.value($state);
      }
    }
  }

  Map<ProviderBase, ProviderBaseSubscription> _dependenciesValueCache;
  final Set<ProviderBaseState> _dependenciesState = {};

  // TODO multiple owners
  ProviderBase _debugInitialDependOnRequest;

  T dependOn<T extends ProviderBaseSubscription>(
      ProviderBase<T, Object> provider) {
    // verify that we are not in a stack overflow of dependOn calls.
    assert(() {
      if (_debugInitialDependOnRequest == provider) {
        throw CircularDependencyError._();
      }
      _debugInitialDependOnRequest ??= provider;
      return true;
    }(), '');
    _dependenciesValueCache ??= {};

    try {
      return _dependenciesValueCache.putIfAbsent(provider, () {
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

  @protected
  @visibleForTesting
  P get provider => _provider;

  ProviderStateOwner _owner;
  ProviderStateOwner get owner => _owner;

  DoubleLinkedQueue<VoidCallback> _onDisposeCallbacks;
  LinkedList<_LinkedListEntry<void Function(ListenedValue value)>>
      _stateListeners;

  @protected
  ListenedValue initState();

  CombiningValue createProviderSubscription();

  @mustCallSuper
  @protected
  void didUpdateProvider(P oldProvider) {}

  void onDispose(VoidCallback cb) {
    _onDisposeCallbacks ??= DoubleLinkedQueue();
    _onDisposeCallbacks.add(cb);
  }

  VoidCallback $addStateListener(
    void Function(ListenedValue value) listener, {
    bool fireImmediately = true,
  }) {
    if (fireImmediately) {
      listener($state);
    }
    _stateListeners ??= LinkedList();
    final entry = _LinkedListEntry(listener);
    _stateListeners.add(entry);
    return entry.unlink;
  }

  bool get $hasListeners => _stateListeners?.isNotEmpty ?? false;

  void dispose() {
    if (_onDisposeCallbacks != null) {
      for (final disposeCb in _onDisposeCallbacks) {
        try {
          disposeCb();
        } catch (err, stack) {
          owner._onError?.call(err, stack);
        }
      }
    }
    _mounted = false;
  }
}

abstract class AlwaysAliveProvider<
    CombiningValue extends ProviderBaseSubscription,
    ListenedValue> extends ProviderBase<CombiningValue, ListenedValue> {
  ListenedValue readOwner(ProviderStateOwner owner) {
    final state = owner._readProviderState(this);
    return state.$state;
  }

  // Always alive providers can only be overriden by always alive providers
  // as automatically disposed providers wouldn't work.
  ProviderOverride<CombiningValue, ListenedValue> overrideForSubtree(
    AlwaysAliveProvider<CombiningValue, ListenedValue> provider,
  ) {
    return ProviderOverride._(provider, this);
  }
}

class _LinkedListEntry<T> extends LinkedListEntry<_LinkedListEntry<T>> {
  _LinkedListEntry(this.value);
  final T value;
}
