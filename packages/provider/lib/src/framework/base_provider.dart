part of 'framework.dart';

@immutable
abstract class BaseProvider<CombiningValue, ListenedValue> {
  ProviderOverride<CombiningValue, ListenedValue> overrideForSubtree(
    BaseProvider<CombiningValue, ListenedValue> provider,
  ) {
    return ProviderOverride._(provider, this);
  }

  Iterable<BaseProvider<Object, Object>> _allDependencies() sync* {}

  @visibleForOverriding
  BaseProviderState<CombiningValue, ListenedValue,
      BaseProvider<CombiningValue, ListenedValue>> createState();

  VoidCallback watchOwner(
    ProviderStateOwner owner,
    void Function(ListenedValue) listener,
  ) {
    final state = owner.readProviderState(this);
    return state.$addListenedValueListener(listener);
  }
}

@visibleForOverriding
abstract class BaseProviderState<CombiningValue, ListenedValue,
        P extends BaseProvider<CombiningValue, ListenedValue>>
    implements ProviderListenerState<CombiningValue>, ProviderState {
  P _provider;

  var _mounted = true;
  @override
  bool get mounted => _mounted;

  CombiningValue _$state;
  @override
  CombiningValue get $state => _$state;
  set $state(CombiningValue $state) {
    _$state = $state;
    if (_stateListeners != null) {
      for (final listener in _stateListeners) {
        listener.value($state);
      }
    }
  }

  @protected
  @visibleForTesting
  P get provider => _provider;

  ProviderStateOwner _owner;
  ProviderStateOwner get owner => _owner;

  /// Keep track of this provider's dependencies on mount to assert that they
  /// never change.
  List<BaseProviderState<Object, Object, BaseProvider<Object, Object>>>
      _debugInitialDependenciesState;

  DoubleLinkedQueue<VoidCallback> _onDisposeCallbacks;
  LinkedList<_LinkedListEntry<void Function(CombiningValue)>> _stateListeners;

  @mustCallSuper
  void _initDependencies(
    List<BaseProviderState<Object, Object, BaseProvider<Object, Object>>>
        dependenciesState,
  ) {
    assert(() {
      _debugInitialDependenciesState = dependenciesState;
      return true;
    }(), '');
  }

  @protected
  CombiningValue initState();

  ListenedValue combiningValueAsListenedValue(CombiningValue value);

  @mustCallSuper
  @protected
  void didUpdateProvider(P oldProvider) {}

  @override
  void onDispose(VoidCallback cb) {
    _onDisposeCallbacks ??= DoubleLinkedQueue();
    _onDisposeCallbacks.add(cb);
  }

  VoidCallback $addCombiningValueListener(
    void Function(CombiningValue) listener, {
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

  VoidCallback $addListenedValueListener(
    void Function(ListenedValue) listener, {
    bool fireImmediately = true,
  }) {
    return $addCombiningValueListener(
      (combiningValue) {
        listener(combiningValueAsListenedValue(combiningValue));
      },
      fireImmediately: fireImmediately,
    );
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

class _LinkedListEntry<T> extends LinkedListEntry<_LinkedListEntry<T>> {
  _LinkedListEntry(this.value);
  final T value;
}
