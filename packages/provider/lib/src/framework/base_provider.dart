part of 'framework.dart';

@immutable
abstract class BaseProvider<CombiningValue extends BaseProviderValue,
    ListenedValue> {
  ProviderOverride<CombiningValue, ListenedValue> overrideForSubtree(
    BaseProvider<CombiningValue, ListenedValue> provider,
  ) {
    return ProviderOverride._(provider, this);
  }

  @visibleForOverriding
  BaseProviderState<CombiningValue, ListenedValue,
      BaseProvider<CombiningValue, ListenedValue>> createState();

  /// The callback may never get called
  VoidCallback watchOwner(
    ProviderStateOwner owner,
    void Function(ListenedValue) listener,
  ) {
    final state = owner._readProviderState(this);
    return state.$addStateListener(listener);
  }
}

@visibleForOverriding
abstract class BaseProviderState<CombiningValue extends BaseProviderValue,
    ListenedValue, P extends BaseProvider<CombiningValue, ListenedValue>> {
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

  @protected
  @visibleForTesting
  P get provider => _provider;

  ProviderStateOwner _owner;
  ProviderStateOwner get owner => _owner;

  DoubleLinkedQueue<VoidCallback> _onDisposeCallbacks;
  LinkedList<_LinkedListEntry<void Function(ListenedValue)>> _stateListeners;

  @protected
  ListenedValue initState();

  CombiningValue createProviderState();

  @mustCallSuper
  @protected
  void didUpdateProvider(P oldProvider) {}

  void onDispose(VoidCallback cb) {
    _onDisposeCallbacks ??= DoubleLinkedQueue();
    _onDisposeCallbacks.add(cb);
  }

  VoidCallback $addStateListener(
    void Function(ListenedValue) listener, {
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

abstract class AlwaysAliveProvider<CombiningValue extends BaseProviderValue,
    ListenedValue> extends BaseProvider<CombiningValue, ListenedValue> {
  ListenedValue readOwner(ProviderStateOwner owner) {
    final state = owner._readProviderState(this);
    return state.$state;
  }
}

class _LinkedListEntry<T> extends LinkedListEntry<_LinkedListEntry<T>> {
  _LinkedListEntry(this.value);
  final T value;
}
