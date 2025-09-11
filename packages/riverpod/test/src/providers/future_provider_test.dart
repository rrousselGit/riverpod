import 'dart:async';

import 'package:async/async.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod/src/framework.dart';
import 'package:test/test.dart';

import '../../third_party/fake_async.dart';
import '../matrix.dart';

void main() {
  group('FutureProvider', () {
    group('retry', () {
      test(
        'handles retry',
        () => fakeAsync((fake) async {
          final container = ProviderContainer.test();
          final controller = StreamController<AsyncValue<int>>();
          addTearDown(controller.close);
          final queue = StreamQueue(controller.stream);
          addTearDown(queue.cancel);

          Object? err;
          final stack = StackTrace.current;
          final provider = AsyncNotifierProvider<AsyncNotifier<int>, int>(
            () => DeferredAsyncNotifier((ref, self) {
              if (err == null) return 42;
              Error.throwWithStackTrace(err, stack);
            }),
            retry: (retryCount, __) {
              if (retryCount >= 2) return null;

              return const Duration(seconds: 1);
            },
          );

          final sub = container.listen(provider, fireImmediately: true, (_, b) {
            controller.add(b);
          });
          await queue.next;

          err = Exception('foo');
          container.invalidate(provider);
          fake.elapse(const Duration(microseconds: 50));
          await queue.next;

          AsyncValue<int> value = sub.read() as AsyncLoading<int>;
          expect(
            value.error,
            isException.having((e) => '$e', 'toString', 'Exception: foo'),
          );
          expect(value.stackTrace, stack);
          expect(value.value, 42);
          expect(value.isLoading, true);
          expect(value.retrying, true);
          expect(value.valueFilled!.source, DataSource.liveOrRefresh);

          err = Exception('bar');
          fake.elapse(const Duration(seconds: 1));
          fake.flushMicrotasks();

          await queue.next;

          value = sub.read() as AsyncLoading<int>;
          expect(
            value.error,
            isException.having((e) => '$e', 'toString', 'Exception: bar'),
          );
          expect(value.stackTrace, stack);
          expect(value.value, 42);
          expect(value.isLoading, true);
          expect(value.retrying, true);
          expect(value.valueFilled!.source, DataSource.liveOrRefresh);

          err = Exception('baz');
          fake.elapse(const Duration(seconds: 1));
          fake.flushMicrotasks();

          await queue.next;

          value = sub.read() as AsyncError<int>;
          expect(
            value.error,
            isException.having((e) => '$e', 'toString', 'Exception: baz'),
          );
          expect(value.stackTrace, stack);
          expect(value.isLoading, false);
          expect(value.value, 42);
          expect(value.retrying, false);
          expect(value.valueFilled!.source, DataSource.liveOrRefresh);
        }),
      );
    });
  });
}
