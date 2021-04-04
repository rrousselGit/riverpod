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

  @override
  T watch<T>(RootProvider<Object?, T> provider);
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
  AutoDisposeProviderBase(String? name) : super(name);

  @override
  Created create(covariant AutoDisposeProviderReference ref);

  @override
  AutoDisposeProviderElement<Created, Listened> createElement() {
    return AutoDisposeProviderElement(this);
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
  void mayNeedDispose() {
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
  final _stateToDispose =
      LinkedList<_LinkedListEntry<AutoDisposeProviderElement>>();

  /// Marks an [AutoDisposeProvider] as potentially needing to be disposed.
  void scheduleDispose(AutoDisposeProviderElement element) {
    assert(
      !element.hasListeners,
      'Tried to dispose ${element._provider} , but still has listeners',
    );

    _stateToDispose.add(_LinkedListEntry(element));

    if (!_scheduled) {
      _scheduled = true;
      Future.microtask(() {
        try {
          _performDispose();
        } finally {
          _scheduled = false;
          _stateToDispose.clear();
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
    for (_LinkedListEntry<AutoDisposeProviderElement<Object?, Object?>>? entry =
            _stateToDispose.first;
        entry != null;
        entry = entry.next) {
      if (entry.value.maintainState ||
          entry.value.hasListeners ||
          !entry.value.mounted) {
        continue;
      }
      entry.value.container._disposeProvider(entry.value._origin);
    }
  }
}
