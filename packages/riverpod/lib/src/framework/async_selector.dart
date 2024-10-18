part of '../framework.dart';

/// Adds [selectAsync] to [ProviderListenable]
@internal
mixin AsyncSelector<Input> on ProviderListenable<AsyncValue<Input>> {
  /// The future that [selectAsync] will query
  Refreshable<Future<Input>> get future;

  /// {@template riverpod.async_select}
  /// A variant of [select] for asynchronous values
  ///
  /// [selectAsync] is useful for filtering rebuilds of a provider
  /// when it depends on asynchronous values, which we want to await.
  ///
  /// A common use-case would be to combine [selectAsync] with
  /// [FutureProvider] to perform an async operation, where that
  /// async operation depends on the result of another async operation.
  ///
  ///
  /// ```dart
  /// // A provider which asynchronously loads configurations,
  /// // which may change over time.
  /// final configsProvider = StreamProvider<Config>((ref) async {
  ///   // TO-DO fetch the configurations, such as by using Firebase
  /// });
  ///
  /// // A provider which fetches a list of products based on the configurations
  /// final productsProvider = FutureProvider<List>((ref) async {
  ///   // We obtain the host from the configs, while ignoring changes to
  ///   // other properties. As such, the productsProvider will rebuild only
  ///   // if the host changes
  ///   final host = await ref.watch(configsProvider.selectAsync((config) => config.host));
  ///
  ///   return http.get('$host/products');
  /// });
  /// ```
  /// {@endtemplate}
  ProviderListenable<Future<Output>> selectAsync<Output>(
    Output Function(Input data) selector,
  ) {
    return _AlwaysAliveAsyncSelector(
      selector: selector,
      provider: this,
      future: future,
    );
  }
}

// ignore: deprecated_member_use_from_same_package
/// Adds [selectAsync] to [AlwaysAliveProviderListenable]
@internal
mixin AlwaysAliveAsyncSelector<Input>
    // ignore: deprecated_member_use_from_same_package
    on AlwaysAliveProviderListenable<AsyncValue<Input>> {
  /// The future that [selectAsync] will query
  // ignore: deprecated_member_use_from_same_package
  AlwaysAliveRefreshable<Future<Input>> get future;

  /// {@macro riverpod.async_select}
  // ignore: deprecated_member_use_from_same_package
  AlwaysAliveProviderListenable<Future<Output>> selectAsync<Output>(
    Output Function(Input data) selector,
  ) {
    return _AlwaysAliveAsyncSelector(
      selector: selector,
      provider: this,
      future: future,
    );
  }
}

class _AlwaysAliveAsyncSelector<Input, Output>
    extends _AsyncSelector<Input, Output>
    with
        // ignore: deprecated_member_use_from_same_package
        AlwaysAliveProviderListenable<Future<Output>> {
  _AlwaysAliveAsyncSelector({
    required super.provider,
    required super.future,
    required super.selector,
  });
}

/// An internal class for `ProviderBase.selectAsync`.
@sealed
class _AsyncSelector<Input, Output> with ProviderListenable<Future<Output>> {
  /// An internal class for `ProviderBase.select`.
  _AsyncSelector({
    required this.provider,
    required this.future,
    required this.selector,
  });

  /// The provider that was selected
  final ProviderListenable<AsyncValue<Input>> provider;

  /// The future associated to the listened provider
  final ProviderListenable<Future<Input>> future;

  /// The selector applied
  final Output Function(Input) selector;

  Result<Output> _select(Input value) {
    assert(
      () {
        _debugIsRunningSelector = true;
        return true;
      }(),
      '',
    );

    try {
      return Result.data(selector(value));
    } catch (err, stack) {
      return Result.error(err, stack);
    } finally {
      assert(
        () {
          _debugIsRunningSelector = false;
          return true;
        }(),
        '',
      );
    }
  }

  @override
  _SelectorSubscription<AsyncValue<Input>, Future<Output>> addListener(
    Node node,
    void Function(Future<Output>? previous, Future<Output> next) listener, {
    required void Function(Object error, StackTrace stackTrace)? onError,
    required void Function()? onDependencyMayHaveChanged,
    required bool fireImmediately,
  }) {
    Result<Output>? lastSelectedValue;
    Completer<Output>? selectedCompleter;
    Future<Output>? selectedFuture;

    void emitData(Output data, {required bool callListeners}) {
      final previousFuture = selectedFuture;
      if (selectedCompleter != null) {
        selectedCompleter!.complete(data);
        selectedCompleter = null;
      } else {
        selectedFuture = Future.value(data);
        if (callListeners) listener(previousFuture, selectedFuture!);
      }
    }

    void emitError(
      Object err,
      StackTrace? stack, {
      required bool callListeners,
    }) {
      final previousFuture = selectedFuture;
      if (selectedCompleter != null) {
        selectedCompleter!.completeError(err, stack);
        selectedCompleter = null;
      } else {
        selectedFuture = Future.error(err, stack);
        if (callListeners) listener(previousFuture, selectedFuture!);
      }
    }

    void playValue(
      AsyncValue<Input> value, {
      bool callListeners = true,
    }) {
      void onLoading(AsyncValue<void> loading) {
        if (selectedFuture == null) {
          // The first time a future is emitted

          selectedCompleter = Completer();
          selectedFuture = selectedCompleter!.future;
        }

        // We don't notify listeners when the future changes since
        // they want to filter rebuilds based on the result
      }

      value.map(
        loading: onLoading,
        data: (value) {
          if (value.isRefreshing) {
            onLoading(value);
            return;
          }

          final newSelectedValue = _select(value.value);

          newSelectedValue.map(
            data: (newSelectedValue) {
              if (newSelectedValue != lastSelectedValue) {
                emitData(
                  newSelectedValue.state,
                  callListeners: callListeners,
                );
              }
            },
            error: (newSelectedValue) {
              emitError(
                newSelectedValue.error,
                newSelectedValue.stackTrace,
                callListeners: callListeners,
              );
            },
          );

          lastSelectedValue = newSelectedValue;
        },
        error: (value) {
          if (value.isRefreshing) {
            onLoading(value);
            return;
          }

          emitError(
            value.error,
            value.stackTrace,
            callListeners: callListeners,
          );

          // Error in the provider, it should've already been propagated
          // so no need to pollute the stack
          selectedFuture!.ignore();
        },
      );
    }

    final sub = node.listen<AsyncValue<Input>>(
      provider,
      (prev, input) => playValue(input),
      onError: onError,
    );

    playValue(sub.read(), callListeners: false);

    if (fireImmediately) {
      listener(null, selectedFuture!);
    }

    return _SelectorSubscription(
      node,
      sub,
      () => selectedFuture!,
      onClose: () {
        final completer = selectedCompleter;
        if (completer != null && !completer.isCompleted) {
          read(node).then(
            completer.complete,
            onError: completer.completeError,
          );
        }
      },
    );
  }

  @override
  Future<Output> read(Node node) => future.read(node).then(selector);
}
