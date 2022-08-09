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
    with AlwaysAliveProviderBase<AsyncValue<T>> {
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
  final _streamController = StreamController<T>.broadcast(sync: true);

  @override
  AsyncValue<T> get state => requireState;

  @override
  set state(AsyncValue<T> state) => setState(state);

  @override
  void create() {
    final future = _guardCreate();

    // TODO add a Proxy variant that accepts T instead of Result<T>
    _streamNotifier.result ??= Result.data(_streamController.stream);
    _futureNotifier.result = Result.data(future);

    _listenFuture(future);
  }

  @pragma('vm:prefer-inline')
  Future<T> _guardCreate() {
    final provider = this.provider as _FutureProviderBase<T>;

    try {
      final futureOr = provider._create(this);

      if (futureOr is Future<T>) {
        return futureOr;
      } else {
        return SynchronousFuture(futureOr);
      }
    } catch (err, stack) {
      // TODO Can we have a SynchronousFutureError?
      return Future.error(err, stack);
    }
  }

  @pragma('vm:prefer-inline')
  void _listenFuture(Future<T> future) {
    var running = true;
    onDispose(() => running = false);

    setState(AsyncLoading<T>());

    future.then(
      (value) {
        if (running) {
          setState(AsyncData<T>(value));
        }
      },
      // ignore: avoid_types_on_closure_parameters
      onError: (Object err, StackTrace stack) {
        if (running) {
          setState(AsyncError<T>(err, stackTrace: stack));
        }
      },
    );
  }

  @override
  void runOnDispose() {
    super.runOnDispose();
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
    super.cacheTime,
    super.disposeDelay,
  }) : super(providerFactory: FutureProvider<R>.new);
}
