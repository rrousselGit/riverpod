part of 'framework.dart';

/// A base class for all providers.
///
/// Do not extend or implement.
@immutable
@optionalTypeArgs
abstract class ProviderBase<Subscription extends ProviderSubscriptionBase,
    Result extends Object> {
  /// Allows specifying a name.
  // ignore: prefer_const_constructors_in_immutables, the canonalisation of constants is unsafe for providers.
  ProviderBase(this.name);

  @visibleForOverriding
  ProviderStateBase<Subscription, Result, ProviderBase<Subscription, Result>>
      createState();

  /// A custom label for the provider.
  ///
  /// Specifying a name has multiple uses:
  /// - It makes devtools and logging more readable
  /// - It can be used as a serialisable unique identifier for state serialisation/deserialisation.
  final String name;

  /// Adds a listener to the provider.
  ///
  /// If you are using Flutter, you probably do not need to care about this method.
  ///
  /// The callback is called synchronously immediatly with the latest value.
  /// It is then called whenever [ProviderStateOwner.update] was called and the
  /// provider listened had changed.
  ///
  /// The result of this method is a function that allows removing the listener.
  ///
  /// The callback will be called at most once per [ProviderStateOwner.update] calls.
  VoidCallback watchOwner(
    ProviderStateOwner owner,
    void Function(Result value) onChange,
  ) {
    return owner._readProviderState(this).$addListener(onChange);
  }
}

