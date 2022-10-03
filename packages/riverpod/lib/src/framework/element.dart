part of '../framework.dart';

/// {@template riverpod.refreshable}
/// An interface for provider expressions that can be passed to `ref.refresh`
///
/// This differentiates:
///
/// ```dart
/// ref.watch(provider);
/// ref.watch(provider.future);
/// ```
///
/// from:
///
/// ```dart
/// ref.watch(provider.select((value) => value));
/// ```
/// {@endtemplate}
abstract class Refreshable<T> implements ProviderListenable<T> {
  /// The provider that is being refreshed.
  ProviderBase<Object?> get _origin;
}

/// {@macro riverpod.refreshable}
abstract class AlwaysAliveRefreshable<T>
    implements Refreshable<T>, AlwaysAliveProviderListenable<T> {}

/// An internal class that handles the state of a provider.
///
/// Do not use.
abstract class ProviderElementBase<State> implements Ref<State>, Node {
  /// Do not use.
  ProviderElementBase(this._provider);

  static ProviderElementBase? _debugCurrentlyBuildingElement;

  /// The last result of [ProviderBase.debugGetCreateSourceHash].
  ///
  /// Available only in debug mode.
  String? _debugCurrentCreateHash;
  var _debugSkipNotifyListenersAsserts = false;

  /// The provider associated with this [ProviderElementBase], before applying overrides.
  // Not typed as <State> because of https://github.com/rrousselGit/riverpod/issues/1100
  ProviderBase<Object?> get origin => _origin;
  late ProviderBase<Object?> _origin;

  /// The provider associated with this [ProviderElementBase], after applying overrides.
  ProviderBase<State> get provider => _provider;
  ProviderBase<State> _provider;

  /// The [ProviderContainer] that owns this [ProviderElementBase].
  @override
  ProviderContainer get container => _container;
  late ProviderContainer _container;

  /// Whether this [ProviderElementBase] is currently listened to or not.
  ///
  /// This maps to listeners added with [listen].
  /// See also [mayNeedDispose], called when [hasListeners] may have changed.
  bool get hasListeners =>
      _externalDependents.isNotEmpty ||
      _subscribers.isNotEmpty ||
      _providerDependents.isNotEmpty;

  // TODO(rrousselGit) refactor to match ChangeNotifier
  /// The list of [ProviderSubscription]s that are linked with this element,
  /// which aren't coming from another provider.
  ///
  /// This is typically Flutter widgets or manual calls to [ProviderContainer.listen]
  /// with this provider as target.
  final _externalDependents = <_ExternalProviderSubscription<State>>[];

  /// The [ProviderSubscription]s associated to the providers that this
  /// [ProviderElementBase] listens to.
  ///
  /// This list is typically updated when this provider calls [listen] on
  /// another provider.
  final _listenedProviderSubscriptions = <_ProviderListener>[];

  /// The element of the providers that depends on this provider.
  final _providerDependents = <ProviderElementBase>[];

  /// The subscriptions associated to other providers listening to this provider.
  ///
  /// Storing [_ProviderListener] instead of the raw [ProviderElementBase] as
  /// a provider can listen multiple times to another provider with different listeners.
  final _subscribers = <_ProviderListener>[];

  var _dependencies = HashMap<ProviderElementBase, Object>();
  HashMap<ProviderElementBase, Object>? _previousDependencies;
  List<void Function()>? _onDisposeListeners;
  List<void Function()>? _onResumeListeners;
  List<void Function()>? _onCancelListeners;
  List<void Function()>? _onAddListeners;
  List<void Function()>? _onRemoveListeners;
  List<void Function(State?, State)>? _onChangeSelfListeners;
  List<void Function(Object, StackTrace)>? _onErrorSelfListeners;

  bool _mustRecomputeState = false;
  bool _dependencyMayHaveChanged = false;
  bool _didChangeDependency = false;

  var _didCancelOnce = false;

  bool _mounted = false;

  /// Whether the element was disposed or not
  @visibleForTesting
  bool get mounted => _mounted;

  /// Whether the assert that prevents [requireState] from returning
  /// if the state was not set before is enabled.
  @visibleForOverriding
  bool get debugAssertDidSetStateEnabled => true;

  bool _debugDidSetState = false;
  bool _didBuild = false;

  /* STATE */
  Result<State>? _state;

