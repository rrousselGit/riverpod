import 'dart:async';

import 'package:meta/meta.dart';

import 'internals.dart';

///
@protected
class AsyncValueAsStreamProvider<State>
    extends AlwaysAliveProviderBase<Stream<State>> {
  ///
  AsyncValueAsStreamProvider(this._provider, {required String? name})
      : super(name: name);

  final AlwaysAliveProviderBase<AsyncValue<State>> _provider;

  @override
  late final List<ProviderOrFamily>? dependencies = [_provider];

  @override
  Stream<State> create(covariant ProviderElementBase<Stream<State>> ref) {
    return _asyncValueToStream(_provider, ref);
  }

  @override
  ProviderElement<Stream<State>> createElement() {
    return ProviderElement(this);
  }

  @override
  bool updateShouldNotify(
    Stream<State> previousState,
    Stream<State> newState,
  ) {
    return true;
  }
}

///
@protected
class AutoDisposeAsyncValueAsStreamProvider<State>
    extends AutoDisposeProviderBase<Stream<State>> {
  ///
  AutoDisposeAsyncValueAsStreamProvider(this._provider, {required String? name})
      : super(name: name);

  final AutoDisposeProviderBase<AsyncValue<State>> _provider;

  @override
  late final List<ProviderOrFamily>? dependencies = [_provider];

  @override
  Stream<State> create(
      covariant AutoDisposeProviderElementBase<Stream<State>> ref) {
    return _asyncValueToStream(_provider, ref);
  }

  @override
  AutoDisposeProviderElement<Stream<State>> createElement() {
    return AutoDisposeProviderElement(this);
  }

  @override
  bool updateShouldNotify(
    Stream<State> previousState,
    Stream<State> newState,
  ) {
    return true;
  }
}

Stream<State> _asyncValueToStream<State>(
  ProviderBase<AsyncValue<State>> provider,
  ProviderElementBase<Stream<State>> ref,
) {
  StreamController<State>? controller;

  StreamController<State> getController() {
    if (controller == null) {
      // Using a non-broadcast controller followed by asBroadcastStream instead
      // of directly creating a broadcast controller so that `add`/`addError` calls
      // are queued. This ensures that listeners will properly receive the first value.
      controller = StreamController<State>();
      ref.setState(
        controller!.stream.asBroadcastStream(
          onListen: (sub) => sub.resume(),
          onCancel: (sub) => sub.pause(),
        ),
      );
    }
    return controller!;
  }

  ref.onDispose(() => controller?.close());

  void listener(AsyncValue<State>? previous, AsyncValue<State> value) {
    value.when(
      loading: (_) {
        controller?.close();
        controller = null;
        // will call ref.state =
        getController();
      },
      data: (data) => getController().add(data),
      error: (err, stack, _) => getController().addError(err, stack),
    );
  }

  ref.listen<AsyncValue<State>>(provider, listener, fireImmediately: true);

  return ref.getState()!;
}

///
@protected
class AsyncValueAsFutureProvider<State>
    extends AlwaysAliveProviderBase<Future<State>> {
  ///
  AsyncValueAsFutureProvider(this._provider, {required String? name})
      : super(name: name);

  final AlwaysAliveProviderBase<AsyncValue<State>> _provider;

  @override
  late final List<ProviderOrFamily>? dependencies = [_provider];

  @override
  Future<State> create(ProviderElementBase<Future<State>> ref) {
    return _asyncValueAsFuture(_provider, ref);
  }

  @override
  bool updateShouldNotify(
    Future<State> previousState,
    Future<State> newState,
  ) {
    return true;
  }

  @override
  ProviderElement<Future<State>> createElement() {
    return ProviderElement(this);
  }
}

///
@protected
class AutoDisposeAsyncValueAsFutureProvider<State>
    extends AutoDisposeProviderBase<Future<State>> {
  ///
  AutoDisposeAsyncValueAsFutureProvider(this._provider, {required String? name})
      : super(name: name);

  final AutoDisposeProviderBase<AsyncValue<State>> _provider;

  @override
  late final List<ProviderOrFamily>? dependencies = [_provider];

  @override
  Future<State> create(AutoDisposeProviderElementBase<Future<State>> ref) {
    return _asyncValueAsFuture(_provider, ref);
  }

  @override
  bool updateShouldNotify(
    Future<State> previousState,
    Future<State> newState,
  ) {
    return true;
  }

  @override
  AutoDisposeProviderElement<Future<State>> createElement() {
    return AutoDisposeProviderElement(this);
  }
}

Future<State> _asyncValueAsFuture<State>(
  ProviderBase<AsyncValue<State>> provider,
  ProviderElementBase<Future<State>> ref,
) {
  Completer<State>? loadingCompleter;

  ref.onDispose(() {
    if (loadingCompleter != null) {
      loadingCompleter!.completeError(
        StateError(
          'The provider $provider was disposed before a value was emitted.',
        ),
      );
    }
  });

  void listener(AsyncValue<State>? previous, AsyncValue<State> value) {
    value.when(
      loading: (_) {
        if (loadingCompleter == null) {
          loadingCompleter = Completer<State>();
          ref.setState(
            // TODO test ignore
            loadingCompleter!.future..ignore(),
          );
        }
      },
      data: (data) {
        if (loadingCompleter != null) {
          loadingCompleter!.complete(data);
          // allow follow-up data calls to go on the 'else' branch
          loadingCompleter = null;
        } else {
          ref.setState(Future<State>.value(data));
        }
      },
      error: (err, stack, _) {
        if (loadingCompleter != null) {
          loadingCompleter!.completeError(err, stack);
          // allow follow-up error calls to go on the 'else' branch
          loadingCompleter = null;
        } else {
          ref.setState(Future<State>.error(err, stack));
        }
      },
    );
  }

  ref.listen<AsyncValue<State>>(provider, listener, fireImmediately: true);

  return ref.getState()!;
}
