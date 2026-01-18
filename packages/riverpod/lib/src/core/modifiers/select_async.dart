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
    late final ExternalProviderSubscription<Future<InputT>, Future<OutputT>>
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
      StackTrace stack, {
      required bool callListeners,
    }) {
      final error = ProviderException(err, stack);
      final previousFuture = selectedFuture;
      if (selectedCompleter != null) {
        selectedCompleter!.completeError(error, stack);
        selectedCompleter = null;
      } else {
        selectedFuture = Future.error(error, stack);
        if (callListeners) {
          providerSub._notifyData(previousFuture, selectedFuture!);
        }
      }
    }

    Future<InputT> listenedFuture;
    void playValue(Future<InputT> newFuture, {bool callListeners = true}) {
      void onLoading() {
        if (selectedFuture == null) {
          // The first time a future is emitted

          selectedCompleter = Completer();
          selectedFuture = selectedCompleter!.future;
        }

        // We don't notify listeners when the future changes since
        // they want to filter rebuilds based on the result
      }

      onLoading();

      listenedFuture = newFuture;
      listenedFuture.then(
        (value) {
          // A new future has been emitted since, ignore
          if (listenedFuture != newFuture) return;

          final newSelectedValue = _select(value);
          switch (newSelectedValue) {
            case $ResultData():
              if (newSelectedValue != lastSelectedValue) {
                emitData(newSelectedValue.value, callListeners: callListeners);
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
        onError: (Object err, StackTrace stack) {
          // A new future has been emitted since, ignore
          if (listenedFuture != newFuture) return;
          emitError(err, stack, callListeners: callListeners);

          // Error in the provider, it should've already been propagated
          // so no need to pollute the stack
          selectedFuture!.ignore();
        },
      );
    }

    final sub = future._addListener(
      node,
      (prev, input) => playValue(input),
      weak: weak,
      onDependencyMayHaveChanged: onDependencyMayHaveChanged,
      onError: onError,
    );

    playValue(switch (sub.readSafe()) {
      $ResultData<Future<InputT>>() && final d => d.value,
      $ResultError<Future<InputT>>() && final d => Future.error(
        d.error,
        d.stackTrace,
      )..ignore(),
    }, callListeners: false);

    return providerSub =
        ExternalProviderSubscription<Future<InputT>, Future<OutputT>>.fromSub(
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
            // final completer = selectedCompleter;
            // if (completer != null && !completer.isCompleted) {
            //   final sub = switch (node) {
            //     ProviderElement() => node.listen(
            //       future,
            //       (prev, next) {},
            //       onError: onError,
            //     ),
            //     ProviderContainer() => node.listen(
            //       future,
            //       (prev, next) {},
            //       onError: onError,
            //     ),
            //   };

            //   // ignore: internal_lint/avoid_sub_read, We are handling errors
            //   sub
            //       .read()
            //       .then((v) => _select(v).valueOrProviderException)
            //       .then(
            //         (value) {
            //           // Avoid possible race condition
            //           if (!completer.isCompleted) completer.complete(value);
            //         },
            //         onError: (Object err, StackTrace stack) {
            //           // Avoid possible race condition
            //           if (!completer.isCompleted) {
            //             completer.completeError(err, stack);
            //           }
            //         },
            //       )
            //       .whenComplete(sub.close);
            // }
          },
        );
  }
}