  /// Update the exposed value of a provider and notify its listeners.
  ///
  /// Listeners will only be notified if [updateShouldNotify]
  /// returns true.
  ///
  /// This API is not meant for public consumption. Instead if a [Ref] needs
  /// to expose a way to update the state, the practice is to expose a getter/setter.
  @protected
  void setState(State newState) {
    assert(
      () {
        _debugDidSetState = true;
        return true;
      }(),
      '',
    );
    final previousResult = getState();
    final result = _state = ResultData(newState);

    if (_didBuild) {
      _notifyListeners(result, previousResult);
    }
  }

  /// Obtains the current state, of null if the provider has yet to initialize.
  ///
  /// The returned object will contain error information, if any.
  /// This function does not cause the provider to rebuild if it someohow was
  /// outdated.
  ///
  /// This is not meant for public consumption. Instead, public API should use
  /// [readSelf].
  @protected
  @visibleForTesting
  Result<State>? getState() => _state;

  /// Read the current value of a provider and:
  ///
  /// - if in error state, rethrow the error
  /// - if the provider is not initialized, gracefully handle the error.
  ///
  /// This is not meant for public consumption. Instead, public API should use
  /// [readSelf].
  @protected
  State get requireState {
    assert(
      () {
        if (debugAssertDidSetStateEnabled && !_debugDidSetState) {
          throw StateError(
            'Tried to read the state of an uninitialized provider',
          );
        }
        return true;
      }(),
      '',
    );

    final state = getState();
    if (state == null) {
      throw StateError('Tried to read the state of an uninitialized provider');
    }

    return state.when(
      error: throwErrorWithCombinedStackTrace,
      data: (data) => data,
    );
  }

  /// Called when a provider is rebuilt. Used for providers to not notify their
  /// listeners if the exposed value did not change.
  @visibleForOverriding
  bool updateShouldNotify(State previous, State next);

  /* /STATE */

  /// A life-cycle executed when a hot-reload is performed.
  ///
  /// This is equivalent to Flutter's `State.reassemble`.
  ///
  /// This life-cycle is used to check for change in [ProviderBase.debugGetCreateSourceHash],
  /// and invalidate the provider state on change.
  void debugReassemble() {
    assert(
      () {
        final previousHash = _debugCurrentCreateHash;
        _debugCurrentCreateHash = provider.debugGetCreateSourceHash?.call();

        if (previousHash != _debugCurrentCreateHash) {
          invalidateSelf();
        }

        return true;
      }(),
      '',
    );
  }

  /// Called the first time a provider is obtained.
  @protected
  @mustCallSuper
  void mount() {
    _mounted = true;
    assert(
      () {
        RiverpodBinding.debugInstance
            .providerListChangedFor(containerId: container._debugId);

        _debugCurrentCreateHash = provider.debugGetCreateSourceHash?.call();

        return true;
      }(),
      '',
    );
    buildState();

    _state!.map(
      data: (newState) {
        final onChangeSelfListeners = _onChangeSelfListeners;
        if (onChangeSelfListeners != null) {
          for (var i = 0; i < onChangeSelfListeners.length; i++) {
            Zone.current.runBinaryGuarded(
              onChangeSelfListeners[i],
              null,
              newState.state,
            );
          }
        }
      },
      error: (newState) {
        final onErrorSelfListeners = _onErrorSelfListeners;
        if (onErrorSelfListeners != null) {
          for (var i = 0; i < onErrorSelfListeners.length; i++) {
            Zone.current.runBinaryGuarded(
              onErrorSelfListeners[i],
              newState.error,
              newState.stackTrace,
            );
          }
        }
      },
    );
  }

  // ignore: use_setters_to_change_properties
  /// Called when the override of a provider changes.
  ///
  /// See also:
  /// - `overrideWithValue`, which relies on [update] to handle
  ///   the scenario where the value changed.
  @protected
  @mustCallSuper
  // ignore: use_setters_to_change_properties
  void update(ProviderBase<State> newProvider) {
    _provider = newProvider;
  }

  @override
  void invalidate(ProviderOrFamily provider) {
    _container.invalidate(provider);
  }

