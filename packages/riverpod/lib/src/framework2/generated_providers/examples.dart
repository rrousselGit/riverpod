import 'dart:async';

import 'package:meta/meta.dart';
import 'package:riverpod/src/framework2/generated_providers/future_provider.dart';

import '../framework.dart';
import 'sync_provider.dart';

part 'examples.g.dart';

const riverpod = Object();

@riverpod
int syncExample(Ref ref) => 42;

@riverpod
int syncExample2(Ref ref, {int? arg = 42}) {
  return 42;
}

// TODO
// extension<T> on FutureOr<T> {
//   Future<T> get sync {
//     final that = this;
//     if (that is Future<T>) {
//       return that;
//     } else {
//       return SynchronousFuture(that);
//     }
//   }
// }
// extension<T> on Future<T> {
//   @Deprecated(
//     'Do not use "sync" on a Future. Either use a "FutureOr", or remove the "sync".',
//   )
//   Never get sync => throw UnsupportedError(
//         'Do not use "sync" on a Future. Either use a "FutureOr", or remove the "sync".',
//       );
// }

// TODO
// extension<T> on Ref<T> {
//   /// A custom "return" keyword that enables synchronous value emit.
//   ///
//   /// Works by throwing an exception, which is caught and silenced by Riverpod.
//   Never returnData(T value);

//   /// A custom "yield" keyword that enables synchronous value emit.
//   ///
//   /// The returned future typically completes immediately.
//   /// But on paused providers, it will complete when the provider is resumed.
//   ///
//   /// This enables pausing asynchronous work.
//   FutureOr<void> emitData(T value) => state = value;
// }

@riverpod
FutureOr<int> asyncExample(Ref<int> ref) async {
  // "syncFuture" returns a SynchronousFuture from Flutter.
  // This enables "await" to be synchronous.
  // It unfortunately cannot be the default, due to SynchronousFuture not working
  // with certain APIs (such as Future.wait)
  // Riverpod_lint could have a warning to suggest using ".syncFuture" instead of ".future"
  // when using "await".
  final value = await ref.watch(asyncExampleProvider.syncFuture);

  return value;

  // final stream = Stream<int>.periodic(const Duration(seconds: 1), (i) => i);
  // // An example of iterating over a stream that supports pausing.
  // // If the widget listening to this stream stops being visible, this loop would pause.
  // // This would work thanks to "emitData" awaiting for the provider to be resumed.
  // await for (final value in stream) {
  //   print('value: $value');
  //   await ref.emitData(value);
  // }

  // // Instead of "return 42", we use a custom "returnData" method.
  // // This achieves the same result, but bypasses Future's asynchronous nature.
  // ref.returnData(42);
}

// @riverpod
// class SyncExampleNotifier extends _$SyncExampleNotifier {
//   @override
//   int build(Ref<int> ref) => syncExample(ref);
// }

// @riverpod
// class ScopedSyncExampleNotifier extends _$ScopedSyncExampleNotifier {
//   @override
//   int build(Ref<int> ref);
// }