/// Implementation detail of how the state of a provider is stored.
// TODO: prefix internal methods with $ and public methods without
@optionalTypeArgs
abstract class ProviderStateBase<Subscription extends ProviderSubscriptionBase,
    Result extends Object, P extends ProviderBase<Subscription, Result>> {
  ProviderStateBase() {
    _stateEntryInSortedStateList = _LinkedListEntry(this);
  }

  P _provider;

  /// The current [ProviderBase] associated with this state.
  ///
  /// It may change if the provider is overriden, and the override changes,
  /// in which case it will call [didUpdateProvider].
  @protected
  @visibleForTesting
  P get provider => _provider;

  /// The raw unmodified provider before applying [ProviderOverride].
  ProviderBase<ProviderSubscriptionBase, Object> _origin;

  var _depth = 0;

  /// How deep this provider is in the graph of providers.
  ///
  /// It starts at 0, and then calls to [ProviderReference.dependOn] will
  /// increase [depth] to the [depth] of the consumed provider + 1.
  int get depth => _depth;

  // Initialised to true to ignore calls to markNeedNotifyListeners inside initState
  var _dirty = true;

  /// Whether this provider was marked as needing to notify its listeners.
  ///
  /// See also [markNeedsNotifyListeners].
  bool get dirty => _dirty;

  /// The location of this state in the internal graph of dependencies of [ProviderStateOwner].
  _LinkedListEntry<ProviderStateBase> _stateEntryInSortedStateList;

  var _mounted = true;

  /// Whether this provider was disposed or not.
  ///
  /// See also [ProviderReference.mounted].
  bool get mounted => _mounted;

  /// The value currently exposed.
  ///
  /// All modifications to this property should induce a call to [markNeedsNotifyListeners].
  @protected
  Result get state;

  /// All the [ProviderStateBase]s that this provider depends on.
  final Set<ProviderStateBase> _providerStateDependencies = {};

  /// A cache of the [ProviderSubscriptionBase] associated to the dependencies
  /// listed by [_providerStateDependencies].
  ///
  /// This avoid having to call [createProviderSubscription] again when this
  /// state already depends on a provider.
  Map<ProviderBase, ProviderSubscriptionBase> _providerSubscriptionsCache;

  /// An implementation detail of [CircularDependencyError].
  ///
  /// This handles the case where [ProviderReference.dependOn] is called
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

  /// The listeners of this provider (using [ProviderBase.watchOwner]).
  LinkedList<_LinkedListEntry<void Function(Result value)>> _stateListeners;

  /// Whether this provider is listened or not.
  // TODO: factor [createSubscription]
  bool get $hasListeners => _stateListeners?.isNotEmpty ?? false;

  /// Initializes the provider.
  ///
  /// If an exception is thrown inside [initState], all attempts
  /// at reading the provider will result in throwing [_error].
  ///
  /// It is safe to call [markNeedsNotifyListeners] inside [initState].
  @protected
  void initState();

  /// Creates the object returned by [ProviderReference.dependOn].
  Subscription createProviderSubscription();

  /// Life-cycle for when [provider] was replaced with a new one.
  ///
  /// This typically happen on [ProviderStateOwner.update] call with new
  /// overrides.
  @mustCallSuper
  @protected
  void didUpdateProvider(P oldProvider) {}

  /// The implementation of [ProviderReference.dependOn].
  T dependOn<T extends ProviderSubscriptionBase>(
    ProviderBase<T, Object> provider,
  ) {
    if (!mounted) {
      throw StateError(
        '`dependOn` was called on a state that is already disposed',
      );
    }
    // verify that we are not in a stack overflow of dependOn calls.
    assert(() {
      if (_debugInitialDependOnRequest == provider) {
        throw CircularDependencyError._();
      }
      _debugInitialDependOnRequest ??= provider;
      return true;
    }(), '');

    _providerSubscriptionsCache ??= {};
    try {
      return _providerSubscriptionsCache.putIfAbsent(provider, () {
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
  /// It then proceeds to recursively redepth all the [ProviderStateBase] that
  /// depends on this state.
  ///
  /// Worse case scenario, this is O(N), even on a complex tree.
  void redepthAfter(ProviderStateBase from) {
    final newDepth = max(_depth, from._depth + 1);
    // The location of the provider in the graph of dependencies did not change
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
    _LinkedListEntry<ProviderStateBase> entry;
    if (from._owner == _owner) {
      /// unlink before reading [next] so that [next] doesn't point to [_stateEntryInSortedStateList].
      _stateEntryInSortedStateList.unlink();
      entry = from._stateEntryInSortedStateList.next;
    } else {
      entry = _stateEntryInSortedStateList.next;
      _stateEntryInSortedStateList.unlink();
    }

    /// Searching for a [ProviderBaseState] in the dependency graph that has a
    /// [depth] >= the new [depth] of this state.
    for (; entry != null && _depth > entry.value._depth; entry = entry.next) {}

    if (entry != null) {
      entry.insertBefore(_stateEntryInSortedStateList);
    } else {
      // No matching ProviderBaseState found, so we add this state at the very end
      // of the list of dependencies.
      _owner._providerStatesSortedByDepth.add(_stateEntryInSortedStateList);
    }

    // TODO: recursive _redepth
    // for (final dep in _providerStateDependencies) {
    //   dep.redepthAfter(this);
    // }
  }

  void onDispose(VoidCallback cb) {
    if (!mounted) {
      throw StateError(
        '`onDispose` was called on a state that is already disposed',
      );
    }
    _onDisposeCallbacks ??= DoubleLinkedQueue();
    _onDisposeCallbacks.add(cb);
  }

  VoidCallback $addListener(
    void Function(Result value) listener,
  ) {
    try {
      notifyListenersDepthLock = depth;
      listener(state);
    } finally {
      notifyListenersDepthLock = -1;
    }
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
    _owner._reportChanged(_origin, state);

    if (_stateListeners != null) {
      for (final listener in _stateListeners) {
        // TODO guard
        listener.value(state);
      }
    }
  }

  void markNeedsNotifyListeners() {
    if (notifyListenersLock != null && notifyListenersLock != this) {
      throw StateError(
        'Cannot mark providers as dirty while initializing/disposing another provider',
      );
    }
    if (notifyListenersDepthLock >= depth) {
      throw StateError(
        'Cannot mark `$provider` as dirty from `$notifyListenersDepthLock` as the latter depends on it.',
      );
    }
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
    _mounted = false;
    if (_onDisposeCallbacks != null) {
      _onDisposeCallbacks.forEach(_runGuarded);
    }

    if (_owner._observers != null) {
      for (final observer in _owner._observers) {
        _runUnaryGuarded(observer.didDisposeProvider, _origin);
      }
    }
  }

  @override
  String toString() {
    return 'ProviderState<$Result>(depth: $depth)';
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
abstract class AlwaysAliveProvider<
        Subscription extends ProviderSubscriptionBase, Result>
    extends ProviderBase<Subscription, Result> implements ProviderOverride {
  /// Creates an [AlwaysAliveProvider] and allows specifing a [name].
  AlwaysAliveProvider(String name) : super(name);

  @override
  ProviderBase get _origin => this;

  @override
  ProviderBase get _provider => this;

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

  // Always alive providers can only be overriden by always alive providers
  // as automatically disposed providers wouldn't work.
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
  ///         repositoryProvider.overrideForSubtree(
  ///           Provider((_) => FakeRepository()),
  ///         ),
  ///       ],
  ///       child: MyApp(),
  ///     ),
  ///   );
  /// });
  /// ```
  ProviderOverride overrideForSubtree(
    AlwaysAliveProvider<Subscription, Result> provider,
  ) {
    return ProviderOverride._(provider, this);
  }
}
