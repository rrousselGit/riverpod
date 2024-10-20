part of '../async_notifier.dart';

/// A [AsyncNotifier] base class shared between family and non-family notifiers.
///
/// Not meant for public consumption outside of riverpod_generator
@internal
abstract class BuildlessAsyncNotifier<State> extends AsyncNotifierBase<State> {
  @override
  late final AsyncNotifierProviderElement<AsyncNotifierBase<State>, State>
      _element;

  @override
  void _setElement(ProviderElementBase<AsyncValue<State>> element) {
    _element = element
        as AsyncNotifierProviderElement<AsyncNotifierBase<State>, State>;
  }

  @override
  // ignore: deprecated_member_use_from_same_package
  AsyncNotifierProviderRef<State> get ref => _element;
}

/// {@template riverpod.async_notifier}
/// A [Notifier] implementation that is asynchronously initialized.
///
/// This is similar to a [FutureProvider] but allows to perform side-effects
/// by defining public methods.
///
/// It is commonly used for:
/// - Caching a network request while also allowing to perform side-effects.
///   For example, `build` could fetch information about the current "user".
///   And the [AsyncNotifier] could expose methods such as "setName",
///   to allow changing the current user name.
/// - Initializing a [Notifier] from an asynchronous source of data.
///   For example, obtaining the initial state of [Notifier] from a local database.
/// {@endtemplate}
///
/// {@macro riverpod.async_notifier_provider_modifier}
abstract class AsyncNotifier<State> extends BuildlessAsyncNotifier<State> {
  /// {@template riverpod.async_notifier.build}
  /// Initialize an [AsyncNotifier].
  ///
  /// It is safe to use [Ref.watch] or [Ref.listen] inside this method.
  ///
  /// If a dependency of this [AsyncNotifier] (when using [Ref.watch]) changes,
  /// then [build] will be re-executed. On the other hand, the [AsyncNotifier]
  /// will **not** be recreated. Its instance will be preserved between
  /// executions of [build].
  ///
  /// If this method throws or returns a future that fails, the error
  /// will be caught and an [AsyncError] will be emitted.
  /// {@endtemplate}
  @visibleForOverriding
  FutureOr<State> build();
}

/// {@macro riverpod.provider_ref_base}
@Deprecated('will be removed in 3.0.0. Use Ref instead')
abstract class AsyncNotifierProviderRef<T> implements Ref<AsyncValue<T>> {}

/// {@template riverpod.async_notifier_provider}
/// A provider which creates and listens to an [AsyncNotifier].
///
/// This is similar to [FutureProvider] but allows to perform side-effects.
///
/// The syntax for using this provider is slightly different from the others
/// in that the provider's function doesn't receive a "ref" (and in case
/// of `family`, doesn't receive an argument either).
/// Instead the ref (and argument) are directly accessible in the associated
/// [AsyncNotifier].
/// {@endtemplate}
///
/// {@template riverpod.async_notifier_provider_modifier}
/// When using `autoDispose` or `family`, your notifier type changes.
/// Instead of extending [AsyncNotifier], you should extend either:
/// - [AutoDisposeAsyncNotifier] for `autoDispose`
/// - [FamilyAsyncNotifier] for `family`
/// - [AutoDisposeFamilyAsyncNotifier] for `autoDispose.family`
/// {@endtemplate}
typedef AsyncNotifierProvider<NotifierT extends AsyncNotifier<T>, T>
    = AsyncNotifierProviderImpl<NotifierT, T>;

