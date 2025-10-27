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
@publicInMisc
sealed class Refreshable<StateT> implements ProviderListenable<StateT> {}

base mixin _ProviderRefreshable<OutT, InT> implements Refreshable<OutT> {
  $ProviderBaseImpl<InT> get provider;
}

/// A debug utility used by `flutter_riverpod`/`hooks_riverpod` to check
/// if it is safe to modify a provider.
///
/// This corresponds to all the widgets that a [Provider] is associated with.
@internal
void Function()? debugCanModifyProviders;

/// A Future-like that support synchronous completion.
@internal
typedef WhenComplete = void Function(void Function() cb)?;

/// Mixin to help implement logic for listening to [Future]s/[Stream]s and setup
/// `provider.future` + convert the object into an [AsyncValue].
@internal
mixin ElementWithFuture<StateT, ValueT> on ProviderElement<StateT, ValueT> {
  /// An observable for [FutureProvider.future].
  @internal
  final futureNotifier = $Observable<Future<ValueT>>();
  Completer<ValueT>? _futureCompleter;
  Future<ValueT>? _lastFuture;
  AsyncSubscription? _cancelSubscription;

  @override
  void initState(Ref ref) {
    onLoading(AsyncLoading<ValueT>(), seamless: !ref.isReload);
  }

  /// Internal utility for transitioning an [AsyncValue] after a provider refresh.
  ///
  /// [seamless] controls how the previous state is preserved:
  /// - seamless:true => import previous state and skip loading
  /// - seamless:false => import previous state and prefer loading
  void asyncTransition(AsyncValue<ValueT> newState, {required bool seamless}) {
    final previous = value;

    if (newState._isMultiState) {
      super.value = newState;
      return;
    }

    super.value = newState.cast<ValueT>().copyWithPrevious(
      previous,
      isRefresh: seamless,
    );
  }

  @override
  @protected
  set value(AsyncValue<ValueT> newState) {
    newState.map(loading: onLoading, error: onError, data: onData);
  }

  @internal
  void onLoading(AsyncLoading<ValueT> value, {bool seamless = false}) {
    asyncTransition(value, seamless: seamless);
    if (_futureCompleter == null) {
      final completer = _futureCompleter = Completer();
      futureNotifier.result = $ResultData(completer.future);
    }
  }

  void onValue(AsyncValue<ValueT> value, {bool seamless = false}) {
    switch (value) {
      case AsyncLoading():
        onLoading(value, seamless: seamless);
      case AsyncData():
        onData(value, seamless: seamless);
      case AsyncError():
        onError(value, seamless: seamless);
    }
  }

  /// Life-cycle for when an error from the provider's "build" method is received.
  ///
  /// Might be invoked after the element is disposed in the case where `provider.future`
  /// has yet to complete.
  @internal
  void onError(AsyncError<ValueT> value, {bool seamless = false}) {
    asyncTransition(value, seamless: seamless);

    final result = resultForValue(value);
    if (result is! $ResultError<StateT> && !origin._isSynthetic) {
      // Hard error states are already reported to the observers
      for (final observer in container.observers) {
        container.runTernaryGuarded(
          observer.providerDidFail,
          _currentObserverContext(),
          value.error,
          value.stackTrace,
        );
      }
    }

    final completer = _futureCompleter;
    if (completer != null) {
      completer
        ..future.ignore()
        ..completeError(value.error, value.stackTrace);
      _futureCompleter = null;
    } else {
      futureNotifier.result = $Result.data(
        Future.error(value.error, value.stackTrace)..ignore(),
      );
    }
  }

  /// Life-cycle for when a data from the provider's "build" method is received.
  ///
  /// Might be invoked after the element is disposed in the case where `provider.future`
  /// has yet to complete.
  @internal
  void onData(AsyncData<ValueT> value, {bool seamless = false}) {
    asyncTransition(value, seamless: seamless);

    final completer = _futureCompleter;
    if (completer != null) {
      completer.complete(value.value);
      _futureCompleter = null;
    } else {
      futureNotifier.result = $Result.data(Future.value(value.value));
    }
  }

  /// Listens to a [Stream] and convert it into an [AsyncValue].
  @preferInline
  @internal
  WhenComplete handleStream(Ref ref, Stream<ValueT> Function() create) {
    return _handleAsync(ref, ({
      required data,
      required done,
      required error,
      required last,
    }) {
      final stream = create();

      late StreamSubscription<ValueT> subscription;
      subscription = stream.listen(data, onError: error, onDone: done);

      final asyncSub = (
        cancel: subscription.cancel,
        pause: subscription.pause,
        resume: subscription.resume,
        abort: subscription.cancel,
      );

      return asyncSub;
    });
  }

  @override
  void onCancel() {
    super.onCancel();

    _cancelSubscription?.pause?.call();
  }

  @override
  void onResume() {
    super.onResume();

    _cancelSubscription?.resume?.call();
  }

  StateError _missingLastValueError() {
    return StateError(
      'The provider $origin was disposed during loading state, '
      'yet no value could be emitted.',
    );
  }

  /// Listens to a [Future] and convert it into an [AsyncValue].
  @preferInline
  @internal
  WhenComplete handleFuture(Ref ref, FutureOr<ValueT> Function() create) {
    return _handleAsync(ref, ({
      required data,
      required done,
      required error,
      required last,
    }) {
      final futureOr = create();
      if (futureOr is! Future<ValueT>) {
        data(futureOr);
        done();
        return null;
      }
      // Received a Future<T>

      var running = true;
      void cancel() {
        running = false;
      }

      futureOr.then(
        (value) {
          if (!running) return;
          data(value);
          done();
        },
        // ignore: avoid_types_on_closure_parameters
        onError: (Object err, StackTrace stackTrace) {
          if (!running) return;
          error(err, stackTrace);
          done();
        },
      );

      last(futureOr);

      return (
        cancel: cancel,
        // We don't call `cancel` here to let `provider.future` resolve with
        // the last value emitted by the future.
        abort: null,
        pause: null,
        resume: null,
      );
    });
  }

  /// Listens to a [Future] and transforms it into an [AsyncValue].
  WhenComplete _handleAsync(
    Ref ref,
    AsyncSubscription? Function({
      required void Function(ValueT) data,
      required void Function(Object, StackTrace) error,
      required void Function() done,
      required void Function(Future<ValueT>) last,
    })
    listen,
  ) {
    void callOnError(Object error, StackTrace stackTrace) {
      onValue(triggerRetry(error, stackTrace), seamless: !ref.isReload);
    }

    void Function()? onDone;
    var isDone = false;

    try {
      _cancelSubscription = listen(
        data: (value) {
          onData(AsyncData(value), seamless: !ref.isReload);
        },
        error: callOnError,
        last: (last) {
          assert(_lastFuture == null, 'bad state');
          _lastFuture = last;
        },
        done: () {
          _lastFuture = null;
          isDone = true;
          onDone?.call();
        },
      );
    } catch (error, stackTrace) {
      callOnError(error, stackTrace);
    }

    return (onDoneCb) {
      onDone = onDoneCb;
      // Handle synchronous completion
      if (isDone) onDoneCb();
    };
  }

  @override
  @internal
  void runOnDispose() {
    // Stops listening to the previous async operation
    _lastFuture = null;
    _cancelSubscription?.cancel();
    _cancelSubscription = null;
    super.runOnDispose();
  }

  @override
  void dispose() {
    final completer = _futureCompleter;
    if (completer != null) {
      // Whatever happens after this, the error is emitted post dispose of the provider.
      // So the error doesn't matter anymore.
      completer.future.ignore();

      final lastFuture = _lastFuture;
      if (lastFuture != null) {
        _cancelSubscription?.abort?.call();

        // Prevent super.dispose from cancelling the subscription on the "last"
        // stream value, so that it can be sent to `provider.future`.
        _lastFuture = null;
        _cancelSubscription = null;
      } else {
        // The listened stream completed during a "loading" state.
        completer.completeError(_missingLastValueError(), StackTrace.current);
      }
    }
    super.dispose();
  }

  @override
  void visitListenables(void Function($Observable element) listenableVisitor) {
    super.visitListenables(listenableVisitor);
    listenableVisitor(futureNotifier);
  }
}

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
@publicInCodegen
abstract class ProviderElement<StateT, ValueT> implements Node {
  /// {@macro riverpod.provider_element_base}
  ProviderElement(this.pointer);

