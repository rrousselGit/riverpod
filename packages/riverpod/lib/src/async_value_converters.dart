import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';

import 'common.dart';
import 'framework.dart';
import 'internals.dart';

///
@protected
Stream<State> asyncValueToStream<State>(
  RootProvider<AsyncValue<State>> provider,
  ProviderElementBase<Stream<State>> ref,
) {
  StreamController<State>? controller;

  StreamController<State> getController() {
    if (controller == null) {
      // Using a non-broadcast controller followed by asBroadcastStream instead
      // of directly creating a broadcast controller so that `add`/`addError` calls
      // are queued. This ensures that listeners will properly receive the first value.
      controller = StreamController<State>();
      ref.state = controller!.stream.asBroadcastStream(
        onListen: (sub) => sub.resume(),
        onCancel: (sub) => sub.pause(),
      );
    }
    return controller!;
  }

  ref.onDispose(() => controller?.close());

  void listener(AsyncValue<State> value) {
    value.when(
      loading: () {
        controller?.close();
        controller = null;
        // will call ref.state =
        getController();
      },
      data: (data) => getController().add(data),
      error: (err, stack) => getController().addError(err, stack),
    );
  }

  ref.listen<AsyncValue<State>>(provider, listener, fireImmediately: true);

  return ref.state;
}

///
@protected
class AsyncValueAsFutureProvider<State>
    extends AlwaysAliveProviderBase<Future<State>> {
  ///
  AsyncValueAsFutureProvider(this._provider)
      : super(_provider.name == null ? null : '${_provider.name}.last');

  final AlwaysAliveProviderBase<AsyncValue<State>> _provider;

  @override
  Future<State> create(ProviderElementBase<Future<State>> ref) {
    return _asyncValueAsFuture(_provider, ref);
  }

  @override
  bool recreateShouldNotify(
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
  AutoDisposeAsyncValueAsFutureProvider(this._provider)
      : super(_provider.name == null ? null : '${_provider.name}.last');

  final AutoDisposeProviderBase<AsyncValue<State>> _provider;

  @override
  Future<State> create(AutoDisposeProviderElementBase<Future<State>> ref) {
    return _asyncValueAsFuture(_provider, ref);
  }

  @override
  bool recreateShouldNotify(
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
        StateError('The provider was disposed the stream could emit a value'),
      );
    }
  });

  void listener(AsyncValue<State> value) {
    value.when(
      loading: () {
        if (loadingCompleter == null) {
          loadingCompleter = Completer<State>();
          ref.state = loadingCompleter!.future;
        }
      },
      data: (data) {
        if (loadingCompleter != null) {
          loadingCompleter!.complete(data);
          // allow follow-up data calls to go on the 'else' branch
          loadingCompleter = null;
        } else {
          ref.state = Future<State>.value(data);
        }
      },
      error: (err, stack) {
        if (loadingCompleter != null) {
          loadingCompleter!.completeError(err, stack);
          // allow follow-up error calls to go on the 'else' branch
          loadingCompleter = null;
        } else {
          ref.state = Future<State>.error(err, stack);
        }
      },
    );
  }

  ref.listen<AsyncValue<State>>(provider, listener, fireImmediately: true);

  return ref.state;
}
