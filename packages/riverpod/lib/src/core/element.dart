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

mixin _ProviderRefreshable<OutT, OriginT>
    implements Refreshable<OutT>, ProviderListenableWithOrigin<OutT, OriginT> {
  ProviderBase<OriginT> get provider;
}

/// A debug utility used by `flutter_riverpod`/`hooks_riverpod` to check
/// if it is safe to modify a provider.
///
/// This corresponds to all the widgets that a [Provider] is associated with.
@internal
void Function()? debugCanModifyProviders;

@internal
typedef WhenComplete = void Function(void Function() cb)?;

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
abstract class ProviderElement<StateT> implements Node {
  /// {@macro riverpod.provider_element_base}
  ProviderElement(this.pointer);

  static Duration? _defaultRetry(int retryCount, Object error) {
    return Duration(
      milliseconds: math.min(200 * math.pow(2, retryCount).toInt(), 6400),
    );
  }

  static ProviderElement? _debugCurrentlyBuildingElement;

  /// The last result of [ProviderBase.debugGetCreateSourceHash].
  ///
  /// Available only in debug mode.
  String? _debugCurrentCreateHash;
  var _debugSkipNotifyListenersAsserts = false;

  /// The provider associated with this [ProviderElement], before applying overrides.
  ProviderBase<StateT> get origin => pointer.origin as ProviderBase<StateT>;

  /// The provider associated with this [ProviderElement], after applying overrides.
  ProviderBase<StateT> get provider;

  /// The [$ProviderPointer] associated with this [ProviderElement].
  final $ProviderPointer pointer;

  /// The [ProviderContainer] that owns this [ProviderElement].
  ProviderContainer get container => pointer.targetContainer;

  // ignore: library_private_types_in_public_api, not public
  $Ref<StateT>? ref;

  /// Whether this [ProviderElement] is actively in use.
  ///
  /// A provider is considered not used if:
  /// - it has no listeners
  /// - all of its listeners are "weak" (i.e. created with `listen(weak: true)`)
  ///
  /// See also [mayNeedDispose], called when [isActive] may have changed.
  bool get isActive => (_listenerCount - _pausedActiveSubscriptionCount) > 0;

  int get _listenerCount => dependents?.length ?? 0;

  var _pausedActiveSubscriptionCount = 0;
  var _didCancelOnce = false;

  /// Whether this [ProviderElement] is currently listened to or not.
  ///
  /// This maps to listeners added with `listen` and `watch`,
  /// excluding `listen(weak: true)`.
  bool get hasNonWeakListeners => _listenerCount > 0;

  List<ProviderSubscriptionWithOrigin>? _inactiveSubscriptions;
  @visibleForTesting
  List<ProviderSubscriptionWithOrigin>? subscriptions;
  @visibleForTesting
  List<ProviderSubscriptionWithOrigin>? dependents;

  /// "listen(weak: true)" pointing to this provider.
  ///
  /// Those subscriptions are separate from [ProviderElement.dependents] for a few reasons:
  /// - They do not count towards [ProviderElement.isActive].
  /// - They may be reused between two instances of a [ProviderElement].
  @visibleForTesting
  final weakDependents = <ProviderSubscriptionImpl>[];

  bool _mustRecomputeState = false;
  bool _dependencyMayHaveChanged = false;
  bool _didChangeDependency = false;

  var _retryCount = 0;
  Timer? _pendingRetryTimer;

  /// Whether the assert that prevents [requireState] from returning
  /// if the state was not set before is enabled.
  @visibleForOverriding
  bool get debugAssertDidSetStateEnabled => true;

  bool _debugDidSetState = false;
  bool _didBuild = false;
  var _didMount = false;

