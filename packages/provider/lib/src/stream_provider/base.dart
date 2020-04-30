part of 'stream_provider.dart';

mixin _StreamProviderMixin<T> implements StreamProvider<T> {
  @override
  ProviderOverride<StreamProviderValue<T>, AsyncValue<T>> overrideWithValue(
    AsyncValue<T> value,
  ) {
    return overrideForSubtree(_ValueStreamProvider(value));
  }
}

class _StreamProvider<T>
    extends BaseProvider<StreamProviderValue<T>, AsyncValue<T>>
    with _StreamProviderMixin<T> {
  _StreamProvider(this.create);

  final Create<Stream<T>, ProviderState> create;

  @override
  _StreamProviderState<T> createState() {
    return _StreamProviderState<T>();
  }
}

class _StreamProviderState<T> extends BaseProviderState<StreamProviderValue<T>,
    AsyncValue<T>, _StreamProvider<T>> {
  Stream<T> _stream;
  StreamSubscription<T> _streamSubscription;

  @override
  StreamProviderValue<T> createProviderState() {
    return StreamProviderValue._(_stream);
  }

  @override
  AsyncValue<T> initState() {
    _stream = provider.create(ProviderState(this));
    _streamSubscription = _stream.listen(
      (event) {
        $state = AsyncValue.data(event);
      },
      onError: (
        dynamic err,
        // ignore: avoid_types_on_closure_parameters
        StackTrace stack,
      ) {
        $state = AsyncValue.error(err, stack);
      },
    );
    return const AsyncValue.loading();
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }
}

class _ValueStreamProvider<T>
    extends BaseProvider<StreamProviderValue<T>, AsyncValue<T>>
    with _StreamProviderMixin<T> {
  _ValueStreamProvider(this.value);

  final AsyncValue<T> value;

  @override
  _ValueStreamProviderState<T> createState() {
    return _ValueStreamProviderState<T>();
  }
}

class _ValueStreamProviderState<T> extends BaseProviderState<
    StreamProviderValue<T>, AsyncValue<T>, _ValueStreamProvider<T>> {
  final _controller = StreamController<T>();

  @override
  StreamProviderValue<T> createProviderState() {
    return StreamProviderValue._(_controller.stream);
  }

  @override
  AsyncValue<T> initState() {
    return provider.value
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
    $state = provider.value
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
