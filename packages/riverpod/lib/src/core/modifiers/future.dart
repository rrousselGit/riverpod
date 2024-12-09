part of '../../framework.dart';

/// Internal typedef for cancelling the subscription to an async operation
@internal
typedef AsyncSubscription = ({
  /// The provider was disposed, but may rebuild later
  void Function() cancel,
  void Function()? pause,
  void Function()? resume,

  /// The provider was disposed
  void Function()? abort,
});

/// Implementation detail of `riverpod_generator`.
/// Do not use.
mixin $AsyncClassModifier<StateT, CreatedT>
    on NotifierBase<AsyncValue<StateT>, CreatedT> {
  /// The value currently exposed by this [AsyncNotifier].
  ///
  /// Defaults to [AsyncLoading] inside the [AsyncNotifier.build] method.
  ///
  /// Invoking the setter will notify listeners if [updateShouldNotify] returns true.
  /// By default, this always notifies listeners (unless going from "loading"
  /// to "loading", in which case the change is ignored).
  ///
  /// Reading [state] if the provider is out of date (such as if one of its
  /// dependency has changed) will trigger [AsyncNotifier.build] to be re-executed.
  @visibleForTesting
  @protected
  @override
  AsyncValue<StateT> get state;

  @visibleForTesting
  @protected
  @override
  set state(AsyncValue<StateT> newState);

  /// {@template riverpod.async_notifier.future}
  /// Obtains a [Future] that resolves with the first [state] value that is not
  /// [AsyncLoading].
  ///
  /// This future will not necessarily wait for [AsyncNotifier.build] to complete.
  /// If [state] is modified before [AsyncNotifier.build] completes, then [future]
  /// will resolve with that new [state] value.
  ///
  /// The future will fail if [state] is in error state. In which case the
  /// error will be the same as [AsyncValue.error] and its stacktrace.
  /// {@endtemplate}
  @visibleForTesting
  @protected
  Future<StateT> get future {
    final ref = _ref;
    if (ref == null) {
      throw StateError(uninitializedElementError);
    }

    ref._throwIfInvalidUsage();

    final element = ref._element;
    element as FutureModifierElement<StateT>;

    element.flush();
    return element.futureNotifier.value;
  }

  /// A function to update [state] from its previous value, while
  /// abstracting loading/error cases for [state].
  ///
  /// This method neither causes [state] to go back to "loading" while the
  /// operation is pending. Neither does it cause [state] to go to error state
  /// if the operation fails.
  ///
  /// If [state] was in error state, the callback will not be invoked and instead
  /// the error will be returned. Alternatively, [onError] can specified to
  /// gracefully handle error states.
  ///
  /// See also:
  /// - [future], for manually awaiting the resolution of [state].
  /// - [AsyncValue.guard], and alternate way to perform asynchronous operations.
  @visibleForTesting
  @protected
  Future<StateT> update(
    FutureOr<StateT> Function(StateT previousState) cb, {
    FutureOr<StateT> Function(Object err, StackTrace stackTrace)? onError,
  }) async {
    final newState = await future.then(cb, onError: onError);
    state = AsyncData<StateT>(newState);
    return newState;
  }

  /// A method invoked when the state exposed by this [AsyncNotifier] changes.
  ///
  /// As opposed to with [Notifier.updateShouldNotify], this method
  /// does not filter out changes to [state] that are equal to the previous
  /// value.
  /// By default, any change to [state] will emit an update.
  /// This method can be overridden to implement custom filtering logic if that
  /// is undesired.
  ///
  /// The reasoning for this default behavior is that [AsyncNotifier.build]
  /// returns a [Future]. As such, the value of [state] typically transitions
  /// from "loading" to "data" or "error". In that scenario, the value equality
  /// does not matter. Checking `==` would only hinder performances for no reason.
  ///
  /// See also:
  /// - [ProviderBase.select] and [$FutureModifier.selectAsync], which are
  ///   alternative ways to filter out changes to [state].
  @override
  @protected
  bool updateShouldNotify(
    AsyncValue<StateT> previous,
    AsyncValue<StateT> next,
  ) {
    return FutureModifierElement.handleUpdateShouldNotify(
      previous,
      next,
    );
  }
}

