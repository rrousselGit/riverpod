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
@internal
@optionalTypeArgs
abstract class ProviderElement<StateT> implements WrappedNode {
  /// {@macro riverpod.provider_element_base}
  ProviderElement(this.pointer);

  static ProviderElement? _debugCurrentlyBuildingElement;

  /// The last result of [ProviderBase.debugGetCreateSourceHash].
  ///
  /// Available only in debug mode.
  String? _debugCurrentCreateHash;
  var _debugSkipNotifyListenersAsserts = false;

  /// The provider associated with this [ProviderElement], before applying overrides.
  // Not typed as <State> because of https://github.com/rrousselGit/riverpod/issues/1100
  ProviderBase<Object?> get origin => pointer.origin;

  /// The provider associated with this [ProviderElement], after applying overrides.
  ProviderBase<StateT> get provider;

  /// The [$ProviderPointer] associated with this [ProviderElement].
  final $ProviderPointer pointer;

  /// The [ProviderContainer] that owns this [ProviderElement].
  ProviderContainer get container => pointer.targetContainer;

  Ref<StateT>? ref;

  /// Whether this [ProviderElement] is actively in use.
  ///
  /// A provider is considered not used if:
  /// - it has no listeners
  /// - all of its listeners are "weak" (i.e. created with `listen(weak: true)`)
  ///
  /// See also [_mayNeedDispose], called when [isActive] may have changed.
  bool get isActive =>
      (_dependents?.isNotEmpty ?? false) || _watchDependents.isNotEmpty;

  /// Whether this [ProviderElement] is currently listened to or not.
  ///
  /// This maps to listeners added with `listen` and `watch`,
  /// excluding `listen(weak: true)`.
  bool get hasListeners =>
      (_dependents?.isNotEmpty ?? false) ||
      _watchDependents.isNotEmpty ||
      _weakDependents.isNotEmpty;

  var _dependencies = HashMap<ProviderElement, Object>();
  HashMap<ProviderElement, Object>? _previousDependencies;
  List<ProviderSubscription>? _subscriptions;
  List<ProviderSubscription>? _dependents;

  /// "listen(weak: true)" pointing to this provider.
  ///
  /// Those subscriptions are separate from [ProviderElement._dependents] for a few reasons:
  /// - They do not count towards [ProviderElement.isActive].
  /// - They may be reused between two instances of a [ProviderElement].
  // TODO keep the pointer alive until all weak dependents are disposed
  final _weakDependents = <ProviderSubscription>[];

  /// The element of the providers that depends on this provider.
  final _watchDependents = <ProviderElement>[];

  bool _mustRecomputeState = false;
  bool _dependencyMayHaveChanged = false;
  bool _didChangeDependency = false;

  var _didCancelOnce = false;

  /// Whether the assert that prevents [requireState] from returning
  /// if the state was not set before is enabled.
  @visibleForOverriding
  bool get debugAssertDidSetStateEnabled => true;

  bool _debugDidSetState = false;
  bool _didBuild = false;
  var _didMount = false;

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