  static bool defaultUpdateShouldNotify(Object? previous, Object? next) {
    return previous != next;
  }

  static ProviderElement? _debugCurrentlyBuildingElement;

  ProviderContainer get container => pointer.targetContainer;

  /// The last result of [ProviderBase.debugGetCreateSourceHash].
  ///
  /// Available only in debug mode.
  String? _debugCurrentCreateHash;
  var _debugSkipNotifyListenersAsserts = false;

  /// The provider associated with this [ProviderElement], before applying overrides.
  $ProviderBaseImpl<StateT> get origin =>
      pointer.origin as $ProviderBaseImpl<StateT>;

  /// The provider associated with this [ProviderElement], after applying overrides.
  $ProviderBaseImpl<StateT> get provider;

  /// The [$ProviderPointer] associated with this [ProviderElement].
  final $ProviderPointer pointer;

  bool unsafeCheckIfMounted = true;
  // ignore: library_private_types_in_public_api, not public
  $Ref<StateT, ValueT>? ref;

  /// Whether this [ProviderElement] is actively in use.
  ///
  /// A provider is considered not used if:
  /// - it has no listeners
  /// - all of its listeners are "weak" (i.e. created with `listen(weak: true)`)
  ///
  /// See also [mayNeedDispose], called when [isActive] may have changed.
  bool get isActive => (listenerCount - pausedActiveSubscriptionCount) > 0;

