import 'dart:async';

import 'common.dart';
import 'framework/framework.dart';

/// The state of a [StreamProvider].
class StreamProviderDependency<T> extends ProviderDependencyBase {
  StreamProviderDependency._(this.stream, this._state);

  /// The stream returned by [StreamProvider].
  final Stream<T> stream;
  final _State<T, ProviderBase<StreamProviderDependency<T>, AsyncValue<T>>>
      _state;

  /// The last value emitted by [stream].
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

/// Creates a stream and expose its latest event.
///
/// Consumers of [StreamProvider] will receive an [AsyncValue] instead of the
/// raw value emitted.
/// This is so that dependents can handle loading/error states.
class StreamProvider<T>
    extends AlwaysAliveProvider<StreamProviderDependency<T>, AsyncValue<T>> {
  /// Creates a [StreamProvider] and allows specifying a [name].
  StreamProvider(this._create, {String name}) : super(name);

  final Create<Stream<T>, ProviderReference> _create;

  /// A test utility to override a [StreamProvider] with a synchronous value.
  ///
  /// Overriding a [StreamProvider] with an [AsyncValue.data]/[AsyncValue.error]
  /// bypass the loading step that most streams have, which simplifies the test.
  ///
  /// It is possible to change the state emitted by changing the override
  /// on [ProviderStateOwner]/`ProviderScope`.
  ///
  /// Once an [AsyncValue.data]/[AsyncValue.error] was emitted, it is no longer
  /// possible to emit a [AsyncValue.loading].
  ///
  /// This will create a made up [Stream] for [StreamProviderDependency.stream].
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

class _StreamProviderState<T> extends ProviderStateBase<
    StreamProviderDependency<T>,
    AsyncValue<T>,
    StreamProvider<T>> with _State<T, StreamProvider<T>> {
  Stream<T> _stream;
  StreamSubscription<T> _streamDependency;

  @override
  StreamProviderDependency<T> createProviderDependency() {
    return StreamProviderDependency._(_stream, this);
  }

  @override
  void initState() {
    _stream = provider._create(ProviderReference(this));
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

/// Overide a [StreamProvider] with a synchronous value.
class _ValueStreamProvider<T>
    extends AlwaysAliveProvider<StreamProviderDependency<T>, AsyncValue<T>> {
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

class StreamProviderFamily<Result, A>
    extends Family<StreamProvider<Result>, A> {
  StreamProviderFamily(
      Stream<Result> Function(ProviderReference ref, A a) create)
      : super((a) => StreamProvider((ref) => create(ref, a)));

  /// Overrides the behavior of a family for a part of the application.
  FamilyOverride overrideAs(
    Stream<Result> Function(ProviderReference ref, A value) override,
  ) {
    return FamilyOverride(
      this,
      (value) => StreamProvider<Result>((ref) => override(ref, value as A)),
    );
  }
}
