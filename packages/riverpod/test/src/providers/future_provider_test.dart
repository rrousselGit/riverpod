import 'dart:async';

import 'package:async/async.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod/src/framework.dart';
import 'package:test/test.dart';

import '../../third_party/fake_async.dart';
import '../matrix.dart';
import '../utils.dart';

void main() {
  group('FutureProvider', () {
    test('Does not report AsyncValueIsLoadingException as uncaught', () async {
      final container = ProviderContainer.test();
      final completer = Completer<int>();
      addTearDown(completer.dispose);

      final dep = FutureProvider<int>((ref) => completer.future);
      final provider = FutureProvider<int>((ref) {
        return ref.watch(dep).requireValue * 2;
      });
      final provider2 = FutureProvider<int>((ref) async {
        return ref.watch(dep).requireValue * 2;
      });

      final sub = container.listen(provider.future, (previous, next) {});
      final sub2 = container.listen(provider2.future, (previous, next) {});

      expect(container.read(provider), const AsyncLoading<int>());
      expect(container.read(provider2), const AsyncLoading<int>());
      final future = sub.read();
      final future2 = sub2.read();

      completer.complete(42);
      await sub.read();
      await sub2.read();

      expect(container.read(provider), const AsyncData(84));
      expect(container.read(provider2), const AsyncData(84));

      await expectLater(future, completion(84));
      await expectLater(future2, completion(84));
    });

    group('.future', () {
      test(
        'throws if the provider is disposed when the last value emitted was AsyncValueIsLoadingException',
        () async {
          final container = ProviderContainer.test();

          final provider = FutureProvider<int>((ref) {
            return const AsyncLoading<int>().requireValue;
          });

          final sub = container.listen(provider.future, (previous, next) {});
          final future = sub.read()..ignore();

          container.dispose();

          await expectLater(future, throwsA(isStateError));
        },
      );
    });

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

    group('ref.isPaused', () {
      test('isPaused changes correctly during build', () async {
        final container = ProviderContainer.test();

        final completerStage1 = Completer<void>();
        final completerStage2 = Completer<void>();

        bool? refIsPaused;
        final provider = FutureProvider((ref) async {
          refIsPaused = ref.isPaused;
          await completerStage1.future;
          refIsPaused = ref.isPaused;
          await completerStage2.future;
          refIsPaused = ref.isPaused;
          return 0;
        });

        final sub = container.listen(provider, (previous, next) {});

        // before async gap
        expect(refIsPaused, false);

        sub.pause();
        completerStage1.complete();

        // create small async gap so riverpod can run the next step in the build
        await Future(() {});

        // after async gap and pausing of sub
        expect(refIsPaused, true);

        sub.resume();
        completerStage2.complete();

        // create small async gap so riverpod can run the next step in the build
        await Future(() {});

        // after async gap and resume
        expect(refIsPaused, false);
      });

      test('isPaused during async gap when consumed via read', () async {
        final container = ProviderContainer.test();
        final completer = Completer<void>();

        final provider = FutureProvider((ref) async {
          await completer.future;
          return ref.isPaused;
        });

        final future = container.read(provider.future);

        completer.complete();

        final refWasPaused = await future;

        // read does currently not keep an active subscription for the
        // duration of the build
        // (the subscription is closed before the first async gap)
        expect(refWasPaused, true);
      });
    });
  });
}