/// Implementation detail for `riverpod_generator`.
/// Do not use.
base mixin $FutureModifier<StateT> on ProviderBase<AsyncValue<StateT>> {
  /// Obtains the [Future] representing this provider.
  ///
  /// The instance of [Future] obtained may change over time. This typically
  /// happens when a new "data" or "error" is emitted, or when the provider
  /// re-enters a "loading" state.
  ///
  /// This modifier enables using `async`/`await` to easily combine
  /// providers together:
  ///
  /// ```dart
  /// final configsProvider = FutureProvider((ref) async => Configs());
  ///
  /// final productsProvider = FutureProvider((ref) async {
  ///   // Wait for the configurations to resolve
  ///   final configs = await ref.watch(configsProvider.future);
  ///
  ///   // Do something with the result
  ///   return await http.get('${configs.host}/products');
  /// });
  /// ```
  Refreshable<Future<StateT>> get future => _future;

  _ProviderRefreshable<Future<StateT>, AsyncValue<StateT>> get _future {
    return ProviderElementProxy<Future<StateT>, AsyncValue<StateT>>(
      this,
      (element) {
        element as FutureModifierElement<StateT>;

        return element.futureNotifier;
      },
    );
  }

  /// {@template riverpod.async_select}
  /// A variant of [select] for asynchronous values
  ///
  /// [selectAsync] is useful for filtering rebuilds of a provider
  /// when it depends on asynchronous values, which we want to await.
  ///
  /// A common use-case would be to combine [selectAsync] with
  /// [FutureProvider] to perform an async operation, where that
  /// async operation depends on the result of another async operation.
  ///
  ///
  /// ```dart
  /// // A provider which asynchronously loads configurations,
  /// // which may change over time.
  /// final configsProvider = StreamProvider<Config>((ref) async {
  ///   // TO-DO fetch the configurations, such as by using Firebase
  /// });
  ///
  /// // A provider which fetches a list of products based on the configurations
  /// final productsProvider = FutureProvider<List>((ref) async {
  ///   // We obtain the host from the configs, while ignoring changes to
  ///   // other properties. As such, the productsProvider will rebuild only
  ///   // if the host changes
  ///   final host = await ref.watch(configsProvider.selectAsync((config) => config.host));
  ///
  ///   return http.get('$host/products');
  /// });
  /// ```
  /// {@endtemplate}
  ProviderListenable<Future<Output>> selectAsync<Output>(
    Output Function(StateT data) selector,
  ) {
    return _AsyncSelector<StateT, Output, AsyncValue<StateT>>(
      selector: selector,
      provider: this,
      future: _future,
    );
  }
}

mixin FutureModifierClassElement<
        NotifierT extends NotifierBase< //
            AsyncValue<StateT>,
            CreatedT>,
        StateT,
        CreatedT>
    on
        FutureModifierElement<StateT>,
        ClassProviderElement<NotifierT, AsyncValue<StateT>, CreatedT> {
  @override
  void handleNotifier(Object? notifier, {required bool seamless}) {
    asyncTransition(AsyncLoading<StateT>(), seamless: seamless);
  }

  @override
  void handleError(
    Object error,
    StackTrace stackTrace, {
    required bool seamless,
  }) {
    triggerRetry(error);
    onError(AsyncError(error, stackTrace), seamless: seamless);
  }
}