  int get listenerCount => dependents?.length ?? 0;

  int pausedActiveSubscriptionCount = 0;
  var _didCancelOnce = false;

  /// Whether this [ProviderElement] is currently listened to or not.
  ///
  /// This maps to listeners added with `listen` and `watch`,
  /// excluding `listen(weak: true)`.
  bool get hasNonWeakListeners => listenerCount > 0;

  List<ProviderSubscription>? _inactiveSubscriptions;
  @visibleForTesting
  List<ProviderSubscription>? subscriptions;

  @visibleForTesting
  List<ProviderSubscriptionImpl<Object?>>? dependents;

  /// "listen(weak: true)" pointing to this provider.
  ///
  /// Those subscriptions are separate from [ProviderElement.dependents] for a few reasons:
  /// - They do not count towards [ProviderElement.isActive].
  /// - They may be reused between two instances of a [ProviderElement].
  @visibleForTesting
  final weakDependents = <ProviderSubscriptionImpl<Object?>>[];

  bool _mustRecomputeState = false;
  bool _dependencyMayHaveChanged = false;
  bool _didChangeDependency = false;

  var _retryCount = 0;
  Timer? _pendingRetryTimer;

  /// Whether the assert that prevents [readSelf] from returning
  /// if the state was not set before is enabled.
  @visibleForOverriding
  bool get debugAssertDidSetStateEnabled => true;

  bool _debugDidSetState = false;
  bool _didBuild = false;
  var _didMount = false;

  /* STATE */
  var _value = AsyncValue<ValueT>.loading();
  AsyncValue<ValueT> get value => _value;
  set value(AsyncValue<ValueT> value) {
    if (kDebugMode) _debugDidSetState = true;

    final previousResult = this.value;
    final result = _value = value;

    if (_didBuild) {
      _notifyListeners(result, previousResult);
    }
  }

  $Result<StateT>? stateResult() => resultForValue(value);

  void setValueFromState(StateT state);

  $Result<StateT>? resultForValue(AsyncValue<ValueT> value);

