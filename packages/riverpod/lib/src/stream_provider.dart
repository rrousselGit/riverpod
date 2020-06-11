import 'dart:async';

import 'common.dart';
import 'framework/framework.dart';

class StreamProviderSubscription<T> extends ProviderSubscriptionBase {
  StreamProviderSubscription._(this.stream, this._state);

  final Stream<T> stream;
  final _State<T, ProviderBase<StreamProviderSubscription<T>, AsyncValue<T>>>
      _state;

  Future<T> get currentData => _state.currentData;
}

mixin _State<T,
        P extends ProviderBase<StreamProviderSubscription<T>, AsyncValue<T>>>
    on ProviderStateBase<StreamProviderSubscription<T>, AsyncValue<T>, P> {
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

class StreamProvider<T>
    extends AlwaysAliveProvider<StreamProviderSubscription<T>, AsyncValue<T>> {
  StreamProvider(this._create, {String name}) : super(name);

  final Create<Stream<T>, ProviderReference> _create;

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
    StreamProviderSubscription<T>,
    AsyncValue<T>,
    StreamProvider<T>> with _State<T, StreamProvider<T>> {
  Stream<T> _stream;
  StreamSubscription<T> _streamSubscription;

  @override
  StreamProviderSubscription<T> createProviderSubscription() {
    return StreamProviderSubscription._(_stream, this);
  }

  @override
  void initState() {
    _stream = provider._create(ProviderReference(this));
    _streamSubscription = _stream.listen(
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
    _streamSubscription.cancel();
    super.dispose();
  }
}

class _ValueStreamProvider<T>
    extends AlwaysAliveProvider<StreamProviderSubscription<T>, AsyncValue<T>> {
  _ValueStreamProvider(this.value, {String name}) : super(name);

  final AsyncValue<T> value;

  @override
  _ValueStreamProviderState<T> createState() {
    return _ValueStreamProviderState<T>();
  }
}

class _ValueStreamProviderState<T> extends ProviderStateBase<
    StreamProviderSubscription<T>,
    AsyncValue<T>,
    _ValueStreamProvider<T>> with _State<T, _ValueStreamProvider<T>> {
  final _controller = StreamController<T>();

  @override
  StreamProviderSubscription<T> createProviderSubscription() {
    return StreamProviderSubscription._(_controller.stream, this);
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