/// Mixin to help implement logic for listening to [Future]s/[Stream]s and setup
/// `provider.future` + convert the object into an [AsyncValue].
@internal
mixin FutureModifierElement<StateT> on ProviderElement<AsyncValue<StateT>> {
  /// A default implementation for [ProviderElement.updateShouldNotify].
  static bool handleUpdateShouldNotify<StateT>(
    AsyncValue<StateT> previous,
    AsyncValue<StateT> next,
  ) {
    final wasLoading = previous.isLoading;
    final isLoading = next.isLoading;

    if (wasLoading || isLoading) return wasLoading != isLoading;

    return true;
  }

  /// An observable for [FutureProvider.future].
  @internal
  final futureNotifier = ProxyElementValueListenable<Future<StateT>>();
  Completer<StateT>? _futureCompleter;
  Future<StateT>? _lastFuture;
  AsyncSubscription? _cancelSubscription;

  /// Internal utility for transitioning an [AsyncValue] after a provider refresh.
  ///
  /// [seamless] controls how the previous state is preserved:
  /// - seamless:true => import previous state and skip loading
  /// - seamless:false => import previous state and prefer loading
  void asyncTransition(
    AsyncValue<StateT> newState, {
    required bool seamless,
  }) {
    final previous = stateResult?.requireState;

    if (previous == null) {
      super.setStateResult(ResultData(newState));
    } else {
      super.setStateResult(
        ResultData(
          newState
              .cast<StateT>()
              .copyWithPrevious(previous, isRefresh: seamless),
        ),
      );
    }
  }

  @override
  @protected
  void setStateResult(Result<AsyncValue<StateT>> newState) {
    newState.requireState.map(
      loading: onLoading,
      error: onError,
      data: onData,
    );
  }

  @internal
  void onLoading(AsyncLoading<StateT> value, {bool seamless = false}) {
    asyncTransition(value, seamless: seamless);
    if (_futureCompleter == null) {
      final completer = _futureCompleter = Completer();
      futureNotifier.result = ResultData(completer.future);
    }
  }

  /// Life-cycle for when an error from the provider's "build" method is received.
  ///
  /// Might be invoked after the element is disposed in the case where `provider.future`
  /// has yet to complete.
  @internal
  void onError(AsyncError<StateT> value, {bool seamless = false}) {
    asyncTransition(value, seamless: seamless);

    for (final observer in container.observers) {
      runTernaryGuarded(
        observer.providerDidFail,
        _currentObserverContext(),
        value.error,
        value.stackTrace,
      );
    }

    final completer = _futureCompleter;
    if (completer != null) {
      completer
        ..future.ignore()
        ..completeError(
          value.error,
          value.stackTrace,
        );
      _futureCompleter = null;
    } else {
      futureNotifier.result = Result.data(
        Future.error(
          value.error,
          value.stackTrace,
        )..ignore(),
      );
    }
  }

  /// Life-cycle for when a data from the provider's "build" method is received.
  ///
  /// Might be invoked after the element is disposed in the case where `provider.future`
  /// has yet to complete.
  @internal
  void onData(AsyncData<StateT> value, {bool seamless = false}) {
    asyncTransition(value, seamless: seamless);

    final completer = _futureCompleter;
    if (completer != null) {
      completer.complete(value.value);
      _futureCompleter = null;
    } else {
      futureNotifier.result = Result.data(Future.value(value.value));
    }
  }

  /// Listens to a [Stream] and convert it into an [AsyncValue].
  @preferInline
  @internal
  void handleStream(
    Stream<StateT> Function() create, {
    required bool seamless,
  }) {
    _handleAsync(seamless: seamless, ({
      required data,
      required done,
      required error,
      required last,
    }) {
      final stream = create();

      return stream.listenAndTrackLast(
        last,
        lastOrElseError: _missingLastValueError,
        onData: data,
        onError: error,
        onDone: done,
      );
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
  void handleFuture(
    FutureOr<StateT> Function() create, {
    required bool seamless,
  }) {
    _handleAsync(seamless: seamless, ({
      required data,
      required done,
      required error,
      required last,
    }) {
      final futureOr = create();
      if (futureOr is! Future<StateT>) {
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
  void _handleAsync(
    AsyncSubscription? Function({
      required void Function(StateT) data,
      required void Function(Object, StackTrace) error,
      required void Function() done,
      required void Function(Future<StateT>) last,
    }) listen, {
    required bool seamless,
  }) {
    onLoading(AsyncLoading<StateT>(), seamless: seamless);

    void callOnError(Object error, StackTrace stackTrace) {
      triggerRetry(error);
      onError(AsyncError(error, stackTrace), seamless: seamless);
    }

    try {
      _cancelSubscription = listen(
        data: (value) {
          onData(AsyncData(value), seamless: seamless);
        },
        error: callOnError,
        last: (last) {
          assert(_lastFuture == null, 'bad state');
          _lastFuture = last;
        },
        done: () {
          _lastFuture = null;
        },
      );
    } catch (error, stackTrace) {
      callOnError(error, stackTrace);
    }
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
        completer.completeError(
          _missingLastValueError(),
          StackTrace.current,
        );
      }
    }
    super.dispose();
  }

  @override
  void visitChildren({
    required void Function(ProviderElement element) elementVisitor,
    required void Function(ProxyElementValueListenable element)
        listenableVisitor,
  }) {
    super.visitChildren(
      elementVisitor: elementVisitor,
      listenableVisitor: listenableVisitor,
    );
    listenableVisitor(futureNotifier);
  }
}

extension<T> on Stream<T> {
  AsyncSubscription listenAndTrackLast(
    void Function(Future<T>) last, {
    required Object Function() lastOrElseError,
    required void Function(T event) onData,
    required void Function(Object error, StackTrace stackTrace) onError,
    required void Function() onDone,
  }) {
    late StreamSubscription<T> subscription;
    subscription = listen(onData, onError: onError, onDone: onDone);

    final asyncSub = (
      cancel: subscription.cancel,
      pause: subscription.pause,
      resume: subscription.resume,
      abort: subscription.cancel,
    );

    return asyncSub;
  }
}
