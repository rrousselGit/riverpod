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
  AsyncNotifierProviderRef<State> get ref => _element;
}

/// {@template riverpod.asyncnotifier}
/// A [Notifier] implementation that is asynchronously initialized.
///
/// It is commonly used for:
/// - Caching a network request while also allowing to perform side-effects.
///   For example, `build` could fetch information about the current "user".
///   And the [AsyncNotifier] could expose methods such as "setName",
///   to allow changing the current user name.
/// - Initializing a [Notifier] from an asynchronous source of data.
///   For example, obtaining the initial state of [Notifier] from a local database.
/// {@endtemplate}
// TODO add usage example
abstract class AsyncNotifier<State> extends BuildlessAsyncNotifier<State> {
  /// {@template riverpod.asyncnotifier.build}
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

/// {@macro riverpod.providerrefbase}
abstract class AsyncNotifierProviderRef<T> implements Ref<AsyncValue<T>> {}

/// {@template riverpod.async_notifier_provider}
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
    with AlwaysAliveProviderBase<AsyncValue<T>>, AlwaysAliveAsyncSelector<T> {
  /// {@macro riverpod.async_notifier_provider}
  AsyncNotifierProviderImpl(
    super._createNotifier, {
    super.name,
    super.from,
    super.argument,
    super.dependencies,
    super.debugGetCreateSourceHash,
  });

  /// {@macro riverpod.autoDispose}
  static const autoDispose = AutoDisposeAsyncNotifierProviderBuilder();

  /// {@macro riverpod.family}
  static const family = AsyncNotifierProviderFamilyBuilder();

  @override
  late final AlwaysAliveRefreshable<NotifierT> notifier =
      _notifier<NotifierT, T>(this);

  @override
  late final AlwaysAliveRefreshable<Future<T>> future = _future<T>(this);

  @override
  AsyncNotifierProviderElement<NotifierT, T> createElement() {
    return AsyncNotifierProviderElement._(this);
  }

  @override
  FutureOr<T> runNotifierBuild(AsyncNotifierBase<T> notifier) {
    return (notifier as AsyncNotifier<T>).build();
  }

  /// {@macro riverpod.overridewith}
  Override overrideWith(NotifierT Function() create) {
    return ProviderOverride(
      origin: this,
      override: AsyncNotifierProviderImpl<NotifierT, T>(
        create,
        from: from,
        argument: argument,
      ),
    );
  }
}

/// A mixin shared by [AsyncNotifierProvider] and [FutureProvider] for dealing with
/// the logic of listening to a [Future] and converting it into an [AsyncValue].
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

  /// The latest [Future] returned by [AsyncNotifier.build].
  ///
  /// This reference to the future is kept until a state is emitted.
  /// As soon as a value is emitted, it will revert to `null`.
  ///
  /// The purpose of the variable is to handle the case where an [AsyncNotifier]
  /// is disposed while still in loading state.
  ///
  /// In that scenario, `AsyncNotifier.future` will resolve with [_builtFuture].
  Future<T>? _builtFuture;

  /// Handles manual state change (as opposed to automatic state change from
  /// listening to the [Future]).
  @protected
  set state(AsyncValue<T> newState) {
    // TODO assert Notifier isn't disposed
    newState.when(
      error: _errorTransition,
      loading: _loadingTransition,
      data: _dataTransition,
    );

    if (newState.isLoading) {
      setState(newState.copyWithPrevious(requireState, isRefresh: false));
    } else {
      setState(newState);
    }
  }

  void _dataTransition(T value) {
    _builtFuture = null;

    final completer = _futureCompleter;
    if (completer != null) {
      completer.complete(value);
      _futureCompleter = null;
    } else {
      futureNotifier.result = Result.data(Future.value(value));
    }
  }

  void _loadingTransition() {
    if (_futureCompleter == null) {
      final completer = _futureCompleter = Completer();
      futureNotifier.result = ResultData(completer.future);
    }
  }

