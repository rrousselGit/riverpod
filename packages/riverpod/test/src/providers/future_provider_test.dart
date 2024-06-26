import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

import '../../third_party/fake_async.dart';
import '../utils.dart';

void main() {
  group('FutureProvider', () {
    test('resets progress to 0 if restarting while the future is pending', () {
      final container = ProviderContainer.test();
      late Ref<AsyncValue<int>> ref;
      final completer = Completer<int>();
      addTearDown(() => completer.complete(42));

      final provider = FutureProvider<int>((r) {
        ref = r;
        return completer.future;
      });

      expect(container.read(provider), const AsyncValue<int>.loading());

      ref.state = const AsyncValue.loading(progress: .2);

      container.refresh(provider);

      expect(container.read(provider), const AsyncValue<int>.loading());
    });

    group('retry', () {
      test(
        'handles retry',
        () => fakeAsync((fake) async {
          final container = ProviderContainer.test();
          var err = Exception('foo');
          final stack = StackTrace.current;
          final provider = FutureProvider<int>(
            (ref) => Error.throwWithStackTrace(err, stack),
            retry: (_, __) => const Duration(seconds: 1),
          );
          final listener = Listener<AsyncValue<int>>();

          container.listen(provider, fireImmediately: true, listener.call);
          await container.read(provider.future).sync.catchError((e) => 0);

          verifyOnly(
            listener,
            listener(any, AsyncValue<int>.error(err, stack)),
          );

          err = Exception('bar');

          fake.elapse(const Duration(seconds: 1));
          fake.flushMicrotasks();

          await container.read(provider.future).sync.catchError((e) => 0);

          verifyOnly(
            listener,
            listener(any, AsyncValue<int>.error(err, stack)),
          );
        }),
      );

      test(
        'manually setting the state to an error does not cause a retry',
        () => fakeAsync((fake) async {
          final container = ProviderContainer.test();
          var retryCount = 0;
          late Ref<AsyncValue<int>> r;
          final provider = FutureProvider<int>(
            (ref) {
              r = ref;
              return 0;
            },
            retry: (_, __) {
              retryCount++;
              return const Duration(seconds: 1);
            },
          );
          final listener = Listener<AsyncValue<int>>();

          container.listen(provider, fireImmediately: true, listener.call);

          expect(retryCount, 0);

          r.state = AsyncValue<int>.error(Error(), StackTrace.current);

          expect(retryCount, 0);
        }),
      );
    });
  });
}
