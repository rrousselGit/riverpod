part of 'framework.dart';

/// A base class used that expose the necessary to listen to a provider.
///
/// This is the common interface between a "provider" and `myProvider.select`
/// defined by `hooks_riverpod`.
/// .
///
/// See also:
/// - [ProviderBase], the base class for all providers, which implements [ProviderListenable].
/// - `ProviderBase.select`, a function that allows listening only partially
///   to a provider.
// ignore: one_member_abstracts
abstract class ProviderListenable<T> {
  /// Listen to changes on a provider.
  ///
  /// The [onChange] callback will be called immediatly with the current value.
  ///
  /// This method is an implementation detail of [Computed]/`select`.
  /// It allows listening to a provider partially, without evaluating the computation
  /// immediatly on change, for performance.
  ///
  /// More specifically, when one of the dependencies of [Computed] changes,
  /// this will call [mayHaveChanged] on all the listeners.
  /// But this will **not** re-evaluated the [Computed].
  ///
  /// Instead, the evaluation of the [Computed] is delayed until [ProviderSubscription.flush]
  /// is called. Then, if the result of [Computed] changes, [ProviderSubscription.flush]
  /// will return `true` and [onChange] will be called.
  ProviderSubscription addLazyListener(
    ProviderStateOwner owner, {
    @required void Function() mayHaveChanged,
    @required void Function(T value) onChange,
  });
}

/// Manages a subscription created with [ProviderListenable.addLazyListener].
abstract class ProviderSubscription {
  ProviderSubscription._();

  /// Recompute a selector/[Computed] if not computed already.
  ///
  /// Calling [flush] will potentially call `onChange` of [ProviderListenable.addLazyListener]
  /// if the value exposed by the provider listened changed, in which case [flush]
  /// will return `true`.
  ///
  /// On the other hand, the value exposed by the provider did not change,
  /// `onChange` will not be called and [flush] will return `false`.
  bool flush();

  /// Stop listening to the provider.
  void close();
}

/// The concrete implementation of [ProviderSubscription] for [ProviderBase.addLazyListener].
class _ProviderSubscription<T> implements ProviderSubscription {
  _ProviderSubscription(
    this._providerState,
    this._onChange,
    this._entry,
  ) : _lastNotificationCount = _providerState._notificationCount;

  int _lastNotificationCount;
  final ProviderStateBase<ProviderDependencyBase, T,
      ProviderBase<ProviderDependencyBase, T>> _providerState;
  final void Function(T value) _onChange;
  final LinkedListEntry _entry;

  @override
  bool flush() {
    if (_entry.list == null) {
      return false;
    }
    _providerState._performFlush();
    if (_providerState._notificationCount != _lastNotificationCount) {
      _lastNotificationCount = _providerState._notificationCount;

      assert(() {
        debugNotifyListenersDepthLock = _providerState._debugDepth;
        return true;
      }(), '');
      _runUnaryGuarded(_onChange, _providerState.state);
      assert(() {
        debugNotifyListenersDepthLock = -1;
        return true;
      }(), '');
      return true;
    }
    return false;
  }

  @override
  void close() {
    // TODO
    _entry.unlink();
  }
}

/// A base class for all providers.
///
/// Do not extend or implement.
@optionalTypeArgs
abstract class ProviderBase<Dependency extends ProviderDependencyBase,
    Result extends Object> implements ProviderListenable<Result> {
  /// Allows specifying a name.
  // ignore: prefer_const_constructors_in_immutables, the canonalisation of constants is unsafe for providers.
  ProviderBase(this.name);

  /// Internal method for creating the state associated to a provider. Do not use.
  @visibleForOverriding
  ProviderStateBase<Dependency, Result, ProviderBase<Dependency, Result>>
      createState();

  /// A custom label for the provider.
  ///
  /// Specifying a name has multiple uses:
  /// - It makes devtools and logging more readable
  /// - It can be used as a serialisable unique identifier for state serialisation/deserialisation.
  final String name;

  Family _family;

  /// The family from which this provider is coming from, or `null` or none.
  Family get family => _family;

  Object _parameter;

  /// If associated with a family, this is the parameter used to create this provider.
  Object get parameter => _parameter;

  @override
  ProviderSubscription addLazyListener(
    ProviderStateOwner owner, {
    @required void Function() mayHaveChanged,
    @required void Function(Result value) onChange,
  }) {
    return owner
        ._readProviderState(this)
        .addLazyListener(mayHaveChanged: mayHaveChanged, onChange: onChange);
  }

  /// Listen to a provider and calls [onChange] when the provider updates.
  ///
  /// Calls [onChange] immediatly with the latest value.
  ///
  /// The result of [watchOwner] is a function that can be called to
  /// stop listening to the provider.
  ///
  /// This is syntax sugar for [addLazyListener] where `mayHaveChanged` calls
  /// [ProviderSubscription.flush] immediatly.
  /// Avoid using this on [Computed] if possible.
  VoidCallback watchOwner(
    ProviderStateOwner owner,
    void Function(Result value) onChange,
  ) {
    ProviderSubscription sub;

    sub = addLazyListener(
      owner,
      mayHaveChanged: () => sub.flush(),
      onChange: onChange,
    );

    return sub.close;
  }

  @override
  String toString() {
    return '$runtimeType#$hashCode(name: $name)';
  }
}

