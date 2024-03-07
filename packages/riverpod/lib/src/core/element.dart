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
sealed class Refreshable<StateT> implements ProviderListenable<StateT> {}

mixin _ProviderRefreshable<StateT> implements Refreshable<StateT> {
  ProviderBase<Object?> get provider;
}

/// A debug utility used by `flutter_riverpod`/`hooks_riverpod` to check
/// if it is safe to modify a provider.
///
/// This corresponds to all the widgets that a [Provider] is associated with.
@internal
void Function()? debugCanModifyProviders;

/// {@template riverpod.provider_element_base}
/// An internal class that handles the state of a provider.
///
/// This is what keeps track of the state of a provider, and notifies listeners
/// when the state changes. It is also responsible for rebuilding the provider
/// when one of its dependencies changes.
///
/// This class is not meant to be used directly and is an implementation detail
/// of providers.
/// Do not use.
/// {@endtemplate}
// TODO rename to ProviderElement
@internal
abstract class ProviderElementBase<StateT> implements Node {
  /// {@macro riverpod.provider_element_base}
  // TODO changelog: ProviderElement no-longer takes a provider as parameter but takes a ProviderContainer
  ProviderElementBase(this.container);

  static ProviderElementBase<Object?>? _debugCurrentlyBuildingElement;

  /// The last result of [ProviderBase.debugGetCreateSourceHash].
  ///
  /// Available only in debug mode.
  String? _debugCurrentCreateHash;
  var _debugSkipNotifyListenersAsserts = false;

  /// The provider associated with this [ProviderElementBase], before applying overrides.
  // Not typed as <State> because of https://github.com/rrousselGit/riverpod/issues/1100
  ProviderBase<Object?> get origin => _origin;
  late final ProviderBase<Object?> _origin;

  /// The provider associated with this [ProviderElementBase], after applying overrides.
  // TODO changelog ProviderElement.provider is now abstract
  ProviderBase<StateT> get provider;

  /// The [ProviderContainer] that owns this [ProviderElementBase].
  final ProviderContainer container;

  Ref<StateT>? ref;

  /// Whether this [ProviderElementBase] is currently listened to or not.
  ///
  /// This maps to listeners added with [Ref.listen].
  /// See also [_mayNeedDispose], called when [hasListeners] may have changed.
  bool get hasListeners =>
      _externalDependents.isNotEmpty ||
      _subscribers.isNotEmpty ||
      _providerDependents.isNotEmpty;

  /// The list of [ProviderSubscription]s that are linked with this element,
  /// which aren't coming from another provider.
  ///
  /// This is typically Flutter widgets or manual calls to [ProviderContainer.listen]
  /// with this provider as target.
  // TODO(rrousselGit) refactor to match ChangeNotifier
  final _externalDependents = <_ExternalProviderSubscription<StateT>>[];

  /// The [ProviderSubscription]s associated to the providers that this
  /// [ProviderElementBase] listens to.
  ///
  /// This list is typically updated when this provider calls [Ref.listen] on
  /// another provider.
  final _listenedProviderSubscriptions = <_ProviderListener<Object?>>[];

  /// The element of the providers that depends on this provider.
  final _providerDependents = <ProviderElementBase<Object?>>[];

  /// The subscriptions associated to other providers listening to this provider.
  ///
  /// Storing [_ProviderListener] instead of the raw [ProviderElementBase] as
  /// a provider can listen multiple times to another provider with different listeners.
  final _subscribers = <_ProviderListener<Object?>>[];

  var _dependencies = HashMap<ProviderElementBase<Object?>, Object>();
  HashMap<ProviderElementBase<Object?>, Object>? _previousDependencies;

  bool _mustRecomputeState = false;
  bool _dependencyMayHaveChanged = false;
  bool _didChangeDependency = false;

  var _didCancelOnce = false;

  bool _mounted = false;

  /// Whether the element was disposed or not
  @internal
  bool get mounted => _mounted;

  /// Whether the assert that prevents [requireState] from returning
  /// if the state was not set before is enabled.
  @visibleForOverriding
  bool get debugAssertDidSetStateEnabled => true;

  bool _debugDidSetState = false;
  bool _didBuild = false;

  /* STATE */
  Result<StateT>? _stateResult;

  /// The current state of the provider.
  ///

  /// Obtains the current state, or null if the provider has yet to initialize.
  ///
  /// The returned object will contain error information, if any.
  /// This function does not cause the provider to rebuild if it somehow was
  /// outdated.
  ///
  /// This is not meant for public consumption. Instead, public API should use
  /// [readSelf].
  @internal
  Result<StateT>? get stateResult => _stateResult;

