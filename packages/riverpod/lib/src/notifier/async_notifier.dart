part of '../notifier.dart';

abstract class AsyncNotifier<State> extends _NotifierBase<AsyncValue<State>> {
  Ref<AsyncValue<State>> get ref => _element;

  @visibleForOverriding
  FutureOr<State> init();

  Future<State> future() {
    Future<State> onLoading() {
      final completer = Completer<State>();
      late ProviderSubscription sub;

      sub = ref.listenSelf((previous, next) {
        // Takes care of refresh
        if (next.isLoading) return;

        sub.close();
        next.whenOrNull(
          data: completer.complete,
          error: completer.completeError,
          // loading handled above
        );
      });
      return completer.future;
    }

    final state = this.state;
    if (state.isLoading) {
      return onLoading();
    }

    return state.map(
      data: (d) => Future.value(d.value),
      error: (e) => Future.error(e.error, e.stackTrace),
      loading: (_) => onLoading(),
    );
  }

  FutureOr<State> update(
    FutureOr<State> Function(State) cb, {
    FutureOr<State> Function(State)? onError,
  }) {
    return future().then(cb, onError: onError);
  }
}

class AsyncNotifierProvider<Controller extends AsyncNotifier<State>, State>
    extends ProviderBase<AsyncValue<State>> {
  AsyncNotifierProvider(
    this._createNotifier, {
    String? name,
    this.dependencies,
    Family? from,
    Object? argument,
  }) : super(name: name, from: from, argument: argument);

  final Controller Function() _createNotifier;

  final List<ProviderOrFamily>? dependencies;

  @override
  AsyncValue<State> create(
    covariant AsyncNotifierProviderElement<Controller, State> ref,
  ) {
    final notifier = ref.notifier = _createNotifier().._element = ref;

    return listenFuture(ref, notifier.init);
  }

  @override
  AsyncNotifierProviderElement<Controller, State> createElement() {
    return AsyncNotifierProviderElement<Controller, State>(this);
  }

  @override
  bool updateShouldNotify(
    AsyncValue<State> previousState,
    AsyncValue<State> newState,
  ) {
    return identical(previousState, newState);
  }
}

class AsyncNotifierProviderElement<Controller extends AsyncNotifier<State>,
    State> extends ProviderElementBase<AsyncValue<State>> {
  AsyncNotifierProviderElement(
    AsyncNotifierProvider<Controller, State> provider,
    // TODO test "create notifier fail"
  ) : super(provider);

  late Controller notifier;
}
