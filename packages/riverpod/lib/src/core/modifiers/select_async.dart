part of '../../framework.dart';

/// An internal class for `ProviderBase.selectAsync`.
final class _AsyncSelector<InputT, OutputT>
    implements ProviderListenable<Future<OutputT>> {
  /// An internal class for `ProviderBase.select`.
  _AsyncSelector({
    required this.provider,
    required this.future,
    required this.selector,
  });

  /// The provider that was selected
  final ProviderListenable<AsyncValue<InputT>> provider;

  /// The future associated to the listened provider
  final ProviderListenable<Future<InputT>> future;

  /// The selector applied
  final OutputT Function(InputT) selector;

  $Result<OutputT> _select(InputT value) {
    if (kDebugMode) _debugCallbackStack++;

    try {
      return $Result.data(selector(value));
    } catch (err, stack) {
      return $Result.error(err, stack);
    } finally {
      if (kDebugMode) _debugCallbackStack--;
    }
  }

  @override
  ProviderSubscriptionImpl<Future<OutputT>> _addListener(
    Node node,
    void Function(Future<OutputT>? previous, Future<OutputT> next) listener, {
    required void Function(Object error, StackTrace stackTrace) onError,
    required void Function()? onDependencyMayHaveChanged,
    required bool weak,
  }) {
    late final ExternalProviderSubscription<AsyncValue<InputT>, Future<OutputT>>
        providerSub;

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
    );

    playValue(
      // ignore: unused_result, https://github.com/dart-lang/sdk/issues/60831
      switch (sub.readSafe()) {
        $ResultData<AsyncValue<InputT>>() && final d => d.value,
        $ResultError<AsyncValue<InputT>>() && final d =>
          AsyncError(d.error, d.stackTrace),
      },
      callListeners: false,
    );

    return providerSub = ExternalProviderSubscription<AsyncValue<InputT>,
        Future<OutputT>>.fromSub(
      innerSubscription: sub,
      listener: listener,
      onError: onError,
      read: () {
        // Flush
        final result = sub.readSafe();
        if (result case $ResultError(:final error, :final stackTrace)) {
          return $Result.error(error, stackTrace);
        }

        return $ResultData(selectedFuture!);
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
          );

          // ignore: avoid_sub_read, We are handling errors
          sub.read().then((v) => _select(v).valueOrProviderException).then(
            (value) {
              // Avoid possible race condition
              if (!completer.isCompleted) completer.complete(value);
            },
            onError: (Object err, StackTrace stack) {
              // Avoid possible race condition
              if (!completer.isCompleted) completer.completeError(err, stack);
            },
          ).whenComplete(sub.close);
        }
      },
    );
  }
}
