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

  ref.onDispose(() => controller?.close());

  void listener(AsyncValue<State> value) {
    value.when(
      loading: () {
        controller?.close();
        controller = StreamController();
        ref.state = controller!.stream;
      },
      data: (data) => controller!.add(data),
      error: (err, stack) => controller!.addError(err, stack),
    );
  }

  ref.listen<AsyncValue<State>>(provider, listener, fireImmediately: true);

  return ref.state;
}

///
@protected
class AsyncValueAsFutureProvider<State>
    extends AutoDisposeProviderBase<Future<State>> {
  ///
  AsyncValueAsFutureProvider(this._provider)
      : super(_provider.name == null ? null : '${_provider.name}.last');

  final RootProvider<AsyncValue<State>> _provider;

  @override
  Future<State> create(AutoDisposeProviderElementBase<Future<State>> ref) {
    if (_provider is AlwaysAliveProviderBase) {
      // TODO(rrousselGit) refactor
      ref.maintainState = true;
    }

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

    ref.listen<AsyncValue<State>>(_provider, listener, fireImmediately: true);

    return ref.state;
  }

  @override
  AutoDisposeProviderElement<Future<State>> createElement() {
    return AutoDisposeProviderElement(this);
  }
}
