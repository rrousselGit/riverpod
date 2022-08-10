part of '../stream_provider.dart';

/// {@macro riverpod.providerrefbase}
/// - [ProviderRef.state], the value currently exposed by this provider.
abstract class StreamProviderRef<State> implements Ref<AsyncValue<State>> {
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

class StreamProvider<T> extends _StreamProviderBase<T>
    with AlwaysAliveProviderBase<AsyncValue<T>> {
  StreamProvider(
    this._createFn, {
    super.name,
    super.from,
    super.argument,
    super.dependencies,
  }) : super(cacheTime: null, disposeDelay: null);

  static const autoDispose = AutoDisposeStreamProviderBuilder();
  static const family = StreamProviderFamilyBuilder();

  final Stream<T> Function(StreamProviderRef<T> ref) _createFn;

  @override
  late final AlwaysAliveRefreshable<Future<T>> future = _future(this);

  @override
  late final AlwaysAliveRefreshable<Stream<T>> stream = _stream(this);

  @override
  Stream<T> _create(StreamProviderElement<T> ref) => _createFn(ref);

  @override
  StreamProviderElement<T> createElement() => StreamProviderElement(this);
}

class StreamProviderElement<T> extends ProviderElementBase<AsyncValue<T>>
    implements StreamProviderRef<T> {
  StreamProviderElement(_StreamProviderBase<T> provider) : super(provider);

  final _futureNotifier = ValueNotifier<Future<T>>();
  Completer<T>? _completer;

  final _streamNotifier = ValueNotifier<Stream<T>>();
  final StreamController<T> _streamController = StreamController<T>.broadcast();

  StreamSubscription<T>? _streamSubscription;

  @override
  AsyncValue<T> get state => requireState;

  @override
  set state(AsyncValue<T> state) => setState(state);

  @override
  void create() {
    _streamNotifier.result ??= Result.data(_streamController.stream);

    final streamResult = Result.guard(() {
      final provider = this.provider as _StreamProviderBase<T>;
      return provider._create(this);
    });

    streamResult.when(
      data: _listenStream,
      error: (err, stack) {
        _futureNotifier.result = Result.data(
          Future<T>.error(err, stack)
            // TODO test ignore
            ..ignore(),
        );
        setState(AsyncError<T>(err, stackTrace: stack));
      },
    );
  }

  @pragma('vm:prefer-inline')
  void _listenStream(Stream<T> stream) {
    final wasLoading = getState()?.stateOrNull?.isLoading ?? false;
    if (!wasLoading) {
      setState(AsyncLoading<T>());
    }

    // TODO test that if a provider refreshes with before the stream has emitted a value,
    // then .future isn't notifying listeners
    if (_completer == null) {
      final completer = _completer = Completer<T>();
      _futureNotifier.result = Result.data(completer.future);
    }

    _streamSubscription = stream.listen(
      (event) {
        final completer = _completer;
        if (completer != null) {
          completer.complete(event);
          _completer = null;
          // TODO test that ref.read(p.future) after an event is emitted
          // obtains a SynchronousFuture.
          // Yet listeners of .future added before the first event aren't notified
          _futureNotifier.unsafeSetResultWithoutNotifyingListeners(
            Result.data(SynchronousFuture(event)),
          );
        } else {
          _futureNotifier.result = Result.data(SynchronousFuture(event));
        }

        setState(AsyncData(event));
        _streamController.add(event);
      },
      // ignore: avoid_types_on_closure_parameters
      onError: (Object err, StackTrace stack) {
        final completer = _completer;
        if (completer != null) {
          completer
            ..completeError(err, stack)
            // The error is already sent to the Zone through the original Stream
            // so no need for this Future to send the error to the Zone too.
            ..future.ignore();
          _completer = null;
          // TODO can we have a SynchronousFutureError?
        } else {
          _futureNotifier.result = Result.data(
            Future<T>.error(err, stack)
              // TODO test ignore
              ..ignore(),
          );
        }

        setState(AsyncError<T>(err, stackTrace: stack));
        _streamController.addError(err, stack);
      },
    );
  }

  @override
  void runOnDispose() {
    super.runOnDispose();
    _streamSubscription?.cancel();
  }

  @override
  void dispose() {
    super.dispose();

    /// The controller isn't recreated on provider rebuild. So we only close it
    /// when the element is destroyed, not on "ref.onDispose".
    _streamController.close();
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
}

class StreamProviderFamily<R, Arg> extends FamilyBase<StreamProviderRef<R>,
    AsyncValue<R>, Arg, Stream<R>, StreamProvider<R>> {
  StreamProviderFamily(
    super.create, {
    super.name,
    super.dependencies,
  }) : super(providerFactory: StreamProvider<R>.new);
}
