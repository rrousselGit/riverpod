part of '../../framework.dart';

/// Internal typedef for cancelling the subscription to an async operation
@internal
typedef CancelAsyncSubscription = void Function();

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
  Refreshable<Future<StateT>> get future {
    return ProviderElementProxy<AsyncValue<StateT>, Future<StateT>>(
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
    return _AsyncSelector<StateT, Output>(
      selector: selector,
      provider: this,
      future: future,
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
  CancelAsyncSubscription? _lastFutureSub;
  CancelAsyncSubscription? _cancelSubscription;

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
    // TODO assert Notifier isn't disposed
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
      runQuaternaryGuarded(
        observer.providerDidFail,
        provider,
        value.error,
        value.stackTrace,
        container,
      );
    }

    final completer = _futureCompleter;
    if (completer != null) {
      completer
        // TODO test ignore
        ..future.ignore()
        ..completeError(
          value.error,
          value.stackTrace,
        );
      _futureCompleter = null;
      // TODO SynchronousFuture.error
    } else {
      futureNotifier.result = Result.data(
        // TODO test ignore
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
      final rawStream = create();
      final stream = rawStream.isBroadcast
          ? rawStream
          : rawStream.asBroadcastStream(onCancel: (sub) => sub.cancel());

      stream.lastCancelable(last, orElseError: _missingLastValueError);

      final sub = stream.listen(data, onError: error, onDone: done);
      return sub.cancel;
    });
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

      last(futureOr, cancel);

      return cancel;
    });
  }

  /// Listens to a [Future] and transforms it into an [AsyncValue].
  void _handleAsync(
    // Stream<T> Function({required void Function(T) fireImmediately}) create,
    CancelAsyncSubscription? Function({
      required void Function(StateT) data,
      required void Function(Object, StackTrace) error,
      required void Function() done,
      required void Function(Future<StateT>, CancelAsyncSubscription) last,
    }) listen, {
    required bool seamless,
  }) {
    onLoading(AsyncLoading<StateT>(), seamless: seamless);

    try {
      final sub = _cancelSubscription = listen(
        data: (value) {
          onData(AsyncData(value), seamless: seamless);
        },
        error: (error, stack) {
          onError(AsyncError(error, stack), seamless: seamless);
        },
        last: (last, sub) {
          assert(_lastFuture == null, 'bad state');
          assert(_lastFutureSub == null, 'bad state');
          _lastFuture = last;
          _lastFutureSub = sub;
        },
        done: () {
          _lastFutureSub?.call();
          _lastFutureSub = null;
          _lastFuture = null;
        },
      );
      assert(
        sub == null || _lastFuture != null,
        'An async operation is pending but the state for provider.future was not initialized.',
      );

      // TODO test build throws -> provider emits AsyncError synchronously & .future emits Future.error
      // TODO test build resolves with error -> emits AsyncError & .future emits Future.error
      // TODO test build emits value -> .future emits value & provider emits AsyncData
    } catch (error, stackTrace) {
      onError(
        AsyncError<StateT>(error, stackTrace),
        seamless: seamless,
      );
    }
  }

  @override
  @internal
  void runOnDispose() {
    // Stops listening to the previous async operation
    _lastFutureSub?.call();
    _lastFutureSub = null;
    _lastFuture = null;
    _cancelSubscription?.call();
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
        // The completer will be completed by the while loop in handleStream

        final cancelSubscription = _cancelSubscription;
        if (cancelSubscription != null) {
          completer.future
              .then(
                (_) {},
                // ignore: avoid_types_on_closure_parameters
                onError: (Object _) {},
              )
              .whenComplete(cancelSubscription);
        }

        // Prevent super.dispose from cancelling the subscription on the "last"
        // stream value, so that it can be sent to `provider.future`.
        _lastFuture = null;
        _lastFutureSub = null;
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
  void lastCancelable(
    void Function(Future<T>, CancelAsyncSubscription) last, {
    required Object Function() orElseError,
  }) {
    late StreamSubscription<T> subscription;
    final completer = Completer<T>();

    Result<T>? result;
    subscription = listen(
      (event) => result = Result.data(event),
      // ignore: avoid_types_on_closure_parameters
      onError: (Object error, StackTrace stackTrace) {
        result = Result.error(error, stackTrace);
      },
      onDone: () {
        if (result != null) {
          switch (result!) {
            case ResultData(:final state):
              completer.complete(state);
            case ResultError(:final error, :final stackTrace):
              // TODO: should this be reported to the zone?
              completer.future.ignore();
              completer.completeError(error, stackTrace);
          }
        } else {
          // The error happens after the associated provider is disposed.
          // As such, it's normally never read. Reporting this error as uncaught
          // would cause too many false-positives. And the edge-cases that
          // do reach this error will throw anyway
          completer.future.ignore();

          completer.completeError(
            orElseError(),
            StackTrace.current,
          );
        }
      },
    );

    last(completer.future, subscription.cancel);
  }
}