  /* STATE */
  $Result<StateT>? _stateResult;

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
  $Result<StateT>? get stateResult => _stateResult;

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
  void setStateResult($Result<StateT> newState) {
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
  void mount() {
    if (kDebugMode) {
      _debugCurrentCreateHash = provider.debugGetCreateSourceHash();
    }

    final ref = this.ref = $Ref(this);
    buildState(ref, isFirstBuild: true);

    _notifyListeners(
      _stateResult!,
      null,
      isFirstBuild: true,
      checkUpdateShouldNotify: false,
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
  void _performRebuild() {
    runOnDispose();
    final ref = this.ref = $Ref(this);
    final previousStateResult = _stateResult;

    if (kDebugMode) _debugDidSetState = false;

    visitListenables((listenable) {
      listenable.lockNotification();
    });

    buildState(ref, isFirstBuild: false);

    visitListenables((listenable) {
      listenable.unlockNotification();
    });

    if (!identical(_stateResult, previousStateResult)) {
      // Asserts would otherwise prevent a provider rebuild from updating
      // other providers
      if (kDebugMode) _debugSkipNotifyListenersAsserts = true;

      _notifyListeners(_stateResult!, previousStateResult);

      if (kDebugMode) _debugSkipNotifyListenersAsserts = false;
    }
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
  WhenComplete create(
    // ignore: library_private_types_in_public_api, not public
    $Ref<StateT> ref, {
    required bool didChangeDependency,
    required bool isFirstBuild,
  });

  /// A utility for re-initializing a provider when needed.
  ///
  /// Calling [flush] will only re-initialize the provider if it needs to rerun.
  /// This can involve:
  /// - a previous call to [Ref.invalidateSelf]
  /// - a dependency of the provider has changed (such as when using [Ref.watch]).
  ///
  /// This is not meant for public consumption. Public API should hide
  /// [flush] from users, such that they don't need to care about invoking this function.
  void flush() {
    if (!_didMount) {
      _didMount = true;
      mount();
    }

    _maybeRebuildDependencies();
    if (_mustRecomputeState) {
      _mustRecomputeState = false;
      _performRebuild();
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

  // Hook for async provider to init state with AsyncLoading
  void initState({required bool didChangeDependency}) {}

  /// Invokes [create] and handles errors.
  @internal
  void buildState(
    // ignore: library_private_types_in_public_api, not public
    $Ref<StateT> ref, {
    required bool isFirstBuild,
  }) {
    if (_didChangeDependency) _retryCount = 0;

    ProviderElement? debugPreviouslyBuildingElement;
    final previousDidChangeDependency = _didChangeDependency;
    _didChangeDependency = false;
    if (kDebugMode) {
      debugPreviouslyBuildingElement = _debugCurrentlyBuildingElement;
      _debugCurrentlyBuildingElement = this;
    }

    _didBuild = false;
    initState(didChangeDependency: previousDidChangeDependency);
    try {
      final whenComplete = create(
            ref,
            didChangeDependency: previousDidChangeDependency,
            isFirstBuild: isFirstBuild,
          ) ??
          (cb) => cb();

      whenComplete(_didCompleteInitialization);
    } catch (err, stack) {
      if (kDebugMode) _debugDidSetState = true;

      _stateResult = $Result.error(err, stack);
      triggerRetry(err);
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

  @protected
  void triggerRetry(Object error) {
    // Don't start retry if the provider was disposed
    if (ref == null) return;

    final retry = origin.retry ?? container.retry ?? _defaultRetry;

    // Capture exceptions. On error, stop retrying if the retry
    // function failed
    runGuarded(() {
      final duration = retry(_retryCount, error);
      if (duration == null) return;

      _pendingRetryTimer = Timer(duration, () {
        _pendingRetryTimer = null;
        _retryCount++;
        invalidateSelf(asReload: false);
      });
    });
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
    mayNeedDispose();
    container.scheduler.scheduleProviderRefresh(this);

    // We don't call this._markDependencyMayHaveChanged here because we voluntarily
    // do not want to set the _dependencyMayHaveChanged flag to true.
    // Since the dependency is known to have changed, there is no reason to try
    // and "flush" it, as it will already get rebuilt.
    visitChildren((element) {
      element._markDependencyMayHaveChanged();
      element.visitListenables(
        (notifier) => notifier.notifyDependencyMayHaveChanged(),
      );
    });
    visitListenables((notifier) => notifier.notifyDependencyMayHaveChanged());
  }

  MutationContext? _currentMutationContext() =>
      Zone.current[mutationZoneKey] as MutationContext?;

  ProviderObserverContext _currentObserverContext() {
    return ProviderObserverContext(
      origin,
      container,
      mutation: _currentMutationContext(),
    );
  }

  void _notifyListeners(
    $Result<StateT> newState,
    $Result<StateT>? previousStateResult, {
    bool checkUpdateShouldNotify = true,
    bool isFirstBuild = false,
  }) {
    if (kDebugMode && !isFirstBuild) _debugAssertNotificationAllowed();

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

    final listeners = [...weakDependents, if (!isFirstBuild) ...?dependents];
    switch (newState) {
      case final ResultData<StateT> newState:
        for (var i = 0; i < listeners.length; i++) {
          final listener = listeners[i];
          if (listener.closed) continue;

          Zone.current.runBinaryGuarded(
            listener._onOriginData,
            previousState,
            newState.state,
          );
        }
      case final ResultError<StateT> newState:
        for (var i = 0; i < listeners.length; i++) {
          final listener = listeners[i];
          if (listener.closed) continue;

          Zone.current.runBinaryGuarded(
            listener._onOriginError,
            newState.error,
            newState.stackTrace,
          );
        }
    }

    for (final observer in container.observers) {
      if (isFirstBuild) {
        runBinaryGuarded(
          observer.didAddProvider,
          _currentObserverContext(),
          newState.stateOrNull,
        );
      } else {
        runTernaryGuarded(
          observer.didUpdateProvider,
          _currentObserverContext(),
          previousState,
          newState.stateOrNull,
        );
      }
    }

    for (final observer in container.observers) {
      if (newState is ResultError<StateT>) {
        runTernaryGuarded(
          observer.providerDidFail,
          _currentObserverContext(),
          newState.error,
          newState.stackTrace,
        );
      }
    }
  }

  void _markDependencyMayHaveChanged() {
    if (_dependencyMayHaveChanged) return;

    _dependencyMayHaveChanged = true;

    visitChildren(
      (element) {
        element._markDependencyMayHaveChanged();
        element.visitListenables(
          (notifier) => notifier.notifyDependencyMayHaveChanged(),
        );
      },
    );
    visitListenables((notifier) => notifier.notifyDependencyMayHaveChanged());
  }

  @override
  ProviderElement<T> readProviderElement<T>(ProviderBase<T> provider) {
    return container.readProviderElement(provider);
  }

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

    final sub = listenable.addListener(
      this,
      listener,
      fireImmediately: fireImmediately,
      onError: onError,
      weak: weak,
      onDependencyMayHaveChanged: onDependencyMayHaveChanged,
    );

    switch (sub) {
      case final ProviderSubscriptionImpl<Object?, Object?> sub:
        sub._listenedElement.addDependentSubscription(sub);
    }

    if (kDebugMode) ref._debugAssertCanDependOn(listenable);

    return sub;
  }

  void onCancel() {
    subscriptions?.forEach((sub) {
      switch (sub) {
        case ProviderSubscriptionImpl():
          sub._listenedElement.onSubscriptionPause(sub);
      }
    });
  }

  void onResume() {
    subscriptions?.forEach((sub) {
      switch (sub) {
        case ProviderSubscriptionImpl():
          sub._listenedElement.onSubscriptionResume(sub);
      }
    });
  }

  void addDependentSubscription(ProviderSubscriptionImpl sub) {
    _onChangeSubscription(sub, () {
      if (sub.weak) {
        weakDependents.add(sub);
      } else {
        final dependents = this.dependents ??= [];
        dependents.add(sub);
      }

      if (sub.source case final ProviderElement element) {
        final subs = element.subscriptions ??= [];
        subs.add(sub);
      }
    });
  }

  void removeDependentSubscription(ProviderSubscription sub) {
    _onChangeSubscription(sub, () {
      // If the subscription is paused, internally resume it to decrement any
      // associated state.
      // We don't want to call onResume though.
      _notifyResumeListeners = false;
      while (sub.isPaused) {
        sub.resume();
      }
      _notifyResumeListeners = true;

      if (sub.weak) {
        weakDependents.remove(sub);
      } else {
        dependents?.remove(sub);
      }

      if (sub.source case final ProviderElement element) {
        element.subscriptions?.remove(sub);
      }
    });
  }

  var _notifyResumeListeners = true;
  void _onChangeSubscription(ProviderSubscription sub, void Function() apply) {
    final wasActive = isActive;
    final previousListenerCount = _listenerCount;
    apply();

    switch ((wasActive: wasActive, isActive: isActive)) {
      case (wasActive: false, isActive: true) when _didCancelOnce:
        if (_notifyResumeListeners) {
          ref?._onResumeListeners?.forEach(runGuarded);
        }
        onResume();

      case (wasActive: true, isActive: false):
        _didCancelOnce = true;
        ref?._onCancelListeners?.forEach(runGuarded);
        onCancel();

      default:
      // No state change, so do nothing
    }

    if (_listenerCount < previousListenerCount) {
      if (ref?._onRemoveListeners case final listeners?) {
        listeners.forEach(runGuarded);
      }
      mayNeedDispose();
    } else if (_listenerCount > previousListenerCount) {
      if (ref?._onAddListeners case final listeners?) {
        listeners.forEach(runGuarded);
      }
    }
  }

  void onSubscriptionPause(ProviderSubscription sub) {
    // Weak listeners are not counted towards isActive, so we don't want to change
    // _pausedActiveSubscriptionCount
    if (sub.weak) return;

    _onChangeSubscription(sub, () => _pausedActiveSubscriptionCount++);
  }

  void onSubscriptionResume(ProviderSubscription sub) {
    // Weak listeners are not counted towards isActive, so we don't want to change
    // _pausedActiveSubscriptionCount
    if (sub.weak) return;

    _onChangeSubscription(sub, () {
      _pausedActiveSubscriptionCount = math.max(
        0,
        _pausedActiveSubscriptionCount - 1,
      );
    });
  }

  /// A life-cycle called by subclasses of [ProviderElement] when
  /// their provider's `build` method completes.
  void _didCompleteInitialization() {
    // Close inactive subscriptions
    if (_inactiveSubscriptions case final subs?) {
      _closeSubscriptions(subs);
      _inactiveSubscriptions = null;
    }
  }

  /// Life-cycle for when a listener is removed.
  void mayNeedDispose() {
    if (provider.isAutoDispose) {
      final links = ref?._keepAliveLinks;

      if (!isActive && (links == null || links.isEmpty)) {
        container.scheduler.scheduleProviderDispose(this);
      }
    }
  }

  void _closeSubscriptions(List<ProviderSubscription> subscriptions) {
    final subs = subscriptions.toList();
    for (var i = 0; i < subs.length; i++) {
      subs[i].close();
    }
  }

  void _pauseSubscriptions(List<ProviderSubscription> subscriptions) {
    for (var i = 0; i < subscriptions.length; i++) {
      subscriptions[i].pause();
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

    _pendingRetryTimer?.cancel();
    _pendingRetryTimer = null;

    // Pause current subscriptions and queue them to be deleted upon the completion
    // of the next rebuild.
    if (subscriptions case final subs?) {
      (_inactiveSubscriptions ??= []).addAll(subs);
      _pauseSubscriptions(subs);
    }
    subscriptions = null;

    ref._onDisposeListeners?.forEach(runGuarded);

    for (final observer in container.observers) {
      runUnaryGuarded(observer.didDisposeProvider, _currentObserverContext());
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

  /// Clears the state of a [ProviderElement].
  ///
  /// This is in-between [dispose] and [runOnDispose].
  /// It is used to clear the state of a provider, without unsubscribing
  /// [weakDependents].
  @mustCallSuper
  void clearState() {
    runOnDispose();
    _didMount = false;
    _stateResult = null;
    ref = null;

    if (dependents case final subs?) {
      _closeSubscriptions(subs);
      dependents = null;
    }
    if (_inactiveSubscriptions case final subs?) {
      _closeSubscriptions(subs);
      _inactiveSubscriptions = null;
    }
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
  /// As opposed to [runOnDispose], this life-cycle is executed only once
  /// for the lifetime of this element.
  @protected
  @mustCallSuper
  void dispose() {
    clearState();

    _closeSubscriptions(weakDependents);

    visitListenables((notifier) {
      notifier.dispose();
    });
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
  void visitChildren(
    void Function(ProviderElement element) elementVisitor,
  ) {
    void lookup(Iterable<ProviderSubscriptionWithOrigin> children) {
      for (final child in children) {
        switch (child.source) {
          case final ProviderElement dependent:
            elementVisitor(dependent);
          case ProviderContainer():
            break;
        }
      }
    }

    lookup(weakDependents);
    if (dependents case final dependents?) lookup(dependents);
  }

  void visitListenables(
    void Function($ElementLense element) listenableVisitor,
  ) {}

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
    final subscriptions = this.subscriptions;
    if (subscriptions != null) {
      for (var i = 0; i < subscriptions.length; i++) {
        final sub = subscriptions[i];
        visitor(sub._listenedElement);
      }
    }
  }
}