/// Implementation detail of how the state of a provider is stored.
// TODO: prefix internal methods with $ and public methods without
@optionalTypeArgs
abstract class ProviderStateBase<Dependency extends ProviderDependencyBase,
    Result extends Object, P extends ProviderBase<Dependency, Result>> {
  P _provider;

  /// The current [ProviderBase] associated with this state.
  ///
  /// It may change if the provider is overriden, and the override changes,
  /// in which case it will call [didUpdateProvider].
  @protected
  @visibleForTesting
  P get provider => _provider;

  /// The raw unmodified provider before applying [ProviderOverride].
  ProviderBase<ProviderDependencyBase, Object> _origin;

  /// The number of time the value exposed changes.
  /// This is an implementation detail to [ProviderSubscription.flush].
  int _notificationCount = 0;

  // Initialised to true to ignore calls to markNeedNotifyListeners inside initState
  var _dirty = true;

  /// Whether this provider was marked as needing to notify its listeners.
  ///
  /// See also [markMayHaveChanged].
  bool get dirty => _dirty;

  var _mounted = true;

  /// Whether this provider was disposed or not.
  ///
  /// See also [ProviderReference.mounted].
  bool get mounted => _mounted;

  /// The value currently exposed.
  ///
  /// All modifications to this property should induce a call to [markMayHaveChanged].
  @protected
  Result get state;

  /// All the states that depends on this provider.
  final _dependents = HashSet<ProviderStateBase>();

  /// The list of the providers that depends on this state, or `null` in release mode.
  @visibleForTesting
  Set<ProviderStateBase> get debugDependents {
    Set<ProviderStateBase> result;
    assert(() {
      result = {..._dependents};
      return true;
    }(), '');
    return result;
  }

  /// All the [ProviderStateBase]s that this provider depends on.
  final _providerStateDependencies = HashSet<ProviderStateBase>();

  /// A cache of the [ProviderDependencyBase] associated to the dependencies
  /// listed by [_providerStateDependencies].
  ///
  /// This avoid having to call [createProviderDependency] again when this
  /// state already depends on a provider.
  Map<ProviderBase, ProviderDependencyBase> _providerDependenciesCache;

  /// An implementation detail of [CircularDependencyError].
  ///
  /// This handles the case where [ProviderReference.read] is called
  /// synchronously during the creation of the provider.
  ProviderBase _debugInitialDependOnRequest;

  /// The exception thrown inside [initState], if any.
  ///
  /// If [_error] is not `null`, this disable all functionalities of the provider
  /// and trying to read the provider will result in throwing this object again.
  Object _error;

  ProviderStateOwner _owner;

  /// The [ProviderStateOwner] that keeps a reference to this state.
  ProviderStateOwner get owner => _owner;

  /// The list of listeners to [ProviderReference.onDispose].
  DoubleLinkedQueue<VoidCallback> _onDisposeCallbacks;

  /// The listeners of this provider (using [ProviderBase.addLazyListener]).
  LinkedList<_LinkedListEntry<void Function()>> _mayHaveChangedListeners;

  bool _debugIsPerformingFlush = false;

  /// Whether this provider is listened or not.
  bool get $hasListeners {
    return _dependents.isNotEmpty ||
        (_mayHaveChangedListeners?.isNotEmpty ?? false);
  }

  int get _debugDepth {
    int result;
    assert(() {
      final states =
          _owner._visitStatesInReverseOrder().toList().reversed.toList();
      result = states.indexOf(this);
      return true;
    }(), '');
    return result;
  }

  /// Initialize the state of the provider on creation.
  ///
  /// All calls to [markMayHaveChanged] will be ignored.
  /// If [initState] throws, reading the provider will result in an exception.
  void initState();

  /// Creates the object returned by [ProviderReference.read].
  Dependency createProviderDependency();

  /// Life-cycle for when [provider] was replaced with a new one.
  ///
  /// This typically happen on [ProviderStateOwner.updateOverrides] call with new
  /// overrides.
  @mustCallSuper
  @protected
  void didUpdateProvider(P oldProvider) {}

  /// The implementation of [ProviderReference.read].
  T read<T extends ProviderDependencyBase>(
    ProviderBase<T, Object> provider,
  ) {
    if (!mounted) {
      throw StateError(
        '`read` was called on a state that is already disposed',
      );
    }
    // verify that we are not in a stack overflow of read calls.
    assert(() {
      if (_debugInitialDependOnRequest == provider) {
        throw CircularDependencyError._();
      }
      _debugInitialDependOnRequest ??= provider;
      return true;
    }(), '');

    _providerDependenciesCache ??= {};
    try {
      return _providerDependenciesCache.putIfAbsent(provider, () {
        final targetProviderState = _owner._readProviderState(provider);

        // verify that the new dependency doesn't depend on this provider.
        assert(() {
          void recurs(ProviderStateBase state) {
            if (state == this) {
              throw CircularDependencyError._();
            }
            state._providerStateDependencies.forEach(recurs);
          }

          targetProviderState._providerStateDependencies.forEach(recurs);
          return true;
        }(), '');

        _providerStateDependencies.add(targetProviderState);
        targetProviderState._dependents.add(this);

        final targetProviderValue =
            targetProviderState.createProviderDependency();
        onDispose(() {
          // TODO hashListener
          targetProviderState._dependents.remove(this);
        });

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

  /// Implementation of [ProviderReference.onDispose].
  void onDispose(VoidCallback cb) {
    if (!mounted) {
      throw StateError(
        '`onDispose` was called on a state that is already disposed',
      );
    }
    _onDisposeCallbacks ??= DoubleLinkedQueue();
    _onDisposeCallbacks.add(cb);
  }

  /// Implementation of [ProviderBase.addLazyListener].
  ProviderSubscription addLazyListener({
    @required void Function() mayHaveChanged,
    @required void Function(Result value) onChange,
  }) {
    assert(() {
      debugNotifyListenersDepthLock = _debugDepth;
      return true;
    }(), '');
    _runUnaryGuarded(onChange, state);
    assert(() {
      debugNotifyListenersDepthLock = -1;
      return true;
    }(), '');

    _mayHaveChangedListeners ??= LinkedList();
    final mayHaveChangedEntry = _LinkedListEntry(mayHaveChanged);
    _mayHaveChangedListeners.add(mayHaveChangedEntry);

    return _ProviderSubscription(
      this,
      onChange,
      mayHaveChangedEntry,
    );
  }

  /// After [markMayHaveChanged] was called, [flush] is called [ProviderSubscription.flush]
  /// of on [AlwaysAliveProviderBase.readOwner].
  ///
  /// Do not call directy. Instead call it through [_performFlush].
  @visibleForOverriding
  @protected
  void flush() {
    notifyChanged();
  }

  void _performFlush() {
    if (_dirty) {
      _dirty = false;
      assert(() {
        _debugIsPerformingFlush = true;
        return true;
      }(), '');
      try {
        flush();
      } finally {
        assert(() {
          _debugIsPerformingFlush = false;
          return true;
        }(), '');
      }
    }
  }

  /// Notify listeners that a new value was emitted. Can only be called inside [flush].
  void notifyChanged() {
    assert(_debugIsPerformingFlush,
        '`notifyChanged` can only be called within `flush`');
    if (!_mounted) {
      throw StateError(
        'Cannot notify listeners of a provider after if was dispose',
      );
    }
    _notificationCount++;
    _owner._reportChanged(_origin, state);
  }

  /// Notify listeners that the provider **may** have changed.
  ///
  /// This is used by [Computed]/`select` to compute the new value
  /// only when truly needed.
  void markMayHaveChanged() {
    if (notifyListenersLock != null && notifyListenersLock != this) {
      throw StateError(
        'Cannot mark providers as dirty while initializing/disposing another provider',
      );
    }
    assert(
      debugNotifyListenersDepthLock < _debugDepth,
      'Cannot mark `$provider` as dirty from `$debugNotifyListenersDepthLock` as the latter depends on it.',
    );
    if (_error != null) {
      throw StateError(
        'Cannot trigger updates on a provider that threw during creation',
      );
    }
    if (!_mounted) {
      throw StateError(
        'Cannot notify listeners of a provider after if was dispose',
      );
    }
    if (!_dirty) {
      _dirty = true;

      if (_mayHaveChangedListeners != null) {
        for (final mayHaveChanged in _mayHaveChangedListeners) {
          // TODO guard
          mayHaveChanged.value();
        }
      }
    }
  }

  /// Life-cycle for when the provider state is destroyed.
  ///
  /// It triggers [ProviderReference.onDispose]
  @mustCallSuper
  void dispose() {
    assert(
      _dependents.isEmpty,
      'The provider $provider was disposed when other providers are still listening to it',
    );
    _mounted = false;
    _providerStateDependencies.clear();
    _providerDependenciesCache = null;
    _mayHaveChangedListeners = null;
    if (_onDisposeCallbacks != null) {
      _onDisposeCallbacks.forEach(_runGuarded);
    }
    _onDisposeCallbacks = null;

    if (_owner._observers != null) {
      for (final observer in _owner._observers) {
        _runUnaryGuarded(observer.didDisposeProvider, _origin);
      }
    }
  }
}

/// A base class for providers that do not dispose themselves naturally.
///
/// What this means is, once the provider was read once, even if the value
/// is no longer used, the provider still will not be destroyed.
///
/// The main reason why this would be desired is, it allows simplifying
/// the process of reading the provider:
/// Since the provider is never destroyed, we can safely read the provider
/// without "listening" to it.
///
/// This allows implementing methods like [readOwner], or if using Flutter
/// do `provider.read(BuildContext)`.
///
/// Similarly, since these providers are never disposed, they can only be
/// overriden by providers that too are never disposed.
/// Otherwise methods like [readOwner] would have an unknown behavior.
abstract class AlwaysAliveProviderBase<
        Dependency extends ProviderDependencyBase, Result>
    extends ProviderBase<Dependency, Result> implements ProviderOverride {
  /// Creates an [AlwaysAliveProviderBase] and allows specifing a [name].
  AlwaysAliveProviderBase(String name) : super(name);

  @override
  ProviderBase get _provider => this;

  @override
  ProviderBase<Dependency, Result> get _origin => this;

  /// Reads a provider without listening to it and returns the currently
  /// exposed value.
  ///
  /// ```dart
  /// final greetingProvider = Provider((_) => 'Hello world');
  ///
  /// void main() {
  ///   final owner = ProviderStateOwner();
  ///
  ///   print(greetingProvider.readOwner(owner)); // Hello World
  /// }
  /// ```
  Result readOwner(ProviderStateOwner owner) {
    return owner._readProviderState(this).state;
  }

  /// Combined with [ProviderStateOwner] (or `ProviderScope` if you are using Flutter),
  /// allows overriding the behavior of this provider for a part of the application.
  ///
  /// A use-case could be for testing, to override the implementation of a
  /// `Repository` class with a fake implementation.
  ///
  /// In a Flutter application, this would look like:
  ///
  /// ```dart
  /// final repositoryProvider = Provider((_) => Repository());
  ///
  /// testWidgets('Override example', (tester) async {
  ///   await tester.pumpWidget(
  ///     ProviderScope(
  ///       overrides: [
  ///         repositoryProvider.overrideAs(
  ///           Provider((_) => FakeRepository()),
  ///         ),
  ///       ],
  ///       child: MyApp(),
  ///     ),
  ///   );
  /// });
  /// ```
  ProviderOverride overrideAs(
    // Always alive providers can only be overriden by always alive providers
    // as automatically disposed providers wouldn't work.
    AlwaysAliveProviderBase<Dependency, Result> provider,
  ) {
    return ProviderOverride._(provider, this);
  }
}

abstract class AutoDisposeProviderBase<
    Dependency extends ProviderDependencyBase,
    Result> extends ProviderBase<Dependency, Result> {
  AutoDisposeProviderBase(String name) : super(name);

  // TODO overrideAs
}