  @override
  void invalidateSelf() {
    if (_mustRecomputeState) return;

    _mustRecomputeState = true;
    runOnDispose();
    _container._scheduler.scheduleProviderRefresh(this);

    // We don't call this._markDependencyMayHaveChanged here because we voluntarily
    // do not want to set the _dependencyMayHaveChanged flag to true.
    // Since the dependency is known to have changed, there is no reason to try
    // and "flush" it, as it will already get rebuilt.
    visitChildren(
      elementVisitor: (element) => element._markDependencyMayHaveChanged(),
      notifierVisitor: (notifier) => notifier.notifyDependencyMayHaveChanged(),
    );
  }

  /// A utility for re-initializing a provider when needed.
  ///
  /// Calling [flush] will only re-initialize the provider if it needs to rerun.
  /// This can involve:
  /// - a previous call to [invalidateSelf]
  /// - a dependency of the provider has changed (such as when using [watch]).
  ///
  /// This is not meant for public consumption. Public API should hide
  /// [flush] from users, such that they don't need to care about invocing this function.
  void flush() {
    _maybeRebuildDependencies();
    if (_mustRecomputeState) {
      _mustRecomputeState = false;
      _performBuild();
    }
  }

  /// Iterates over the dependencies of this provider, calling [flush] on them too.
  ///
  /// This work is only performed if a dependency has notified that it might
  /// need to be re-executed.
  void _maybeRebuildDependencies() {
    if (!_dependencyMayHaveChanged) return;

    _dependencyMayHaveChanged = false;

    visitAncestors(
      (element) {
        element.flush();
      },
    );
  }

  /// Initialize a provider and track dependencies used during the initialization.
  ///
  /// After a provider is initialized, this function takes care of unsubscribing
  /// to dependencies that are no-longer used.
  void _performBuild() {
    _previousDependencies = _dependencies;
    _dependencies = HashMap();

    final previousStateResult = _state;

    assert(
      () {
        _debugDidSetState = false;
        return true;
      }(),
      '',
    );
    buildState();

    if (!identical(_state, previousStateResult)) {
      assert(
        () {
          // Asserts would otherwise prevent a provider rebuild from updating
          // other providers
          _debugSkipNotifyListenersAsserts = true;
          return true;
        }(),
        '',
      );
      _notifyListeners(_state!, previousStateResult);
      assert(
        () {
          _debugSkipNotifyListenersAsserts = false;
          return true;
        }(),
        '',
      );
    }

    // Unsubscribe to everything that a provider no longer depends on.
    for (final sub in _previousDependencies!.entries) {
      sub.key
        .._providerDependents.remove(this)
        .._onRemoveListener();
    }
    _previousDependencies = null;
  }

  /// Initialize a provider.
  ///
  /// This function **must** call [setState] or throw (or both).
  ///
  /// Exceptions within this function will be caught and set the provider in error
  /// state. Then, reading this provider will rethrow the thrown exception.
  ///
  /// - [didChangeDependency] can be used to differentiate a rebuild caused
  ///   by [watch] from one caused by [refresh]/[invalidate].
  @visibleForOverriding
  @protected
  void create({required bool didChangeDependency});

  /// Invokes [create] and handles errors.
  @pragma('vm:notify-debugger-on-exception')
  void buildState() {
    ProviderElementBase? debugPreviouslyBuildingElement;
    final previousDidChangeDependency = _didChangeDependency;
    _didChangeDependency = false;
    assert(
      () {
        debugPreviouslyBuildingElement = _debugCurrentlyBuildingElement;
        _debugCurrentlyBuildingElement = this;
        return true;
      }(),
      '',
    );
    _didBuild = false;
    try {
      // TODO move outside this function?
      _mounted = true;
      create(didChangeDependency: previousDidChangeDependency);
    } catch (err, stack) {
      assert(
        () {
          _debugDidSetState = true;
          return true;
        }(),
        '',
      );
      _state = Result.error(err, stack);
    } finally {
      _didBuild = true;
      assert(
        () {
          _debugCurrentlyBuildingElement = debugPreviouslyBuildingElement;
          return true;
        }(),
        '',
      );

      assert(
        getState() != null,
        'Bad state, the provider did not initialize. Did "create" forget to set the state?',
      );
    }
  }

