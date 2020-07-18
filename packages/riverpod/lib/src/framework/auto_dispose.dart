part of '../framework.dart';

abstract class AutoDisposeProviderReference extends ProviderReference {
  bool get maintainState;
  set maintainState(bool value);
}

abstract class AutoDisposeProviderBase<Created, Listened>
    extends ProviderBase<Created, Listened> {
  AutoDisposeProviderBase(
    Created Function(AutoDisposeProviderReference ref) create,
    String name,
  ) : super((ref) => create(ref as AutoDisposeProviderReference), name);

  @override
  AutoDisposeProviderElement<Created, Listened> createElement() {
    return AutoDisposeProviderElement(this);
  }

  // Accepts AlwaysAliveProviders too
  Override overrideAs(ProviderBase<Object, Listened> provider) {
    return ProviderOverride._(provider, this);
  }
}

class AutoDisposeProviderElement<Created, Listened>
    extends ProviderElement<Created, Listened>
    implements AutoDisposeProviderReference {
  AutoDisposeProviderElement(
    AutoDisposeProviderBase<Created, Listened> provider,
  ) : super(provider);

  @override
  bool _maintainState = false;
  bool get maintainState => _maintainState;
  set maintainState(bool value) {
    _maintainState = value;
    if (!_maintainState && !hasListeners) {
      _AutoDisposer.instance.scheduleDispose(this);
    }
  }

  @override
  void didRemoveListener() {
    if (!maintainState && !hasListeners) {
      _AutoDisposer.instance.scheduleDispose(this);
    }
  }
}

class _LinkedListEntry<T> extends LinkedListEntry<_LinkedListEntry<T>> {
  _LinkedListEntry(this.value);

  final T value;
}

class _AutoDisposer {
  static final _AutoDisposer instance = _AutoDisposer();

  bool _scheduled = false;
  LinkedList<_LinkedListEntry<AutoDisposeProviderElement>> _stateToDispose;

  void scheduleDispose(AutoDisposeProviderElement element) {
    assert(
      !element.hasListeners,
      'Tried to dispose ${element._provider} , but still has listeners',
    );

    _stateToDispose ??= LinkedList();
    _stateToDispose.add(_LinkedListEntry(element));

    if (!_scheduled) {
      _scheduled = true;
      Future.microtask(() {
        try {
          _performDispose();
        } finally {
          _scheduled = false;
          _stateToDispose = null;
        }
      });
    }
  }

  void _performDispose() {
    /// No need to traverse entries from children to parents as a parent cannot
    /// have no listener until its children are disposed first.
    /// Worse case scenario, a parent will be added twice to the list (parent child parent)
    /// but when the parent is traverse first, it will still have listeners,
    /// and the second time it is traversed, it won't anymore.
    for (var entry = _stateToDispose.first; entry != null; entry = entry.next) {
      if (entry.value.maintainState ||
          entry.value.hasListeners ||
          !entry.value.mounted) {
        continue;
      }
      notifyListenersLock = entry.value;
      try {
        entry.value.dispose();
      } finally {
        notifyListenersLock = null;
        assert(entry.value._origin != null, 'No origin specified – bug?');
        assert(
            entry.value._container._stateReaders
                .containsKey(entry.value._origin),
            'Removed a key that does not exist');
        entry.value._container._stateReaders.remove(entry.value._origin);
      }
    }
  }
}