/// The implementation of [AsyncNotifierProvider] but with loosened type constraints
/// that can be shared with [AutoDisposeAsyncNotifierProvider].
///
/// This enables tests to execute on both [AsyncNotifierProvider] and
/// [AutoDisposeAsyncNotifierProvider] at the same time.
@visibleForTesting
@internal
class AsyncNotifierProviderImpl<NotifierT extends AsyncNotifierBase<T>, T>
    extends AsyncNotifierProviderBase<NotifierT, T>
    with
        // ignore: deprecated_member_use_from_same_package
        AlwaysAliveProviderBase<AsyncValue<T>>,
        AlwaysAliveAsyncSelector<T> {
  /// {@macro riverpod.async_notifier_provider}
  ///
  /// {@macro riverpod.async_notifier_provider_modifier}
  AsyncNotifierProviderImpl(
    super._createNotifier, {
    super.name,
    super.dependencies,
    @Deprecated('Will be removed in 3.0.0') super.from,
    @Deprecated('Will be removed in 3.0.0') super.argument,
    @Deprecated('Will be removed in 3.0.0') super.debugGetCreateSourceHash,
  }) : super(
          allTransitiveDependencies:
              computeAllTransitiveDependencies(dependencies),
        );

  /// An implementation detail of Riverpod
  @internal
  AsyncNotifierProviderImpl.internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    super.from,
    super.argument,
  });

  /// {@macro riverpod.autoDispose}
  static const autoDispose = AutoDisposeAsyncNotifierProviderBuilder();

  /// {@macro riverpod.family}
  static const family = AsyncNotifierProviderFamilyBuilder();

  @override
  // ignore: deprecated_member_use_from_same_package
  late final AlwaysAliveRefreshable<NotifierT> notifier =
      _asyncNotifier<NotifierT, T>(this);

  @override
  // ignore: deprecated_member_use_from_same_package
  late final AlwaysAliveRefreshable<Future<T>> future = _asyncFuture<T>(this);

  @override
  AsyncNotifierProviderElement<NotifierT, T> createElement() {
    return AsyncNotifierProviderElement(this);
  }

  @override
  @mustBeOverridden
  FutureOr<T> runNotifierBuild(AsyncNotifierBase<T> notifier) {
    return (notifier as AsyncNotifier<T>).build();
  }

  /// {@macro riverpod.override_with}
  @mustBeOverridden
  Override overrideWith(NotifierT Function() create) {
    return ProviderOverride(
      origin: this,
      override: AsyncNotifierProviderImpl<NotifierT, T>.internal(
        create,
        from: from,
        argument: argument,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
      ),
    );
  }
}

/// Internal typedef for cancelling the subscription to an async operation
@internal
typedef CancelAsyncSubscription = void Function();