  void _errorTransition(Object err, StackTrace stackTrace) {
    _builtFuture = null;

    final completer = _futureCompleter;
    if (completer != null) {
      completer
        // TODO test ignore
        ..future.ignore()
        ..completeError(err, stackTrace);
      _futureCompleter = null;
      // TODO SynchronousFuture.error
    } else {
      futureNotifier.result = Result.data(
        // TODO test ignore
        Future.error(err, stackTrace)..ignore(),
      );
    }
  }

  /// Listens to a [Future] and transforms it into an [AsyncValue].
  @internal
  void handleFuture(
    FutureOr<T> Function() create, {
    required bool didChangeDependency,
  }) {
    assert(_builtFuture == null, 'Bad state');
    _loadingTransition();
    asyncTransition(shouldClearPreviousState: didChangeDependency);

    final futureOrResult = Result.guard(create);

    // TODO test build throws -> provider emits AsyncError synchronously & .future emits Future.error
    // TODO test build resolves with error -> emits AsyncError & .future emits Future.error
    // TODO test build emits value -> .future emits value & provider emits AsyncData
    futureOrResult.when(
      error: (error, stackTrace) {
        _errorTransition(error, stackTrace);
        setState(AsyncError(error, stackTrace));
      },
      data: (futureOr) {
        if (futureOr is Future<T>) {
          _builtFuture = futureOr;

          futureOr.then(
            (value) {
              // If _builtFuture has changed, it means either a new state
              // was manually emitted (such as with AsyncNotifier.state=)
              // or the provider rebuilt (so a new future was created).
              if (_builtFuture == futureOr) {
                _dataTransition(value);
                setState(AsyncData(value));
                _builtFuture = null;
              }
            },
            // ignore: avoid_types_on_closure_parameters
            onError: (Object error, StackTrace stackTrace) {
              // If _builtFuture has changed, it means either a new state
              // was manually emitted (such as with AsyncNotifier.state=)
              // or the provider rebuilt (so a new future was created).
              if (_builtFuture == futureOr) {
                _errorTransition(error, stackTrace);
                setState(AsyncError<T>(error, stackTrace));
                _builtFuture = null;
              }
            },
          );
        } else {
          // No need to set _builtFuture if AsyncNotifier.build resolved
          // synchronously, as there is no loading state to handle.

          _dataTransition(futureOr);
          setState(AsyncData(futureOr));
        }
      },
    );
  }

  @override
  void runOnDispose() {
    // This will both stops listening to the previous future
    _builtFuture = null;
    super.runOnDispose();
  }

  @override
  void dispose() {
    final completer = _futureCompleter;
    if (completer != null) {
      final future = _builtFuture;
      // It is normally safe to ignore this error, as the provider is meant
      // to no-longer be used anymore.
      completer.future.ignore();

      if (future != null) {
        future.then(completer.complete, onError: completer.completeError);
      } else {
        completer.completeError(
          StateError(
            'The provider $origin was disposed during loading state, '
            'yet no value could be emitted.',
          ),
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
class AsyncNotifierProviderElement<NotifierT extends AsyncNotifierBase<T>, T>
    extends ProviderElementBase<AsyncValue<T>>
    with FutureHandlerProviderElementMixin<T>
    implements AsyncNotifierProviderRef<T> {
  AsyncNotifierProviderElement._(
    AsyncNotifierProviderBase<NotifierT, T> super.provider,
  );

  final _notifierNotifier = ProxyElementValueNotifier<NotifierT>();

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
        _errorTransition(error, stackTrace);
        setState(AsyncError(error, stackTrace));
      },
      data: (notifier) => handleFuture(
        () => provider.runNotifierBuild(notifier),
        didChangeDependency: didChangeDependency,
      ),
    );
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
    notifierVisitor(_notifierNotifier);
  }

  @override
  bool updateShouldNotify(AsyncValue<T> previous, AsyncValue<T> next) {
    return _notifierNotifier.result?.stateOrNull
            ?.updateShouldNotify(previous, next) ??
        true;
  }
}
