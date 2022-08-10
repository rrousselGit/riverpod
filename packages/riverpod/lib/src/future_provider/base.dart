part of '../future_provider.dart';

/// {@macro riverpod.providerrefbase}
/// - [ProviderRef.state], the value currently exposed by this provider.
abstract class FutureProviderRef<State> implements Ref<AsyncValue<State>> {
  /// Obtains the state currently exposed by this provider.
  ///
  /// Mutating this property will notify the provider listeners.
  ///
  /// Cannot be called while a provider is creating, unless the setter was called first.
  ///
  /// Will throw if the provider threw during creation.
  AsyncValue<State> get state;
  set state(AsyncValue<State> newState);
}

class FutureProvider<T> extends _FutureProviderBase<T>
    with AlwaysAliveProviderBase<AsyncValue<T>>, AlwaysAliveAsyncSelector<T> {
  FutureProvider(
    this._createFn, {
    super.name,
    super.from,
    super.argument,
    super.dependencies,
  }) : super(cacheTime: null, disposeDelay: null);

  static const autoDispose = AutoDisposeFutureProviderBuilder();
  static const family = FutureProviderFamilyBuilder();

  final FutureOr<T> Function(FutureProviderRef<T> ref) _createFn;

  @override
  late final AlwaysAliveRefreshable<Future<T>> future = _future(this);

  @override
  late final AlwaysAliveRefreshable<Stream<T>> stream = _stream(this);

  @override
  FutureOr<T> _create(FutureProviderElement<T> ref) => _createFn(ref);

  @override
  FutureProviderElement<T> createElement() => FutureProviderElement(this);
}

class FutureProviderElement<T> extends ProviderElementBase<AsyncValue<T>>
    implements FutureProviderRef<T> {
  FutureProviderElement(_FutureProviderBase<T> provider) : super(provider);

  final _futureNotifier = ValueNotifier<Future<T>>();
  final _streamNotifier = ValueNotifier<Stream<T>>();
  final _streamController = StreamController<T>.broadcast();

  @override
  AsyncValue<T> get state => requireState;

  @override
  set state(AsyncValue<T> state) => setState(state);

  @override
  void create() {
    // TODO add a Proxy variant that accepts T instead of Result<T>
    _streamNotifier.result ??= Result.data(_streamController.stream);

    // The try/catch is here to handle synchronous exceptions, which can happen
    // if the create function isn't marked with "async".
    try {
      final provider = this.provider as _FutureProviderBase<T>;
      final futureOr = provider._create(this);

      final future =
          futureOr is Future<T> ? futureOr : SynchronousFuture(futureOr);

      if (future != _futureNotifier.result?.stateOrNull) {
        _futureNotifier.result = Result.data(future);
        _listenFuture(future);
      }
    } catch (err, stack) {
      // TODO Can we have a SynchronousFutureError?
      _futureNotifier.result = Result.data(
        Future.error(err, stack)
          // TODO report the error to the ProviderContainer's Zone
          ..ignore(),
      );
      _streamController.addError(err, stack);
      setState(AsyncError<T>(err, stackTrace: stack));
    }
  }

  @pragma('vm:prefer-inline')
  void _listenFuture(Future<T> future) {
    var running = true;
    onDispose(() => running = false);

    final wasLoading = getState()?.stateOrNull?.isLoading ?? false;
    if (!wasLoading) {
      setState(AsyncLoading<T>());
    }

    future.then(
      (value) {
        if (running) {
          _streamController.add(value);
          setState(AsyncData<T>(value));
        }
      },
      // ignore: avoid_types_on_closure_parameters
      onError: (Object err, StackTrace stack) {
        if (running) {
          _streamController.addError(err, stack);
          setState(AsyncError<T>(err, stackTrace: stack));
        }
      },
    );
  }

  @override
  void visitChildren({
    required void Function(ProviderElementBase element) elementVisitor,
    required void Function(ValueNotifier element) notifierVisitor,
  }) {
    super.visitChildren(
      elementVisitor: elementVisitor,
      notifierVisitor: notifierVisitor,
    );
    notifierVisitor(_futureNotifier);
    notifierVisitor(_streamNotifier);
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }
}

class FutureProviderFamily<R, Arg> extends FamilyBase<FutureProviderRef<R>,
    AsyncValue<R>, Arg, FutureOr<R>, FutureProvider<R>> {
  FutureProviderFamily(
    super.create, {
    super.name,
    super.dependencies,
  }) : super(providerFactory: FutureProvider<R>.new);
}
