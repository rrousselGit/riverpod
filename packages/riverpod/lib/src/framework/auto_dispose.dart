part of 'framework.dart';

abstract class AutoDisposeProviderBase<
    Dependency extends ProviderDependencyBase,
    Result> extends ProviderBase<Dependency, Result> {
  AutoDisposeProviderBase(String name) : super(name);

  @override
  AutoDisposeProviderStateBase<Dependency, Result,
      AutoDisposeProviderBase<Dependency, Result>> createState();
}

abstract class OverridableAutoDisposeProviderBase<
        Dependency extends ProviderDependencyBase,
        Result> extends AutoDisposeProviderBase<Dependency, Result>
    implements ProviderOverride {
  OverridableAutoDisposeProviderBase(String name) : super(name);

  @override
  ProviderBase get _provider => this;

  @override
  ProviderBase<Dependency, Result> get _origin => this;

  ProviderOverride overrideAs(
    // Auto-disposed providers can be overriden by anything that matches
    // as they don't have a `read` method.
    ProviderBase<Dependency, Result> provider,
  ) {
    return ProviderOverride._(provider, this);
  }
}

abstract class AutoDisposeProviderStateBase<
        Dependency extends ProviderDependencyBase,
        Result,
        P extends AutoDisposeProviderBase<Dependency, Result>>
    extends ProviderStateBase<Dependency, Result, P> {
  @override
  void onRemoveListener() {
    if (!$hasListeners) {
      _AutoDisposer.instance.scheduleDispose(this);
    }
  }
}

/// A class that handles automatically disposing provider states when they are
/// no-longer listened.
class _AutoDisposer {
  static final _AutoDisposer instance = _AutoDisposer();

  bool _scheduled = false;
  LinkedList<_LinkedListEntry<ProviderStateBase>> _stateToDispose;

  void scheduleDispose(ProviderStateBase state) {
    _stateToDispose ??= LinkedList();
    _stateToDispose.add(_LinkedListEntry(state));

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
      if (entry.value.$hasListeners || !entry.value.mounted) {
        continue;
      }
      entry.value.dispose();
      final reader = entry.value._origin is Computed
          ? entry.value._owner._computedStateReaders[entry.value._origin]
          : entry.value._owner._stateReaders[entry.value._origin];
      // TODO remove ProviderStateReader on dispose for non-overriden providers.
      reader._providerState = null;
    }
  }
}
