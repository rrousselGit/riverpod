part of '../framework.dart';

/// A [ProviderReference] for providers that are automatically destroyed when
/// no-longer used.
///
/// The difference with [ProviderReference] is that it has an extra
/// [maintainState] property, to help determine if the state can be destroyed
///  or not.
abstract class AutoDisposeProviderReference extends ProviderReference {
  /// Whether to destroy the state of the provider when all listeners are removed or not.
  ///
  /// Can be changed at any time, in which case when setting it to `false`,
  /// may destroy the provider state if it currently has no listeners.
  ///
  /// Defaults to `false`.
  bool get maintainState;
  set maintainState(bool value);
}

/// {@template riverpod.AutoDisposeProviderBase}
/// A base class for providers that destroy their state when no-longer listened.
///
/// See also:
///
/// - [Provider.autoDispose], a variant of [Provider] that auto-dispose its state.
/// {@endtemplate}
abstract class AutoDisposeProviderBase<Created, Listened>
    extends RootProvider<Created, Listened> {
  /// {@macro riverpod.AutoDisposeProviderBase}
  AutoDisposeProviderBase(
    Created Function(AutoDisposeProviderReference ref) create,
    String name,
  ) : super((ref) => create(ref as AutoDisposeProviderReference), name);

  @override
  AutoDisposeProviderElement<Created, Listened> createElement() {
    return AutoDisposeProviderElement(this);
  }

  /// Overrides the behavior of this provider with another provider.
  ///
  /// {@macro riverpod.overideWith}
  ProviderOverride overrideWithProvider(
    RootProvider<Created, Listened> provider,
  ) {
    return ProviderOverride(provider, this);
  }
}

/// The [ProviderElement] of an [AutoDisposeProviderBase].
class AutoDisposeProviderElement<Created, Listened>
    extends ProviderElement<Created, Listened>
    implements AutoDisposeProviderReference {
  /// The [ProviderElement] of an [AutoDisposeProviderBase].
  AutoDisposeProviderElement(
    ProviderBase<Created, Listened> provider,
  ) : super(provider);

  bool _maintainState = false;
  @override
  bool get maintainState => _maintainState;
  @override
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

/// The class that handlers disposing [AutoDisposeProviderBase] when they are
/// no-longer listened.
///
/// This will typically cause a provider to be disposed after the next event loop,
/// unless by that time the provider is listened once again, or if
/// [AutoDisposeProviderReference.maintainState] was set to `true`.
class _AutoDisposer {
  static final _AutoDisposer instance = _AutoDisposer();

  bool _scheduled = false;
  LinkedList<_LinkedListEntry<AutoDisposeProviderElement>> _stateToDispose;

  /// Marks an [AutoDisposeProvider] as potentially needing to be disposed.
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
      assert(entry.value._origin != null, 'No origin specified – bug?');
      assert(
        entry.value._container._stateReaders.containsKey(entry.value._origin),
        'Removed a key that does not exist',
      );
      entry.value._container._stateReaders.remove(entry.value._origin);
      if (entry.value.origin.from != null) {
        entry.value.origin.from._cache.remove(entry.value.origin.argument);
      }
      entry.value.dispose();
    }
  }
}
