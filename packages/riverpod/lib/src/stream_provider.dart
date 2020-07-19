import 'dart:async';

import 'builders.dart';
import 'common.dart' show AsyncValue;
import 'created_provider.dart';
import 'framework.dart';

part 'stream_provider/base.dart';
part 'stream_provider/auto_dispose.dart';

/// {@template riverpod.streamprovider}
/// Hello world
/// {@endtemplate}
mixin _StreamProviderStateMixin<T>
    on ProviderStateBase<Stream<T>, AsyncValue<T>> {
  StreamSubscription<T> sub;

  @override
  void valueChanged({Stream<T> previous}) {
    if (createdValue == previous) {
      return;
    }
    sub?.cancel();
    // TODO transition between state ??= vs =
    // TODO don't notify if already loading
    exposedValue = const AsyncValue.loading();
    sub = createdValue?.listen(
      (value) => exposedValue = AsyncValue.data(value),
      // ignore: avoid_types_on_closure_parameters
      onError: (Object error, StackTrace stack) {
        exposedValue = AsyncValue.error(error, stack);
      },
    );
  }

  @override
  void dispose() {
    sub?.cancel();
    super.dispose();
  }
}