  void _notifyListeners(
    Result<State> newState,
    Result<State>? previousStateResult,
  ) {
    assert(
      () {
        if (_debugSkipNotifyListenersAsserts) return true;

        assert(
          _debugCurrentlyBuildingElement == null ||
              _debugCurrentlyBuildingElement == this,
          '''
Providers are not allowed to modify other providers during their initialization.

The provider ${_debugCurrentlyBuildingElement!.origin} modified $origin while building.
''',
        );

        container.debugCanModifyProviders?.call();
        return true;
      }(),
      '',
    );

    final previousState = previousStateResult?.stateOrNull;

    // listenSelf listeners do not respect updateShouldNotify
    newState.map(
      data: (newState) {
        final onChangeSelfListeners = _onChangeSelfListeners;
        if (onChangeSelfListeners != null) {
          for (var i = 0; i < onChangeSelfListeners.length; i++) {
            Zone.current.runBinaryGuarded(
              onChangeSelfListeners[i],
              previousState,
              newState.state,
            );
          }
        }
      },
      error: (newState) {
        final onErrorSelfListeners = _onErrorSelfListeners;
        if (onErrorSelfListeners != null) {
          for (var i = 0; i < onErrorSelfListeners.length; i++) {
            Zone.current.runBinaryGuarded(
              onErrorSelfListeners[i],
              newState.error,
              newState.stackTrace,
            );
          }
        }
      },
    );

    if (previousStateResult != null &&
        previousStateResult.hasState &&
        newState.hasState &&
        !updateShouldNotify(
          previousState as State,
          newState.requireState,
        )) {
      return;
    }

    final listeners = _externalDependents.toList(growable: false);
    final subscribers = _subscribers.toList(growable: false);
    newState.map(
      data: (newState) {
        for (var i = 0; i < listeners.length; i++) {
          Zone.current.runBinaryGuarded(
            listeners[i]._listener,
            previousState,
            newState.state,
          );
        }
        for (var i = 0; i < subscribers.length; i++) {
          Zone.current.runBinaryGuarded(
            subscribers[i].listener,
            previousState,
            newState.state,
          );
        }
      },
      error: (newState) {
        for (var i = 0; i < listeners.length; i++) {
          Zone.current.runBinaryGuarded(
            listeners[i].onError,
            newState.error,
            newState.stackTrace,
          );
        }
        for (var i = 0; i < subscribers.length; i++) {
          Zone.current.runBinaryGuarded(
            subscribers[i].onError,
            newState.error,
            newState.stackTrace,
          );
        }
      },
    );

    for (var i = 0; i < _providerDependents.length; i++) {
      _providerDependents[i]._markDependencyChanged();
    }

    for (final observer in _container._observers) {
      runQuaternaryGuarded(
        observer.didUpdateProvider,
        provider,
        previousState,
        newState.stateOrNull,
        _container,
      );
    }

    for (final observer in _container._observers) {
      newState.map(
        data: (_) {},
        error: (newState) {
          runQuaternaryGuarded(
            observer.providerDidFail,
            provider,
            newState.error,
            newState.stackTrace,
            _container,
          );
        },
      );
    }
  }

  void _markDependencyChanged() {
    _didChangeDependency = true;
    if (_mustRecomputeState) return;

    // will notify children that their dependency may have changed
    invalidateSelf();
  }

  void _markDependencyMayHaveChanged() {
    if (_dependencyMayHaveChanged) return;

    _dependencyMayHaveChanged = true;

    visitChildren(
      elementVisitor: (element) => element._markDependencyMayHaveChanged(),
      notifierVisitor: (notifier) => notifier.notifyDependencyMayHaveChanged(),
    );
  }

  bool _debugAssertCanDependOn(ProviderListenable listenable) {
    assert(
      () {
        if (listenable is! ProviderBase) return true;

        assert(
          listenable._origin != origin,
          'A provider cannot depend on itself',
        );

        assert(
          provider != origin ||
              // Families are allowed to depend on themselves with different parameters.
              (origin.from != null && listenable.from == origin.from) ||
              origin.dependencies == null ||
              origin.dependencies!.contains(listenable.from) ||
              origin.dependencies!.contains(listenable),
          'The provider $origin tried to read $listenable, but it specified a '
          "'dependendencies' list yet that list does not contain $listenable.\n\n"
          "To fix, add $listenable to $origin's 'dependencies' parameter",
        );

        final queue = Queue<ProviderElementBase>.from(_providerDependents);

        while (queue.isNotEmpty) {
          final current = queue.removeFirst();
          queue.addAll(current._providerDependents);

          if (current.origin == listenable) {
            throw CircularDependencyError._();
          }
        }

        return true;
      }(),
      '',
    );
    return true;
  }

