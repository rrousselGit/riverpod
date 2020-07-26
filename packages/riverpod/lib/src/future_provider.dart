import 'dart:async';

import 'builders.dart';
import 'common.dart' show AsyncValue;
import 'created_provider.dart';
import 'framework.dart';

part 'future_provider/base.dart';
part 'future_provider/auto_dispose.dart';

mixin _FutureProviderMixin<T> on ProviderBase<Future<T>, AsyncValue<T>> {
  @override
  Override overrideWithValue(AsyncValue<T> value) {
    return ProviderOverride(
      ValueProvider<Future<T>, AsyncValue<T>>((ref) {
        final completer = Completer<T>();
        ref.onChange = (newValue) {
          if (completer.isCompleted) {
            ref.markMustRecomputeState();
          } else {
            newValue.when(
              data: completer.complete,
              loading: () {},
              error: completer.completeError,
            );
          }
        };
        ref.onChange(value);
        return completer.future;
      }, value),
      this,
    );
  }
}

mixin _FutureProviderStateMixin<T>
    on ProviderStateBase<Future<T>, AsyncValue<T>> {
  // Used to determine if we are still listening to a future or not inside its `then`
  Future<T> listenedFuture;

  @override
  void valueChanged({Future<T> previous}) {
    if (createdValue == previous) {
      return;
    }
    // de-reference listenedFuture so that it is not changed by the time `then` completes.
    final listenedFuture = this.listenedFuture = createdValue;

    // TODO transition between state ??= vs =
    // TODO don't notify if already loading
    exposedValue = const AsyncValue.loading();
    listenedFuture?.then(
      (value) {
        if (this.listenedFuture == listenedFuture) {
          exposedValue = AsyncValue.data(value);
        }
      },
      // ignore: avoid_types_on_closure_parameters
      onError: (Object error, StackTrace stack) {
        if (this.listenedFuture == listenedFuture) {
          exposedValue = AsyncValue.error(error, stack);
        }
      },
    );
  }

  @override
  void dispose() {
    // Equivalent to StreamSubscription.cancel()
    listenedFuture = null;
    super.dispose();
  }
}