    return switch (state) {
      ResultError() => throwErrorWithCombinedStackTrace(
          state.error,
          state.stackTrace,
        ),
      ResultData() => state.state,
    };
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
      invalidateSelf(asReload: false);
    }
  }

  /// Called the first time a provider is obtained.
  void _mount() {
    if (kDebugMode) {
      _debugCurrentCreateHash = provider.debugGetCreateSourceHash();
    }

    final ref = this.ref = Ref<StateT>._(this);
    buildState(ref);

    // TODO refactor to use notifyListeners();
    switch (_stateResult!) {
      case final ResultData<StateT> newState:
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

        final listeners = _weakDependents.toList(growable: false);
        for (var i = 0; i < listeners.length; i++) {
          final listener = listeners[i];
          if (listener is _ProviderStateSubscription) {
            Zone.current.runBinaryGuarded(
              listener.listener,
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

      case final ResultError<StateT> newState:
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
    }
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
    assert(
      _previousDependencies == null,
      'Bad state: _performBuild was called twice',
    );
    final previousDependencies = _previousDependencies = _dependencies;
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
    for (final sub in previousDependencies.entries) {
      sub.key
        .._watchDependents.remove(this)
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
    if (!_didMount) {
      _didMount = true;
      _mount();
    }

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
      (element) => element.flush(),
    );
  }

  /// Invokes [create] and handles errors.
  @internal
  void buildState(Ref<StateT> ref) {
    ProviderElement? debugPreviouslyBuildingElement;
    final previousDidChangeDependency = _didChangeDependency;
    _didChangeDependency = false;
    if (kDebugMode) {
      debugPreviouslyBuildingElement = _debugCurrentlyBuildingElement;
      _debugCurrentlyBuildingElement = this;
    }

    _didBuild = false;
    try {
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

  void invalidateSelf({required bool asReload}) {
    if (asReload) _didChangeDependency = true;
    if (_mustRecomputeState) return;

    _mustRecomputeState = true;
    runOnDispose();
    _mayNeedDispose();
    container.scheduler.scheduleProviderRefresh(this);

    // We don't call this._markDependencyMayHaveChanged here because we voluntarily
    // do not want to set the _dependencyMayHaveChanged flag to true.
    // Since the dependency is known to have changed, there is no reason to try
    // and "flush" it, as it will already get rebuilt.
    visitChildren(
      elementVisitor: (element) => element._markDependencyMayHaveChanged(),
      listenableVisitor: (notifier) =>
          notifier.notifyDependencyMayHaveChanged(),
    );
  }

  void _notifyListeners(
    Result<StateT> newState,
    Result<StateT>? previousStateResult, {
    bool checkUpdateShouldNotify = true,
  }) {
    if (kDebugMode) _debugAssertNotificationAllowed();

    final previousState = previousStateResult?.stateOrNull;

    // listenSelf listeners do not respect updateShouldNotify
    switch (newState) {
      case final ResultData<StateT> newState:
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
      case final ResultError<StateT> newState:
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
    }

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

    final listeners = [..._weakDependents, ...?_dependents];
    switch (newState) {
      case final ResultData<StateT> newState:
        for (var i = 0; i < listeners.length; i++) {
          final listener = listeners[i];
          if (listener is _ProviderStateSubscription) {
            Zone.current.runBinaryGuarded(
              listener.listener,
              previousState,
              newState.state,
            );
          }
        }
      case final ResultError<StateT> newState:
        for (var i = 0; i < listeners.length; i++) {
          final listener = listeners[i];
          if (listener is _ProviderStateSubscription<StateT>) {
            Zone.current.runBinaryGuarded(
              listener.onError,
              newState.error,
              newState.stackTrace,
            );
          }
        }
      default:
    }

    for (var i = 0; i < _watchDependents.length; i++) {
      _watchDependents[i].invalidateSelf(asReload: true);
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
      if (newState is ResultError<StateT>) {
        runQuaternaryGuarded(
          observer.providerDidFail,
          origin,
          newState.error,
          newState.stackTrace,
          container,
        );
      }
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
  ProviderElement<T> readProviderElement<T>(ProviderBase<T> provider) {
    return container.readProviderElement(provider);
  }

  @override
  ProviderSubscription<T> listen<T>(
    ProviderListenable<T> listenable,
    void Function(T? previous, T value) listener, {
    bool weak = false,
    void Function(Object error, StackTrace stackTrace)? onError,
    bool fireImmediately = false,
    // Not part of the public "Ref" API
    void Function()? onDependencyMayHaveChanged,
  }) {
    final ref = this.ref!;
    ref._throwIfInvalidUsage();

    final result = listenable.addListener(
      // TODO assert weak listeners are removed on dispose
      weak ? WeakNode(this) : this,
      listener,
      fireImmediately: fireImmediately,
      onError: onError,
      onDependencyMayHaveChanged: onDependencyMayHaveChanged,
    );

    if (kDebugMode) ref._debugAssertCanDependOn(listenable);

    return result;
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

      if (!isActive && (links == null || links.isEmpty)) {
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

    final subscriptions = _subscriptions;
    if (subscriptions != null) {
      while (subscriptions.isNotEmpty) {
        late int debugPreviousLength;
        if (kDebugMode) {
          debugPreviousLength = subscriptions.length;
        }

        final sub = subscriptions.first;
        sub.close();

        if (kDebugMode) {
          assert(
            subscriptions.length < debugPreviousLength,
            'ProviderSubscription.close did not remove the subscription',
          );
        }
      }
    }

    ref._onDisposeListeners?.forEach(runGuarded);

    for (final observer in container.observers) {
      runBinaryGuarded(observer.didDisposeProvider, origin, container);
    }

    ref._keepAliveLinks = null;
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

  /// Release the resources associated to this [ProviderElement].
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

    for (final sub in _dependencies.entries) {
      sub.key._watchDependents.remove(this);
      sub.key._onRemoveListener();
    }
    _dependencies.clear();
  }

  @override
  String toString() {
    final buffer = StringBuffer('$runtimeType(');

    buffer.writeAll(
      [
        switch (_stateResult) {
          null => 'state: uninitialized',
          ResultData<StateT>(:final state) => 'state: $state',
          ResultError<StateT>(:final error, :final stackTrace) =>
            'state: error $error\n$stackTrace',
        },
        if (provider != origin) 'provider: $provider',
        'origin: $origin',
      ],
      ', ',
    );

    buffer.write(')');

    return buffer.toString();
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
    required void Function(ProviderElement element) elementVisitor,
    required void Function(ProxyElementValueListenable element)
        listenableVisitor,
  }) {
    for (var i = 0; i < _watchDependents.length; i++) {
      elementVisitor(_watchDependents[i]);
    }

    Iterable<ProviderSubscription> children = _weakDependents;
    if (_dependents case final dependents?) {
      children = children.followedBy(dependents);
    }

    for (final child in children) {
      switch (child.source) {
        case final ProviderElement dependent:
        case WeakNode(inner: final ProviderElement dependent):
          elementVisitor(dependent);
        case _:
          break;
      }
    }
  }

  /// Visit the [ProviderElement]s that this provider is listening to.
  ///
  /// A provider is considered as listening to this element if it either [Ref.watch]
  /// or [Ref.listen] this element.
  ///
  /// This method does not guarantee that a provider is visited only once.
  /// If this provider both [Ref.watch] and [Ref.listen] an element, or if it
  /// [Ref.listen] multiple times to an element, that element may be visited multiple times.
  void visitAncestors(
    void Function(ProviderElement element) visitor,
  ) {
    _dependencies.keys.forEach(visitor);

    final subscriptions = _subscriptions;
    if (subscriptions != null) {
      for (var i = 0; i < subscriptions.length; i++) {
        final sub = subscriptions[i];
        if (sub is _ProviderStateSubscription) {
          visitor(sub.listenedElement);
        }
      }
    }
  }
}