  void _assertNotOutdated() {
    assert(
      _didChangeDependency == false,
      'Cannot use ref functions after the dependency of a provider changed but before the provider rebuilt',
    );
  }

  @override
  T refresh<T>(Refreshable<T> provider) {
    _assertNotOutdated();
    return _container.refresh(provider);
  }

  @override
  T read<T>(ProviderListenable<T> provider) {
    _assertNotOutdated();
    assert(!_debugIsRunningSelector, 'Cannot call ref.read inside a selector');
    assert(_debugAssertCanDependOn(provider), '');
    return _container.read(provider);
  }

  @override
  T watch<T>(ProviderListenable<T> listenable) {
    _assertNotOutdated();
    assert(!_debugIsRunningSelector, 'Cannot call ref.watch inside a selector');

    if (listenable is! ProviderBase<T>) {
      final sub = listen<T>(
        listenable,
        (prev, value) => _markDependencyChanged(),
        onError: (err, stack) => _markDependencyChanged(),
        onDependencyMayHaveChanged: _markDependencyMayHaveChanged,
      );

      return sub.read();
    }

    assert(_debugAssertCanDependOn(listenable), '');

    final element = _container.readProviderElement(listenable);
    _dependencies.putIfAbsent(element, () {
      final previousSub = _previousDependencies?.remove(element);
      if (previousSub != null) {
        return previousSub;
      }

      assert(
        () {
          // Flushing the provider before adding a new dependency
          // as otherwise this could cause false positives with certain asserts.
          // It's done only in debug mode since `readSelf` will flush the value
          // again anyway, and the only value of this flush is to not break asserts.
          element.flush();
          return true;
        }(),
        '',
      );

      element
        .._onListen()
        .._providerDependents.add(this);

      return Object();
    });

    return element.readSelf();
  }

  @override
  ProviderElementBase<T> readProviderElement<T>(ProviderBase<T> provider) {
    return _container.readProviderElement(provider);
  }

  @override
  ProviderSubscription<T> _listenElement<T>(
    ProviderElementBase<T> element, {
    required void Function(T? previous, T next) listener,
    required void Function(Object error, StackTrace stackTrace) onError,
  }) {
    final sub = _ProviderListener<T>._(
      listenedElement: element,
      dependentElement: this,
      listener: (prev, value) => listener(prev as T?, value as T),
      onError: onError,
    );

    element._subscribers.add(sub);
    _listenedProviderSubscriptions.add(sub);

    return sub;
  }

  @override
  ProviderSubscription<T> listen<T>(
    ProviderListenable<T> listenable,
    void Function(T? previous, T value) listener, {
    void Function(Object error, StackTrace stackTrace)? onError,
    bool fireImmediately = false,
    // Not part of the public "Ref" API
    void Function()? onDependencyMayHaveChanged,
  }) {
    _assertNotOutdated();
    assert(!_debugIsRunningSelector, 'Cannot call ref.read inside a selector');
    assert(_debugAssertCanDependOn(listenable), '');

    return listenable.addListener(
      this,
      listener,
      fireImmediately: fireImmediately,
      onError: onError,
      onDependencyMayHaveChanged: onDependencyMayHaveChanged,
    );
  }

  @override
  void listenSelf(
    void Function(State? previous, State next) listener, {
    void Function(Object error, StackTrace stackTrace)? onError,
  }) {
    // TODO do we want to expose a way to close the subscription?
    // TODO do we want a fireImmdiately?

    _onChangeSelfListeners ??= [];
    _onChangeSelfListeners!.add(listener);

    if (onError != null) {
      _onErrorSelfListeners ??= [];
      _onErrorSelfListeners!.add(onError);
    }
  }

  /// Returns the currently exposed by a provider
  ///
  /// May throw if the provider threw when creating the exposed value.
  State readSelf() {
    flush();

    return requireState;
  }

  /// Visit the [ProviderElement]s of providers that are listening to this element.
  ///
  /// A provider is considered as listening to this element if it either [watch]
  /// or [listen] this element.
  ///
  /// This method does not guarantee that a dependency is visited only once.
  /// If a provider both [watch] and [listen] an element, or if a provider
  /// [listen] multiple times to an element, it may be visited multiple times.
  void visitChildren({
    required void Function(ProviderElementBase element) elementVisitor,
    required void Function(ProxyElementValueNotifier element) notifierVisitor,
  }) {
    for (var i = 0; i < _providerDependents.length; i++) {
      elementVisitor(_providerDependents[i]);
    }

    for (var i = 0; i < _subscribers.length; i++) {
      elementVisitor(_subscribers[i].dependentElement);
    }
  }