  /// Returns the currently exposed by a provider
  ///
  /// May throw if the provider threw when creating the exposed value.
  $Result<StateT> readSelf() {
    flush();

    final state = resultForValue(value);

    const uninitializedError = '''
Tried to read the state of an uninitialized provider.
This generally means that have a circular dependency, and your provider end-up
depending on itself.
''';

    if (kDebugMode) {
      if (debugAssertDidSetStateEnabled && !_debugDidSetState) {
        return $Result.error(
          StateError(uninitializedError),
          StackTrace.current,
        );
      }
    }

    if (state == null) {
      return $ResultError(StateError(uninitializedError), StackTrace.current);
    }

    return state;
  }

  /// Called when a provider is rebuilt. Used for providers to not notify their
  /// listeners if the exposed value did not change.
  bool updateShouldNotify(StateT previous, StateT next) =>
      defaultUpdateShouldNotify(previous, next);

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

    final ref = this.ref = $Ref(this, isFirstBuild: true, isReload: false);
    final initialState = value;

    ProviderElement? debugPreviouslyBuildingElement;
    if (kDebugMode) {
      debugPreviouslyBuildingElement = _debugCurrentlyBuildingElement;
      _debugCurrentlyBuildingElement = this;
    }

    try {
      buildState(ref);

      if (kDebugMode) _debugCurrentlyBuildingElement = null;

      _notifyListeners(
        value,
        initialState,
        isFirstBuild: true,
        checkUpdateShouldNotify: false,
      );
    } finally {
      if (kDebugMode) {
        _debugCurrentlyBuildingElement = debugPreviouslyBuildingElement;
      }
    }
  }

  /// Called when the override of a provider changes.
  ///
  /// See also:
  /// - `overrideWithValue`, which relies on [update] to handle
  ///   the scenario where the value changed.
  @visibleForOverriding
  void update($ProviderBaseImpl<StateT> newProvider) {}

  /// Initialize a provider and track dependencies used during the initialization.
  ///
  /// After a provider is initialized, this function takes care of unsubscribing
  /// to dependencies that are no-longer used.
  void _performRebuild() {
    runOnDispose();
    final ref =
        this.ref = $Ref(
          this,
          isFirstBuild: false,
          isReload: _didChangeDependency,
        );
    final previousValue = value;

    if (kDebugMode) _debugDidSetState = false;

    visitListenables((listenable) {
      listenable.lockNotification();
    });

    ProviderElement? debugPreviouslyBuildingElement;
    if (kDebugMode) {
      debugPreviouslyBuildingElement = _debugCurrentlyBuildingElement;
      _debugCurrentlyBuildingElement = this;
    }
    try {
      buildState(ref);

      visitListenables((listenable) {
        listenable.unlockNotification();
      });

      if (!identical(value, previousValue)) {
        // Asserts would otherwise prevent a provider rebuild from updating
        // other providers
        if (kDebugMode) {
          _debugSkipNotifyListenersAsserts = true;
          _debugCurrentlyBuildingElement = null;
        }

        _notifyListeners(value, previousValue);

        if (kDebugMode) {
          _debugSkipNotifyListenersAsserts = false;
          _debugCurrentlyBuildingElement = null;
        }
      }
    } finally {
      if (kDebugMode) {
        _debugCurrentlyBuildingElement = debugPreviouslyBuildingElement;
      }
    }
  }

  /// Initialize a provider.
  ///
  /// This function **must** call [value=] or throw (or both).
  ///
  /// Exceptions within this function will be caught and set the provider in error
  /// state. Then, reading this provider will rethrow the thrown exception.
  @visibleForOverriding
  WhenComplete create(
    // ignore: library_private_types_in_public_api, not public
    $Ref<StateT, ValueT> ref,
  );

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

    visitAncestors((element) => element.flush());
  }

  // Hook for async provider to init state with AsyncLoading
  void initState(Ref ref) {}

  /// Invokes [create] and handles errors.
  @internal
  void buildState(
    // ignore: library_private_types_in_public_api, not public
    $Ref<StateT, ValueT> ref,
  ) {
    if (_didChangeDependency) _retryCount = 0;

    if (kDebugMode) {
      container.scheduler.debugNotifyDidBuild(this);

      assert(
        _debugCurrentlyBuildingElement == this,
        'Bad state, expected $this, got $_debugCurrentlyBuildingElement',
      );
    }

    _didBuild = false;
    initState(ref);
    try {
      final whenComplete = create(ref) ?? (cb) => cb();

      whenComplete(_didCompleteInitialization);
    } catch (err, stack) {
      if (kDebugMode) _debugDidSetState = true;

      value = triggerRetry(err, stack);
    } finally {
      _didBuild = true;
    }
  }

  @protected
  @useResult
  AsyncValue<ValueT> triggerRetry(Object error, StackTrace stackTrace) {
    var retrying = false;

    // Don't start retry if the provider was disposed
    if (!_disposed) {
      final retry =
          origin.retry ?? container.retry ?? ProviderContainer.defaultRetry;

      // Capture exceptions. On error, stop retrying if the retry
      // function failed
      container.runGuarded(() {
        final duration = retry(_retryCount, error);
        if (duration == null) return;

        retrying = true;
        _pendingRetryTimer = Timer(duration, () {
          _pendingRetryTimer = null;
          _retryCount++;
          invalidateSelf(asReload: false);
        });
      });
    }

    if (retrying) {
      return AsyncLoading<ValueT>._(
        value._loading ?? (progress: 0),
        value: value._value,
        error: (err: error, stack: stackTrace, retrying: true),
      );
    }

    return AsyncError(error, stackTrace, retrying: false);
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

  Mutation<Object?>? _currentMutationContext() =>
      Zone.current[mutationZoneKey] as Mutation<Object?>?;

  ProviderObserverContext _currentObserverContext() {
    return ProviderObserverContext(
      origin,
      container,
      this,
      mutation: _currentMutationContext(),
    );
  }

  void _notifyListeners(
    AsyncValue<ValueT> newStateValue,
    AsyncValue<ValueT>? previousStateValue, {
    bool checkUpdateShouldNotify = true,
    bool isFirstBuild = false,
  }) {
    if (kDebugMode && !isFirstBuild) _debugAssertNotificationAllowed();

    final newState = resultForValue(newStateValue)!;
    final previousStateResult =
        previousStateValue != null ? resultForValue(previousStateValue) : null;

    final previousState = previousStateResult?.value;

    // listenSelf listeners do not respect updateShouldNotify
    switch (newState) {
      case final $ResultData<StateT> newState:
        final onChangeSelfListeners = ref?._onChangeSelfListeners;
        if (onChangeSelfListeners != null) {
          for (var i = 0; i < onChangeSelfListeners.length; i++) {
            container.runBinaryGuarded(
              onChangeSelfListeners[i],
              previousState,
              newState.value,
            );
          }
        }
      case final $ResultError<StateT> newState:
        final onErrorSelfListeners = ref?._onErrorSelfListeners;
        if (onErrorSelfListeners != null) {
          for (var i = 0; i < onErrorSelfListeners.length; i++) {
            container.runBinaryGuarded(
              onErrorSelfListeners[i],
              newState.error,
              newState.stackTrace,
            );
          }
        }
    }

    if (checkUpdateShouldNotify) {
      switch ((previousStateResult, newState)) {
        case ((null, _)):
        case (($ResultError(), _)):
        case ((_, $ResultError())):
          break;
        case (($ResultData() && final prev, $ResultData() && final next)):
          if (!updateShouldNotify(prev.value, next.value)) return;
      }
    }

    final listeners = [...weakDependents, if (!isFirstBuild) ...?dependents];
    switch (newState) {
      case final $ResultData<StateT> newState:
        for (var i = 0; i < listeners.length; i++) {
          final listener = listeners[i];
          if (listener.closed) continue;

          container.runBinaryGuarded(
            listener.providerSub._notifyData,
            previousState,
            newState.value,
          );
        }
      case final $ResultError<StateT> newState:
        for (var i = 0; i < listeners.length; i++) {
          final listener = listeners[i];
          if (listener.closed) continue;

          container.runBinaryGuarded(
            listener.providerSub._notifyError,
            newState.error,
            newState.stackTrace,
          );
        }
    }

    if (!origin._isSynthetic) {
      for (final observer in container.observers) {
        if (isFirstBuild) {
          container.runBinaryGuarded(
            observer.didAddProvider,
            _currentObserverContext(),
            newState.value,
          );
        } else {
          container.runTernaryGuarded(
            observer.didUpdateProvider,
            _currentObserverContext(),
            previousState,
            newState.value,
          );
        }
      }

      for (final observer in container.observers) {
        if (newState is $ResultError<StateT>) {
          container.runTernaryGuarded(
            observer.providerDidFail,
            _currentObserverContext(),
            newState.error,
            newState.stackTrace,
          );
        }
      }
    }
  }

  void _markDependencyMayHaveChanged() {
    if (_dependencyMayHaveChanged) return;

    _dependencyMayHaveChanged = true;

    visitChildren((element) {
      element._markDependencyMayHaveChanged();
      element.visitListenables(
        (notifier) => notifier.notifyDependencyMayHaveChanged(),
      );
    });
    visitListenables((notifier) => notifier.notifyDependencyMayHaveChanged());
  }

  ProviderSubscription<ListenedStateT> listen<ListenedStateT>(
    ProviderListenable<ListenedStateT> listenable,
    void Function(ListenedStateT? previous, ListenedStateT value) listener, {
    bool weak = false,
    void Function(Object error, StackTrace stackTrace)? onError,
    bool fireImmediately = false,
    // Not part of the public "Ref" API
    void Function()? onDependencyMayHaveChanged,
  }) {
    assert(
      !fireImmediately || !weak,
      'Cannot use fireImmediately with weak listeners',
    );

    final ref = this.ref!;
    ref._throwIfInvalidUsage();

    final sub = listenable._addListener(
      this,
      listener,
      onError: onError ?? container.defaultOnError,
      weak: weak,
      onDependencyMayHaveChanged: onDependencyMayHaveChanged,
    );

    _handleFireImmediately(container, sub, fireImmediately: fireImmediately);

    sub.impl._listenedElement.addDependentSubscription(sub.impl);

    if (kDebugMode) ref._debugAssertCanDependOn(listenable);

    return sub;
  }

  void onCancel() {
    subscriptions?.forEach((sub) {
      sub.impl.deactivate();
    });
  }

  void onResume() {
    subscriptions?.forEach((sub) {
      sub.impl.reactivate();
    });
  }

  void addDependentSubscription(ProviderSubscriptionImpl<Object?> sub) {
    assert(
      !sub.isPaused && sub.impl.active,
      'Expected subscription to be active and not paused',
    );

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

  void removeDependentSubscription(
    ProviderSubscription sub,
    void Function() apply,
  ) {
    _assertContainsDependent(sub);

    _onChangeSubscription(sub, () {
      apply();
      // If the subscription is an indirect one, so we don't count it towards
      // pausedActiveSubscriptionCount, otherwise one listener would count twice.
      if (!sub.weak &&
          !sub.impl.$hasParent &&
          (sub.isPaused || !sub.impl.active)) {
        pausedActiveSubscriptionCount = math.max(
          0,
          pausedActiveSubscriptionCount - 1,
        );
      }

      if (sub.weak) {
        weakDependents.remove(sub);
      } else {
        dependents?.remove(sub);
      }

      if (sub.impl.source case final ProviderElement element) {
        element
          ..subscriptions?.remove(sub)
          .._inactiveSubscriptions?.remove(sub);
      }
    });
  }

  void onSubscriptionPauseOrDeactivate(
    ProviderSubscription sub,
    void Function() apply,
  ) {
    _assertContainsDependent(sub);

    _onChangeSubscription(sub, () {
      final before = sub.impl.pausedOrDeactivated;
      apply();
      assert(
        sub.isPaused || !sub.impl.active,
        'Expected subscription to be paused/inactive',
      );
      final after = sub.impl.pausedOrDeactivated;

      // If the subscription is an indirect one, so we don't count it towards
      // pausedActiveSubscriptionCount, otherwise one listener would count twice.
      if (sub.impl.$hasParent) return;
      // Weak listeners are not counted towards isActive, so we don't want to change
      // pausedActiveSubscriptionCount
      if (sub.weak) return;
      if (before == after) return;
      pausedActiveSubscriptionCount++;
    });
  }

  void onSubscriptionResumeOrReactivate(
    ProviderSubscription sub,
    void Function() apply,
  ) {
    _assertContainsDependent(sub);

    _onChangeSubscription(sub, () {
      final before = sub.impl.pausedOrDeactivated;
      apply();
      assert(
        !sub.isPaused || sub.impl.active,
        'Expected subscription to be resumed/active',
      );
      final after = sub.impl.pausedOrDeactivated;

      // If the subscription is an indirect one, so we don't count it towards
      // pausedActiveSubscriptionCount, otherwise one listener would count twice.
      if (sub.impl.$hasParent) return;
      // Weak listeners are not counted towards isActive, so we don't want to change
      // pausedActiveSubscriptionCount
      if (sub.weak) return;
      if (before == after) return;

      pausedActiveSubscriptionCount = math.max(
        0,
        pausedActiveSubscriptionCount - 1,
      );
    });
  }

  void _assertValidInternalPauseState() {
    if (!kDebugMode) return;

    final closedSubs = [
      ...?subscriptions,
      ...?dependents,
      ...weakDependents,
      ...?_inactiveSubscriptions,
    ].where((e) => e.closed);
    if (closedSubs.isNotEmpty) {
      throw StateError(
        'Some leftover closed subscriptions were found.\n'
        'This is likely due to a bug in the provider implementation.\n$this',
      );
    }

    final actualPausedCount = pausedActiveSubscriptionCount;
    final expectedPausedCount =
        dependents
            ?.where((sub) => !sub.weak && (sub.isPaused || !sub.active))
            .length ??
        0;

    assert(
      actualPausedCount == expectedPausedCount,
      'Expected pausedActiveSubscriptionCount to be $expectedPausedCount, '
      'but was $actualPausedCount. '
      'This is likely due to a bug in the provider implementation.\n$this',
    );
  }

  void _assertContainsDependent(ProviderSubscription sub) {
    assert(
      sub.impl.$hasParent || [...weakDependents, ...?dependents].contains(sub),
      '''
Expected subscription to be part of this provider element, but it was not found.
Sub:
$sub
Element:
$this''',
    );
  }

  void _onChangeSubscription(ProviderSubscription sub, void Function() apply) {
    final wasActive = isActive;
    final previousListenerCount = listenerCount;
    _assertValidInternalPauseState();
    apply();
    _assertValidInternalPauseState();

    switch ((wasActive: wasActive, isActive: isActive)) {
      case (wasActive: false, isActive: true) when _didCancelOnce:
        _runCallbacks(container, ref?._onResumeListeners);
        onResume();

      case (wasActive: true, isActive: false):
        _didCancelOnce = true;
        _runCallbacks(container, ref?._onCancelListeners);
        onCancel();

      default:
      // No state change, so do nothing
    }

    if (listenerCount < previousListenerCount) {
      _runCallbacks(container, ref?._onRemoveListeners);
      mayNeedDispose();
    } else if (listenerCount > previousListenerCount) {
      _runCallbacks(container, ref?._onAddListeners);
    }
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

  /// Executes the [Ref.onDispose] listeners previously registered, then clear
  /// the list of listeners.
  @protected
  @visibleForOverriding
  @mustCallSuper
  void runOnDispose() {
    final ref = this.ref;
    if (ref == null) return;

    _pendingRetryTimer?.cancel();
    _pendingRetryTimer = null;

    // Pause current subscriptions and queue them to be deleted upon the completion
    // of the next rebuild.
    if (subscriptions case final subs?) {
      (_inactiveSubscriptions ??= []).addAll(subs);
      for (var i = 0; i < subs.length; i++) {
        subs[i].impl.pause();
      }
    }
    subscriptions = null;

    _runCallbacks(container, ref._onDisposeListeners);

    if (!origin._isSynthetic) {
      for (final observer in container.observers) {
        container.runUnaryGuarded(
          observer.didDisposeProvider,
          _currentObserverContext(),
        );
      }
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
    _value = AsyncLoading();

    if (dependents case final subs?) {
      _closeSubscriptions(subs);
      dependents = null;
    }
    if (_inactiveSubscriptions case final subs?) {
      _closeSubscriptions(subs);
      _inactiveSubscriptions = null;
    }
  }

  bool _disposed = false;

  late final ElementId _debugId = ElementId(const Uuid().v4());

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
    _disposed = true;
    clearState();

    _closeSubscriptions(weakDependents);

    visitListenables((notifier) {
      notifier.dispose();
    });

    if (kDebugMode) {
      RiverpodDevtool.instance.addEvent(ProviderElementDisposeEvent(this));
    }
  }

  @override
  String toString() {
    final buffer = StringBuffer('$runtimeType${shortHash(this)}(');

    final lines = [
      'origin: $origin',
      if (provider != origin) 'provider: $provider',
      'isActive: $isActive',
      'listenerCount: $listenerCount',
      'pausedActiveSubscriptionCount: $pausedActiveSubscriptionCount',
      'retryCount: $_retryCount',
      'weakDependents: $weakDependents',
      'dependents: $dependents',
      'inactiveSubscriptions: $_inactiveSubscriptions',
      'subscriptions: $subscriptions',
      switch (resultForValue(value)) {
        null => 'state: uninitialized',
        $ResultData<StateT>(:final value) => 'state: $value',
        $ResultError<StateT>(:final error, :final stackTrace) =>
          'state: error $error\n$stackTrace',
      },
    ];

    for (final line in lines) {
      buffer.write('\n${line.indent(1)}');
    }

    buffer.write('\n)');

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
  void visitChildren(void Function(ProviderElement element) elementVisitor) {
    void lookup(Iterable<ProviderSubscription<Object?>> children) {
      for (final child in children) {
        switch (child.impl.source) {
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

  void visitListenables(void Function($Observable element) listenableVisitor) {}

  /// Visit the [ProviderElement]s that this provider is listening to.
  ///
  /// A provider is considered as listening to this element if it either [Ref.watch]
  /// or [Ref.listen] this element.
  ///
  /// This method does not guarantee that a provider is visited only once.
  /// If this provider both [Ref.watch] and [Ref.listen] an element, or if it
  /// [Ref.listen] multiple times to an element, that element may be visited multiple times.
  void visitAncestors(void Function(ProviderElement element) visitor) {
    if (subscriptions case final subscriptions?) {
      for (var i = 0; i < subscriptions.length; i++) {
        final sub = subscriptions[i];

        visitor(sub.impl._listenedElement);
      }
    }
    if (_inactiveSubscriptions case final inactiveSubscriptions?) {
      for (var i = 0; i < inactiveSubscriptions.length; i++) {
        final sub = inactiveSubscriptions[i];

        visitor(sub.impl._listenedElement);
      }
    }
  }
}

void _closeSubscriptions(List<ProviderSubscription> subscriptions) {
  final subs = subscriptions.toList();
  for (var i = 0; i < subs.length; i++) {
    subs[i].close();
  }
}

@internal
mixin SyncProviderElement<ValueT> on ProviderElement<ValueT, ValueT> {
  @override
  $Result<ValueT>? resultForValue(AsyncValue<ValueT> value) {
    switch (value) {
      case AsyncData():
        return $ResultData(value.value);
      case AsyncLoading(:final error?, :final stackTrace?) when value.retrying:
      case AsyncError(:final error, :final stackTrace):
        return $ResultError(error, stackTrace);
      case AsyncLoading():
        return null;
    }
  }

  @override
  void setValueFromState(ValueT state) => value = AsyncData(state);
}