  /// Returns the currently exposed by a provider
  ///
  /// May throw if the provider threw when creating the exposed value.
  StateT readSelf() {
    flush();

    return requireState;
  }

  /// Update the exposed value of a provider and notify its listeners.
  ///
  /// Listeners will only be notified if [updateShouldNotify]
  /// returns true.
  ///
  /// This API is not meant for public consumption. Instead if a [Ref] needs
  /// to expose a way to update the state, the practice is to expose a getter/setter.
  @internal
  void setStateResult(Result<StateT> newState) {
    if (kDebugMode) _debugDidSetState = true;

    final previousResult = stateResult;
    final result = _stateResult = newState;

    if (_didBuild) {
      _notifyListeners(result, previousResult);
    }
  }

  /// Read the current value of a provider and:
  ///
  /// - if in error state, rethrow the error
  /// - if the provider is not initialized, gracefully handle the error.
  ///
  /// This is not meant for public consumption. Instead, public API should use
  /// [readSelf].
  @internal
  StateT get requireState {
    const uninitializedError = '''
Tried to read the state of an uninitialized provider.
This could mean a few things:
- You have a circular dependency, and your provider end-up depending on itself.
- You read "ref.state", but no value was set beforehand.
''';

    if (kDebugMode) {
      if (debugAssertDidSetStateEnabled && !_debugDidSetState) {
        throw StateError(uninitializedError);
      }
    }

    final state = stateResult;
    if (state == null) throw StateError(uninitializedError);

    return state.when(
      error: throwErrorWithCombinedStackTrace,
      data: (data) => data,
    );
  }

  /// Called when a provider is rebuilt. Used for providers to not notify their
  /// listeners if the exposed value did not change.
  @internal
  bool updateShouldNotify(StateT previous, StateT next);

  /* /STATE */

  /// A life-cycle executed when a hot-reload is performed.
  ///
  /// This is equivalent to Flutter's `State.reassemble`.
  ///
  /// This life-cycle is used to check for change in [ProviderBase.debugGetCreateSourceHash],
  /// and invalidate the provider state on change.
  void debugReassemble() {
    final previousHash = _debugCurrentCreateHash;
    _debugCurrentCreateHash = provider.debugGetCreateSourceHash();

    if (previousHash != _debugCurrentCreateHash) {
      ref?.invalidateSelf();
    }
  }

  /// Called the first time a provider is obtained.
  @internal
  void mount() {
    _mounted = true;
    if (kDebugMode) {
      _debugCurrentCreateHash = provider.debugGetCreateSourceHash();
    }

    final ref = this.ref = Ref<StateT>._(this);
    buildState(ref);

    _stateResult!.map(
      data: (newState) {
        final onChangeSelfListeners = ref._onChangeSelfListeners;
        if (onChangeSelfListeners != null) {
          for (var i = 0; i < onChangeSelfListeners.length; i++) {
            Zone.current.runBinaryGuarded(
              onChangeSelfListeners[i],
              null,
              newState.state,
            );
          }
        }

        for (final observer in container.observers) {
          runTernaryGuarded(
            observer.didAddProvider,
            origin,
            newState.state,
            container,
          );
        }
      },
      error: (newState) {
        final onErrorSelfListeners = ref._onErrorSelfListeners;
        if (onErrorSelfListeners != null) {
          for (var i = 0; i < onErrorSelfListeners.length; i++) {
            Zone.current.runBinaryGuarded(
              onErrorSelfListeners[i],
              newState.error,
              newState.stackTrace,
            );
          }
        }

        for (final observer in container.observers) {
          runTernaryGuarded(
            observer.didAddProvider,
            origin,
            null,
            container,
          );
        }
        for (final observer in container.observers) {
          runQuaternaryGuarded(
            observer.providerDidFail,
            origin,
            newState.error,
            newState.stackTrace,
            container,
          );
        }
      },
    );
  }

  /// Called when the override of a provider changes.
  ///
  /// See also:
  /// - `overrideWithValue`, which relies on [update] to handle
  ///   the scenario where the value changed.
  @visibleForOverriding
  void update(ProviderBase<StateT> newProvider) {}

