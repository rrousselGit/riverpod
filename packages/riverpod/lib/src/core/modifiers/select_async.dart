part of '../../framework.dart';

/// An internal class for `ProviderBase.selectAsync`.
final class _AsyncSelector<InputT, OutputT, OriginT>
    with
        ProviderListenable<Future<OutputT>>,
        ProviderListenableWithOrigin<Future<OutputT>, OriginT> {
  /// An internal class for `ProviderBase.select`.
  _AsyncSelector({
    required this.provider,
    required this.future,
    required this.selector,
  });

  /// The provider that was selected
  final ProviderListenableWithOrigin<AsyncValue<InputT>, OriginT> provider;

  /// The future associated to the listened provider
  final ProviderListenableWithOrigin<Future<InputT>, OriginT> future;

  /// The selector applied
  final OutputT Function(InputT) selector;

  $Result<OutputT> _select(InputT value) {
    if (kDebugMode) _debugIsRunningSelector = true;

    try {
      return $Result.data(selector(value));
    } catch (err, stack) {
      return $Result.error(err, stack);
    } finally {
      if (kDebugMode) _debugIsRunningSelector = false;
    }
  }

  @override
  ProviderSubscriptionWithOrigin<Future<OutputT>, OriginT> _addListener(
    Node node,
    void Function(Future<OutputT>? previous, Future<OutputT> next) listener, {
    required void Function(Object error, StackTrace stackTrace)? onError,
    required void Function()? onDependencyMayHaveChanged,
    required bool fireImmediately,
    required bool weak,
  }) {
    late final ProviderSubscriptionView<Future<OutputT>, OriginT> providerSub;

    $Result<OutputT>? lastSelectedValue;
    Completer<OutputT>? selectedCompleter;
    Future<OutputT>? selectedFuture;

    void emitData(OutputT data, {required bool callListeners}) {
      final previousFuture = selectedFuture;
      if (selectedCompleter != null) {
        selectedCompleter!.complete(data);
        selectedCompleter = null;
      } else {
        selectedFuture = Future.value(data);
        if (callListeners) {
          providerSub._notifyData(previousFuture, selectedFuture!);
        }
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
        if (callListeners) {
          providerSub._notifyData(previousFuture, selectedFuture!);
        }
      }
    }

    void playValue(
      AsyncValue<InputT> value, {
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
          switch (newSelectedValue) {
            case $ResultData():
              if (newSelectedValue != lastSelectedValue) {
                emitData(
                  newSelectedValue.value,
                  callListeners: callListeners,
                );
              }
            case $ResultError():
              emitError(
                newSelectedValue.error,
                newSelectedValue.stackTrace,
                callListeners: callListeners,
              );
          }

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

    final sub = provider._addListener(
      node,
      (prev, input) => playValue(input),
      weak: weak,
      onDependencyMayHaveChanged: onDependencyMayHaveChanged,
      onError: onError,
      fireImmediately: false,
    );

    playValue(sub.read(), callListeners: false);

    if (fireImmediately) {
      listener(null, selectedFuture!);
    }

    return providerSub = ProviderSubscriptionView<Future<OutputT>, OriginT>(
      innerSubscription: sub,
      listener: listener,
      onError: onError,
      read: () {
        // Flush
        sub.read();
        return selectedFuture!;
      },
      onClose: () {
        final completer = selectedCompleter;
        if (completer != null && !completer.isCompleted) {
          final sub = future._addListener(
            node,
            (prev, next) {},
            weak: weak,
            onDependencyMayHaveChanged: () {},
            onError: onError,
            fireImmediately: false,
          );

          sub
              .read()
              .then((v) => _select(v).requireState)
              .then(completer.complete, onError: completer.completeError)
              .whenComplete(sub.close);
        }
      },
    );
  }
}