  /// Visit the [ProviderElementBase]s that this provider is listening to.
  ///
  /// A provider is considered as listening to this element if it either [watch]
  /// or [listen] this element.
  ///
  /// This method does not guarantee that a provider is visited only once.
  /// If this provider both [watch] and [listen] an element, or if it
  /// [listen] multiple times to an element, that element may be visited multiple times.
  void visitAncestors(void Function(ProviderElementBase element) visitor) {
    _dependencies.keys.forEach(visitor);

    for (var i = 0; i < _listenedProviderSubscriptions.length; i++) {
      visitor(_listenedProviderSubscriptions[i].listenedElement);
    }
  }

  /// Release the resources associated to this [ProviderElementBase].
  ///
  /// This will be invoked when:
  /// - the provider is using `autoDispose` and it is no-longer used.
  /// - the associated [ProviderContainer] is disposed
  ///
  /// On the other hand, this life-cycle will not be executed when a provider
  /// rebuilds.
  ///
  /// As opposed to [runOnDispose], this life-cycle is executed only
  /// for the lifetime of this element.
  @protected
  @mustCallSuper
  void dispose() {
    assert(
      () {
        RiverpodBinding.debugInstance
            .providerListChangedFor(containerId: container._debugId);
        return true;
      }(),
      '',
    );

    runOnDispose();

    // TODO test invalidateSelf() then dispose() properly unlinks dependencies
    // TODO test [listen] calls are cleared

    for (final sub in _dependencies.entries) {
      sub.key._providerDependents.remove(this);
      sub.key._onRemoveListener();
    }
    _dependencies.clear();

    _externalDependents.clear();
  }

  void _onListen() {
    _onAddListeners?.forEach(runGuarded);
    if (_didCancelOnce && !hasListeners) {
      _onResumeListeners?.forEach(runGuarded);
    }
  }

  void _onRemoveListener() {
    _onRemoveListeners?.forEach(runGuarded);
    if (!hasListeners) {
      _didCancelOnce = true;
      _onCancelListeners?.forEach(runGuarded);
    }
    mayNeedDispose();
  }

  /// Life-cycle for when a listener is removed.
  ///
  /// See also:
  ///
  /// - [AutoDisposeProviderElementMixin], which overrides this method to destroy the
  ///   state of a provider when no longer used.
  @protected
  @visibleForOverriding
  void mayNeedDispose() {}

  @override
  @mustCallSuper
  void onDispose(void Function() listener) {
    _assertNotOutdated();
    if (!_mounted) {
      throw StateError('Cannot call onDispose after a provider was dispose');
    }
    _onDisposeListeners ??= [];
    _onDisposeListeners!.add(listener);
  }

  /// Executes the [Ref.onDispose] listeners previously registered, then clear
  /// the list of listeners.
  @protected
  @visibleForOverriding
  @mustCallSuper
  void runOnDispose() {
    if (!_mounted) return;
    _mounted = false;

    while (_listenedProviderSubscriptions.isNotEmpty) {
      _listenedProviderSubscriptions.first.close();
    }

    _onDisposeListeners?.forEach(runGuarded);

    for (final observer in _container._observers) {
      runBinaryGuarded(
        observer.didDisposeProvider,
        _origin,
        _container,
      );
    }

    _onDisposeListeners = null;
    _onCancelListeners = null;
    _onResumeListeners = null;
    _onAddListeners = null;
    _onRemoveListeners = null;
    _onChangeSelfListeners = null;
    _onErrorSelfListeners = null;
    _didCancelOnce = false;
  }

  @override
  void onAddListener(void Function() cb) {
    _onAddListeners ??= [];
    _onAddListeners!.add(cb);
  }

  @override
  void onRemoveListener(void Function() cb) {
    _onRemoveListeners ??= [];
    _onRemoveListeners!.add(cb);
  }

  @override
  void onCancel(void Function() cb) {
    _onCancelListeners ??= [];
    _onCancelListeners!.add(cb);
  }

  @override
  void onResume(void Function() cb) {
    _onResumeListeners ??= [];
    _onResumeListeners!.add(cb);
  }

  @override
  String toString() {
    return '$runtimeType(provider: $provider, origin: $origin)';
  }
}
