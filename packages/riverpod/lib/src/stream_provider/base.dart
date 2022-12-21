part of '../stream_provider.dart';

/// {@macro riverpod.providerrefbase}
/// - [StreamProviderRef.state], the value currently exposed by this provider.
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

/// {@template riverpod.streamprovider}
/// Creates a stream and exposes its latest event.
///
/// [StreamProvider] is identical in behavior/usage to [FutureProvider], modulo
/// the fact that the value created is a [Stream] instead of a [Future].
///
/// It can be used to express a value asynchronously loaded that can change over
/// time, such as an editable `Message` coming from a web socket:
///
/// ```dart
/// final messageProvider = StreamProvider.autoDispose<String>((ref) async* {
///   // Open the connection
///   final channel = IOWebSocketChannel.connect('ws://echo.websocket.org');
///
///   // Close the connection when the stream is destroyed
///   ref.onDispose(() => channel.sink.close());
///
///   // Parse the value received and emit a Message instance
///   await for (final value in channel.stream) {
///     yield value.toString();
///   }
/// });
/// ```
///
/// Which the UI can then listen:
///
/// ```dart
/// Widget build(BuildContext context, WidgetRef ref) {
///   AsyncValue<String> message = ref.watch(messageProvider);
///
///   return message.when(
///     loading: () => const CircularProgressIndicator(),
///     error: (err, stack) => Text('Error: $err'),
///     data: (message) {
///       return Text(message);
///     },
///   );
/// }
/// ```
///
/// **Note**:
/// When listening to web sockets, firebase, or anything that consumes resources,
/// it is important to use [StreamProvider.autoDispose] instead of simply [StreamProvider].
///
/// This ensures that the resources are released when no longer needed as,
/// by default, a [StreamProvider] is almost never destroyed.
///
/// See also:
///
/// - [Provider], a provider that synchronously creates a value
/// - [FutureProvider], a provider that asynchronously exposes a value that
///   can change over time.
/// - [stream], to obtain the [Stream] created instead of an [AsyncValue].
/// - [future], to obtain the last value emitted by a [Stream].
/// - [StreamProvider.family], to create a [StreamProvider] from external parameters
/// - [StreamProvider.autoDispose], to destroy the state of a [StreamProvider] when no longer needed.
/// {@endtemplate}
class StreamProvider<T> extends _StreamProviderBase<T>
    with AlwaysAliveProviderBase<AsyncValue<T>>, AlwaysAliveAsyncSelector<T> {
  /// {@macro riverpod.streamprovider}
  StreamProvider(
    this._createFn, {
    super.name,
    super.from,
    super.argument,
    super.dependencies,
    super.debugGetCreateSourceHash,
  });

  /// {@macro riverpod.autoDispose}
  static const autoDispose = AutoDisposeStreamProviderBuilder();

  /// {@macro riverpod.family}
  static const family = StreamProviderFamilyBuilder();

  final Stream<T> Function(StreamProviderRef<T> ref) _createFn;

  @override
  late final AlwaysAliveRefreshable<Future<T>> future = _future(this);

  @override
  late final AlwaysAliveRefreshable<Stream<T>> stream = _stream(this);

  @override
  Stream<T> _create(StreamProviderElement<T> ref) => _createFn(ref);

  @override
  StreamProviderElement<T> createElement() => StreamProviderElement._(this);

  /// {@macro riverpod.overridewith}
  Override overrideWith(Create<Stream<T>, StreamProviderRef<T>> create) {
    return ProviderOverride(
      origin: this,
      override: StreamProvider<T>(
        create,
        from: from,
        argument: argument,
      ),
    );
  }
}

/// The element of [StreamProvider].
class StreamProviderElement<T> extends ProviderElementBase<AsyncValue<T>>
    implements StreamProviderRef<T> {
  StreamProviderElement._(_StreamProviderBase<T> super.provider);

  final _futureNotifier = ProxyElementValueNotifier<Future<T>>();
  Completer<T>? _completer;

  final _streamNotifier = ProxyElementValueNotifier<Stream<T>>();
  final StreamController<T> _streamController = StreamController<T>.broadcast();

  StreamSubscription<T>? _streamSubscription;

  @override
  AsyncValue<T> get state => requireState;

  @override
  set state(AsyncValue<T> state) {
    if (state.isLoading) {
      setState(
        state.copyWithPrevious(requireState, isRefresh: false),
      );
    } else {
      setState(state);
    }
  }

  @override
  void create({required bool didChangeDependency}) {
    asyncTransition(shouldClearPreviousState: didChangeDependency);
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
        setState(AsyncError<T>(err, stack));
      },
    );
  }

  @override
  bool updateShouldNotify(AsyncValue<T> previous, AsyncValue<T> next) {
    final wasLoading = previous is AsyncLoading;
    final isLoading = next is AsyncLoading;

    if (wasLoading || isLoading) return wasLoading != isLoading;

    return true;
  }

  @pragma('vm:prefer-inline')
  void _listenStream(Stream<T> stream) {
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
        } else {
          _futureNotifier.result = Result.data(Future.value(event));
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

        setState(AsyncError<T>(err, stack));
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
    required void Function(ProxyElementValueNotifier element) notifierVisitor,
  }) {
    super.visitChildren(
      elementVisitor: elementVisitor,
      notifierVisitor: notifierVisitor,
    );
    notifierVisitor(_futureNotifier);
    notifierVisitor(_streamNotifier);
  }
}

/// The [Family] of [StreamProvider].
class StreamProviderFamily<R, Arg> extends FamilyBase<StreamProviderRef<R>,
    AsyncValue<R>, Arg, Stream<R>, StreamProvider<R>> {
  /// The [Family] of [StreamProvider].
  StreamProviderFamily(
    super.create, {
    super.name,
    super.dependencies,
  }) : super(providerFactory: StreamProvider<R>.new);

  /// {@macro riverpod.overridewith}
  Override overrideWith(
    Stream<R> Function(StreamProviderRef<R> ref, Arg arg) create,
  ) {
    return FamilyOverrideImpl<AsyncValue<R>, Arg, StreamProvider<R>>(
      this,
      (arg) => StreamProvider<R>(
        (ref) => create(ref, arg),
        from: from,
        argument: arg,
      ),
    );
  }
}