/// Mixin to help implement logic for listening to [Future]s/[Stream]s and setup
/// `provider.future` + convert the object into an [AsyncValue].
@internal
mixin FutureHandlerProviderElementMixin<T>
    on ProviderElementBase<AsyncValue<T>> {
  /// A default implementation for [ProviderElementBase.updateShouldNotify].
  static bool handleUpdateShouldNotify<T>(
    AsyncValue<T> previous,
    AsyncValue<T> next,
  ) {
    final wasLoading = previous.isLoading;
    final isLoading = next.isLoading;

    if (wasLoading || isLoading) return wasLoading != isLoading;

    return true;
  }

  /// An internal function used to obtain the private [futureNotifier] from the mixin
  static ProxyElementValueNotifier<Future<T>> futureNotifierOf<T>(
    FutureHandlerProviderElementMixin<T> handler,
  ) {
    return handler.futureNotifier;
  }

  /// An observable for [FutureProvider.future].
  @internal
  final futureNotifier = ProxyElementValueNotifier<Future<T>>();
  Completer<T>? _futureCompleter;
  Future<T>? _lastFuture;
  CancelAsyncSubscription? _lastFutureSub;
  CancelAsyncSubscription? _cancelSubscription;

  /// Handles manual state change (as opposed to automatic state change from
  /// listening to the [Future]).
  @protected
  AsyncValue<T> get state => requireState;

  @protected
  set state(AsyncValue<T> newState) {
    // TODO assert Notifier isn't disposed
    newState.map(
      loading: _onLoading,
      error: onError,
      data: onData,
    );
  }

  @override
  bool updateShouldNotify(AsyncValue<T> previous, AsyncValue<T> next) {
    return FutureHandlerProviderElementMixin.handleUpdateShouldNotify(
      previous,
      next,
    );
  }

  void _onLoading(AsyncLoading<T> value, {bool seamless = false}) {
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
  void onError(AsyncError<T> value, {bool seamless = false}) {
    if (mounted) {
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
    } else if (mounted) {
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
  void onData(AsyncData<T> value, {bool seamless = false}) {
    if (mounted) {
      asyncTransition(value, seamless: seamless);
    }

    final completer = _futureCompleter;
    if (completer != null) {
      completer.complete(value.value);
      _futureCompleter = null;
    } else if (mounted) {
      futureNotifier.result = Result.data(Future.value(value.value));
    }
  }

  /// Listens to a [Stream] and convert it into an [AsyncValue].
  @preferInline
  @internal
  void handleStream(
    Stream<T> Function() create, {
    required bool didChangeDependency,
  }) {
    _handleAsync(didChangeDependency: didChangeDependency, ({
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
    FutureOr<T> Function() create, {
    required bool didChangeDependency,
  }) {
    _handleAsync(didChangeDependency: didChangeDependency, ({
      required data,
      required done,
      required error,
      required last,
    }) {
      final futureOr = create();
      if (futureOr is! Future<T>) {
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
      required void Function(T) data,
      required void Function(Object, StackTrace) error,
      required void Function() done,
      required void Function(Future<T>, CancelAsyncSubscription) last,
    }) listen, {
    required bool didChangeDependency,
  }) {
    _onLoading(AsyncLoading<T>(), seamless: !didChangeDependency);

    try {
      final sub = _cancelSubscription = listen(
        data: (value) {
          onData(AsyncData(value), seamless: !didChangeDependency);
        },
        error: (error, stack) {
          onError(AsyncError(error, stack), seamless: !didChangeDependency);
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
        AsyncError<T>(error, stackTrace),
        seamless: !didChangeDependency,
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
    required void Function(ProviderElementBase element) elementVisitor,
    required void Function(ProxyElementValueNotifier element) notifierVisitor,
  }) {
    super.visitChildren(
      elementVisitor: elementVisitor,
      notifierVisitor: notifierVisitor,
    );
    notifierVisitor(futureNotifier);
  }
}

/// The element of [AsyncNotifierProvider].
abstract class AsyncNotifierProviderElementBase<
        NotifierT extends AsyncNotifierBase<T>,
        T> extends ProviderElementBase<AsyncValue<T>>
    with FutureHandlerProviderElementMixin<T> {
  /// The element of [AsyncNotifierProvider].
  @internal
  AsyncNotifierProviderElementBase(super._provider);

  final _notifierNotifier = ProxyElementValueNotifier<NotifierT>();

  @override
  void visitChildren({
    required void Function(ProviderElementBase element) elementVisitor,
    required void Function(ProxyElementValueNotifier element) notifierVisitor,
  }) {
    super.visitChildren(
      elementVisitor: elementVisitor,
      notifierVisitor: notifierVisitor,
    );
    notifierVisitor(_notifierNotifier);
  }

  @override
  bool updateShouldNotify(AsyncValue<T> previous, AsyncValue<T> next) {
    return _notifierNotifier.result?.stateOrNull
            ?.updateShouldNotify(previous, next) ??
        true;
  }
}

/// The element of [AsyncNotifierProvider].
class AsyncNotifierProviderElement<NotifierT extends AsyncNotifierBase<T>, T>
    extends AsyncNotifierProviderElementBase<NotifierT, T>
    implements
        // ignore: deprecated_member_use_from_same_package
        AsyncNotifierProviderRef<T> {
  /// The element of [AsyncNotifierProvider].
  @internal
  AsyncNotifierProviderElement(
    AsyncNotifierProviderBase<NotifierT, T> super._provider,
  );

  @override
  void create({required bool didChangeDependency}) {
    final provider = this.provider as AsyncNotifierProviderBase<NotifierT, T>;

    final notifierResult = _notifierNotifier.result ??= Result.guard(() {
      return provider._createNotifier().._setElement(this);
    });

    // TODO test notifier constructor throws -> provider emits AsyncError
    // TODO test notifier constructor throws -> .notifier rethrows the error
    // TODO test notifier constructor throws -> .future emits Future.error
    notifierResult.when(
      error: (error, stackTrace) {
        onError(AsyncError(error, stackTrace), seamless: !didChangeDependency);
      },
      data: (notifier) {
        handleFuture(
          () => provider.runNotifierBuild(notifier),
          didChangeDependency: didChangeDependency,
        );
      },
    );
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
          result!.map(
            data: (result) => completer.complete(result.state),
            error: (result) {
              // TODO: should this be reported to the zone?
              completer.future.ignore();
              completer.completeError(result.error, result.stackTrace);
            },
          );
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
