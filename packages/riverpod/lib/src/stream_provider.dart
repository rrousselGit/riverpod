import 'dart:async';

import 'common.dart';
import 'framework/framework.dart';

class StreamProviderSubscription<T> extends ProviderBaseSubscription {
  StreamProviderSubscription._(this.stream);

  final Stream<T> stream;
}

class StreamProvider<T>
    extends AlwaysAliveProvider<StreamProviderSubscription<T>, AsyncValue<T>> {
  StreamProvider(this._create);

  final Create<Stream<T>, ProviderReference> _create;

  ProviderOverride<StreamProviderSubscription<T>, AsyncValue<T>>
      overrideWithValue(AsyncValue<T> value) {
    return overrideForSubtree(_ValueStreamProvider(value));
  }

  @override
  _StreamProviderState<T> createState() {
    return _StreamProviderState<T>();
  }
}

class _StreamProviderState<T> extends ProviderBaseState<
    StreamProviderSubscription<T>, AsyncValue<T>, StreamProvider<T>> {
  Stream<T> _stream;
  StreamSubscription<T> _streamSubscription;

  AsyncValue<T> _state;
  @override
  AsyncValue<T> get state => _state;
  set state(AsyncValue<T> state) {
    _state = state;
    markNeedsNotifyListeners();
  }

  @override
  StreamProviderSubscription<T> createProviderSubscription() {
    return StreamProviderSubscription._(_stream);
  }

  @override
  void initState() {
    _state = const AsyncValue.loading();
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
  _ValueStreamProvider(this.value);

  final AsyncValue<T> value;

  @override
  _ValueStreamProviderState<T> createState() {
    return _ValueStreamProviderState<T>();
  }
}

class _ValueStreamProviderState<T> extends ProviderBaseState<
    StreamProviderSubscription<T>, AsyncValue<T>, _ValueStreamProvider<T>> {
  final _controller = StreamController<T>();

  @override
  StreamProviderSubscription<T> createProviderSubscription() {
    return StreamProviderSubscription._(_controller.stream);
  }

  AsyncValue<T> _state;
  @override
  AsyncValue<T> get state => _state;
  set state(AsyncValue<T> state) {
    _state = state;
    markNeedsNotifyListeners();
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
    if (provider.value == AsyncValue<T>.loading()) {
      oldProvider.value.maybeWhen(
        loading: () {},
        orElse: () => throw UnsupportedError(
          'Once an overide was built with a data/error, its state cannot change',
        ),
      );
    }
    state = provider.value
      ..when(
        data: _controller.add,
        loading: () {},
        error: _controller.addError,
      );
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }
}
