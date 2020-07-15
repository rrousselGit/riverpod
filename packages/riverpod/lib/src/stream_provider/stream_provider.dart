import 'dart:async';

import '../builders.dart';
import '../common.dart';
import '../framework/framework.dart';
import '../future_provider/future_provider.dart';
import '../provider/provider.dart';

part 'auto_dispose_stream_provider.dart';

/// The state of a [StreamProvider].
class StreamProviderDependency<T> extends ProviderDependencyImpl<Stream<T>> {
  StreamProviderDependency._(Stream<T> stream, this._state) : super(stream);

  final _State<T, ProviderBase<StreamProviderDependency<T>, AsyncValue<T>>>
      _state;

  /// The last value emitted by [value].
  ///
  /// The future will fail if the last event is an error instead.ƒ
  Future<T> get currentData => _state.currentData;
}

/// An internal helper shared between [StreamProvider] and [_ValueStreamProvider]
/// to implement [StreamProviderDependency.currentData].
mixin _State<T,
        P extends ProviderBase<StreamProviderDependency<T>, AsyncValue<T>>>
    on ProviderStateBase<StreamProviderDependency<T>, AsyncValue<T>, P> {
  AsyncValue<T> _state = const AsyncValue.loading();
  @override
  AsyncValue<T> get state => _state;
  set state(AsyncValue<T> state) {
    _state = state;
    if (_currentDataCompleter != null) {
      state.when(
        data: (value) {
          _currentDataCompleter.complete(value);
          _currentDataCompleter = null;
        },
        error: (err, stack) {
          _currentDataCompleter.completeError(err, stack);
          _currentDataCompleter = null;
        },
        loading: () {},
      );
    }
    markMayHaveChanged();
  }

  Completer<T> _currentDataCompleter;
  Future<T> get currentData {
    if (_currentDataCompleter != null) {
      return _currentDataCompleter.future;
    }

    return state.when(
      // We only save the Completer if value is currently available
      // Only loading state requires a two step operation.
      loading: () {
        _currentDataCompleter = Completer<T>();
        return _currentDataCompleter.future;
      },
      data: (value) => Future.value(value),
      error: (err, stack) => Future.error(err, stack),
    );
  }
}

/// {@template riverpod.stream}
/// Creates a stream and expose its latest event.
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
/// Widget build(BuildContext) {
///   AsyncValue<String> message = useProvider(messageProvider);
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
/// This ensures that the resources are released when no-longer needed as,
/// by default, a [StreamProvider] is almost never destroyed.
/// {@endtemplate}
class StreamProvider<T> extends AlwaysAliveProviderBase<
    StreamProviderDependency<T>, AsyncValue<T>> {
  /// {@macro riverpod.stream}
  StreamProvider(this._create, {String name}) : super(name);

  /// {@macro riverpod.family}
  static const family = StreamProviderFamilyBuilder();

  /// {@macro riverpod.autoDispose}
  static const autoDispose = AutoDisposeStreamProviderBuilder();

  final Create<Stream<T>, ProviderReference> _create;

  /// A test utility to override a [StreamProvider] with a synchronous value.
  ///
  /// Overriding a [StreamProvider] with an [AsyncValue.data]/[AsyncValue.error]
  /// bypass the loading step that most streams have, which simplifies the test.
  ///
  /// It is possible to change the state emitted by changing the override
  /// on [ProviderContainer]/`ProviderScope`.
  ///
  /// Once an [AsyncValue.data]/[AsyncValue.error] was emitted, it is no longer
  /// possible to emit a [AsyncValue.loading].
  ///
  /// This will create a made up [Stream] for [ProviderDependency.value].
  ProviderOverride debugOverrideWithValue(AsyncValue<T> value) {
    ProviderOverride res;
    assert(() {
      res = overrideAs(_ValueStreamProvider(value));
      return true;
    }(), '');
    return res;
  }

  @override
  _StreamProviderState<T> createState() {
    return _StreamProviderState<T>();
  }
}

mixin _StreamProviderStateMixin<T,
        P extends ProviderBase<StreamProviderDependency<T>, AsyncValue<T>>>
    on ProviderStateBase<StreamProviderDependency<T>, AsyncValue<T>, P>
    implements _State<T, P> {
  Stream<T> _stream;
  StreamSubscription<T> _streamDependency;

  Stream<T> create();

  @override
  StreamProviderDependency<T> createProviderDependency() {
    return StreamProviderDependency._(_stream, this);
  }

  @override
  void initState() {
    _stream = create();
    _streamDependency = _stream.listen(
      (event) {
        state = AsyncValue.data(event);
      },
      onError: (
        dynamic err,
        // ignore: avoid_types_on_closure_parameters
        StackTrace stack,
      ) {
        state = AsyncValue.error(err, stack);
      },
    );
  }

  @override
  void dispose() {
    _streamDependency.cancel();
    super.dispose();
  }
}

class _StreamProviderState<T> extends ProviderStateBase<
        StreamProviderDependency<T>, AsyncValue<T>, StreamProvider<T>>
    with
        _State<T, StreamProvider<T>>,
        _StreamProviderStateMixin<T, StreamProvider<T>> {
  @override
  // ignore: invalid_use_of_visible_for_testing_member
  Stream<T> create() => provider._create(ProviderReference(this));
}

/// Overide a [StreamProvider] with a synchronous value.
class _ValueStreamProvider<T> extends AlwaysAliveProviderBase<
    StreamProviderDependency<T>, AsyncValue<T>> {
  _ValueStreamProvider(this.value, {String name}) : super(name);

  final AsyncValue<T> value;

  @override
  _ValueStreamProviderState<T> createState() {
    return _ValueStreamProviderState<T>();
  }
}

class _ValueStreamProviderState<T> extends ProviderStateBase<
    StreamProviderDependency<T>,
    AsyncValue<T>,
    _ValueStreamProvider<T>> with _State<T, _ValueStreamProvider<T>> {
  final _controller = StreamController<T>();

  @override
  StreamProviderDependency<T> createProviderDependency() {
    return StreamProviderDependency._(_controller.stream, this);
  }

  @override
  void initState() {
    _state = provider.value
      ..when(
        data: _controller.add,
        loading: () {},
        error: _controller.addError,
      );
  }

  @override
  void didUpdateProvider(_ValueStreamProvider<T> oldProvider) {
    super.didUpdateProvider(oldProvider);
    provider.value.when(
      data: (data) {
        _controller.add(data);
        state = provider.value;
      },
      loading: () {
        oldProvider.value.maybeWhen(
          loading: () {},
          orElse: () => throw UnsupportedError(
            'Once an overide was built with a data/error, it cannot revert to loading',
          ),
        );
      },
      error: (err, stack) {
        _controller.addError(err, stack);
        state = provider.value;
      },
    );
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }
}

/// Creates a [StreamProvider] from external parameters.
///
/// See also:
/// - [ProviderFamily], which contains an explanation of what a *Family is.
class StreamProviderFamily<Result, A>
    extends Family<StreamProvider<Result>, A> {
  /// Creates a [StreamProvider] from external parameters.
  StreamProviderFamily(
      Stream<Result> Function(ProviderReference ref, A a) create)
      : super((a) => StreamProvider((ref) => create(ref, a)));

  /// Overrides the behavior of a family for a part of the application.
  Override overrideAs(
    Stream<Result> Function(ProviderReference ref, A value) override,
  ) {
    return FamilyOverride(
      this,
      (value) => StreamProvider<Result>((ref) => override(ref, value as A)),
    );
  }
}