  /// Initialize a provider and track dependencies used during the initialization.
  ///
  /// After a provider is initialized, this function takes care of unsubscribing
  /// to dependencies that are no-longer used.
  void _performBuild() {
    _previousDependencies = _dependencies;
    _dependencies = HashMap();

    runOnDispose();
    final ref = this.ref = Ref<StateT>._(this);
    final previousStateResult = _stateResult;

    if (kDebugMode) _debugDidSetState = false;

    buildState(ref);

    if (!identical(_stateResult, previousStateResult)) {
      // Asserts would otherwise prevent a provider rebuild from updating
      // other providers
      if (kDebugMode) _debugSkipNotifyListenersAsserts = true;

      _notifyListeners(_stateResult!, previousStateResult);

      if (kDebugMode) _debugSkipNotifyListenersAsserts = false;
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
  /// This function **must** call [setStateResult] or throw (or both).
  ///
  /// Exceptions within this function will be caught and set the provider in error
  /// state. Then, reading this provider will rethrow the thrown exception.
  ///
  /// - [didChangeDependency] can be used to differentiate a rebuild caused
  ///   by [Ref.watch] from one caused by [Ref.refresh]/[Ref.invalidate].
  @visibleForOverriding
  void create(Ref<StateT> ref, {required bool didChangeDependency});

  /// A utility for re-initializing a provider when needed.
  ///
  /// Calling [flush] will only re-initialize the provider if it needs to rerun.
  /// This can involve:
  /// - a previous call to [Ref.invalidateSelf]
  /// - a dependency of the provider has changed (such as when using [Ref.watch]).
  ///
  /// This is not meant for public consumption. Public API should hide
  /// [flush] from users, such that they don't need to care about invoking this function.
  @internal
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

  /// Invokes [create] and handles errors.
  @internal
  void buildState(Ref<StateT> ref) {
    ProviderElementBase<Object?>? debugPreviouslyBuildingElement;
    final previousDidChangeDependency = _didChangeDependency;
    _didChangeDependency = false;
    if (kDebugMode) {
      debugPreviouslyBuildingElement = _debugCurrentlyBuildingElement;
      _debugCurrentlyBuildingElement = this;
    }

    _didBuild = false;
    try {
      // TODO move outside this function?
      _mounted = true;
      create(ref, didChangeDependency: previousDidChangeDependency);
    } catch (err, stack) {
      if (kDebugMode) _debugDidSetState = true;

      _stateResult = Result.error(err, stack);
    } finally {
      _didBuild = true;
      if (kDebugMode) {
        _debugCurrentlyBuildingElement = debugPreviouslyBuildingElement;
      }

      assert(
        stateResult != null,
        'Bad state, the provider did not initialize. Did "create" forget to set the state?',
      );
    }
  }

  void _debugAssertNotificationAllowed() {
    if (_debugSkipNotifyListenersAsserts) return;

    assert(
      _debugCurrentlyBuildingElement == null ||
          _debugCurrentlyBuildingElement == this,
      '''
Providers are not allowed to modify other providers during their initialization.

The provider ${_debugCurrentlyBuildingElement!.origin} modified $origin while building.
''',
    );

    debugCanModifyProviders?.call();
  }

  void _notifyListeners(
    Result<StateT> newState,
    Result<StateT>? previousStateResult, {
    bool checkUpdateShouldNotify = true,
  }) {
    if (kDebugMode) _debugAssertNotificationAllowed();

    final previousState = previousStateResult?.stateOrNull;

    // listenSelf listeners do not respect updateShouldNotify
    newState.map(
      data: (newState) {
        final onChangeSelfListeners = ref?._onChangeSelfListeners;
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
        final onErrorSelfListeners = ref?._onErrorSelfListeners;
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

    if (checkUpdateShouldNotify &&
        previousStateResult != null &&
        previousStateResult.hasState &&
        newState.hasState &&
        !updateShouldNotify(
          previousState as StateT,
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
      _providerDependents[i].ref?.invalidateSelf(asReload: true);
    }

    for (final observer in container.observers) {
      runQuaternaryGuarded(
        observer.didUpdateProvider,
        origin,
        previousState,
        newState.stateOrNull,
        container,
      );
    }

    for (final observer in container.observers) {
      newState.map(
        data: (_) {},
        error: (newState) {
          runQuaternaryGuarded(
            observer.providerDidFail,
            origin,
            newState.error,
            newState.stackTrace,
            container,
          );
        },
      );
    }
  }

  void _markDependencyMayHaveChanged() {
    if (_dependencyMayHaveChanged) return;

    _dependencyMayHaveChanged = true;

    visitChildren(
      elementVisitor: (element) => element._markDependencyMayHaveChanged(),
      listenableVisitor: (notifier) =>
          notifier.notifyDependencyMayHaveChanged(),
    );
  }

  @override
  ProviderElementBase<T> readProviderElement<T>(ProviderBase<T> provider) {
    return container.readProviderElement(provider);
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
    ref?._assertNotOutdated();
    assert(!_debugIsRunningSelector, 'Cannot call ref.read inside a selector');
    if (kDebugMode) ref?._debugAssertCanDependOn(listenable);

    return listenable.addListener(
      this,
      listener,
      fireImmediately: fireImmediately,
      onError: onError,
      onDependencyMayHaveChanged: onDependencyMayHaveChanged,
    );
  }

  void _onListen() {
    ref?._onAddListeners?.forEach(runGuarded);
    if (_didCancelOnce && !hasListeners) {
      ref?._onResumeListeners?.forEach(runGuarded);
    }
  }

  void _onRemoveListener() {
    ref?._onRemoveListeners?.forEach(runGuarded);
    if (!hasListeners) {
      _didCancelOnce = true;
      ref?._onCancelListeners?.forEach(runGuarded);
    }
    _mayNeedDispose();
  }

  /// Life-cycle for when a listener is removed.
  void _mayNeedDispose() {
    if (provider.isAutoDispose) {
      final links = ref?._keepAliveLinks;

      if (!hasListeners && (links == null || links.isEmpty)) {
        container.scheduler.scheduleProviderDispose(this);
      }
    }
  }

  /// Executes the [Ref.onDispose] listeners previously registered, then clear
  /// the list of listeners.
  @protected
  @visibleForOverriding
  @mustCallSuper
  void runOnDispose() {
    final ref = this.ref;
    if (ref == null || !ref._mounted) return;

    ref._mounted = false;
    ref._keepAliveLinks?.clear();

    while (_listenedProviderSubscriptions.isNotEmpty) {
      _listenedProviderSubscriptions.first.close();
    }

    ref._onDisposeListeners?.forEach(runGuarded);

    for (final observer in container.observers) {
      runBinaryGuarded(
        observer.didDisposeProvider,
        _origin,
        container,
      );
    }

    ref._onDisposeListeners = null;
    ref._onCancelListeners = null;
    ref._onResumeListeners = null;
    ref._onAddListeners = null;
    ref._onRemoveListeners = null;
    ref._onChangeSelfListeners = null;
    ref._onErrorSelfListeners = null;
    _didCancelOnce = false;

    assert(
      ref._keepAliveLinks == null || ref._keepAliveLinks!.isEmpty,
      'Cannot call keepAlive() within onDispose listeners',
    );
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
    runOnDispose();
    ref = null;

    // TODO test invalidateSelf() then dispose() properly unlinks dependencies
    // TODO test [Ref.listen] calls are cleared

    for (final sub in _dependencies.entries) {
      sub.key._providerDependents.remove(this);
      sub.key._onRemoveListener();
    }
    _dependencies.clear();

    _externalDependents.clear();
  }

  @override
  String toString() {
    return '$runtimeType(provider: $provider, origin: $origin)';
  }

  /// Visit the [$ProviderElement]s of providers that are listening to this element.
  ///
  /// A provider is considered as listening to this element if it either [Ref.watch]
  /// or [Ref.listen] this element.
  ///
  /// This method does not guarantee that a dependency is visited only once.
  /// If a provider both [Ref.watch] and [Ref.listen] an element, or if a provider
  /// [Ref.listen] multiple times to an element, it may be visited multiple times.
  void visitChildren({
    required void Function(ProviderElementBase<Object?> element) elementVisitor,
    required void Function(ProxyElementValueListenable<Object?> element)
        listenableVisitor,
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
  /// A provider is considered as listening to this element if it either [Ref.watch]
  /// or [Ref.listen] this element.
  ///
  /// This method does not guarantee that a provider is visited only once.
  /// If this provider both [Ref.watch] and [Ref.listen] an element, or if it
  /// [Ref.listen] multiple times to an element, that element may be visited multiple times.
  void visitAncestors(
    void Function(ProviderElementBase<Object?> element) visitor,
  ) {
    _dependencies.keys.forEach(visitor);

    for (var i = 0; i < _listenedProviderSubscriptions.length; i++) {
      visitor(_listenedProviderSubscriptions[i].listenedElement);
    }
  }
}
