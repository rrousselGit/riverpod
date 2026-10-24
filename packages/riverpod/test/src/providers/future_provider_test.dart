// ignore_for_file: avoid_types_on_closure_parameters

import 'dart:async';

import 'package:async/async.dart';
import 'package:mockito/mockito.dart';
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

      test(
        'On dispose, .future resolves with the future returned itself',
        () async {
          final container = ProviderContainer.test();
          final completer1 = Completer<int>.sync();
          final completer2 = Completer<int>.sync();
          var result = completer1.future;
          final provider = FutureProvider((ref) => result);

          expect(container.read(provider.future), completion(42));

          result = completer2.future;
          container.refresh(provider);

          container.dispose();

          completer2.complete(42);
        },
      );

      test('can refresh .future', () async {
        var future = Future.value(1);
        final provider = FutureProvider((ref) => future);
        final container = ProviderContainer.test();

        expect(await container.read(provider.future), 1);

        future = Future.value(42);

        expect(await container.refresh(provider.future), 42);
        expect(container.read(provider), const AsyncData(42));
      });

      test(
        '.future does not update dependents if the created future did not change',
        () async {
          final container = ProviderContainer.test();
          final dep = NotifierProvider(() => SettableNotifier((ref) => 0));
          final completer = Completer<int>();
          final provider = FutureProvider((ref) {
            ref.watch(dep);
            return completer.future;
          });
          final listener = Listener<Future<int>>();

          container.listen(
            provider.future,
            listener.call,
            fireImmediately: true,
          );

          verifyOnly(listener, listener(any, any));

          container.read(dep.notifier).state++;
          await container.pump();

          verifyNoMoreInteractions(listener);
        },
      );

      group('FutureProvider().future', () {
        test(
          '.future does not immediately notify listeners when adding a new listener '
          'to .future flushes the provider',
          () async {
            // Regression test for https://github.com/rrousselGit/riverpod/issues/2041

            final container = ProviderContainer.test();
            final onFuture = Listener<Future<int>>();

            final dep = FutureProvider((ref) => 0);
            final provider = Provider((ref) {
              ref.listen(dep.future, onFuture.call);
              return 0;
            });

            container.read(dep);
            container.invalidate(dep);

            container.read(provider);

            verifyZeroInteractions(onFuture);
          },
        );

        test('Does not throw assert _lastFuture != null '
            'nor rebuild a provider twice in the same frame', () async {
          // Regression test for https://github.com/rrousselGit/riverpod/issues/2041
          final container = ProviderContainer.test();

          final rootProvider = FutureProvider.autoDispose<int>(
            name: 'root',
            (ref) => 0,
          );
          // ProxyProvider is never rebuilt directly, but rather indirectly through
          // rootProvider. This means the scheduler does not naturally cover it.
          // Then testProvider is the one to trigger the rebuild by listening to it.
          final midProvider = FutureProvider.autoDispose<int>(
            name: 'mid',
            (ref) => ref.watch(rootProvider.future),
          );

          var buildCount = 0;
          final leafProvider = FutureProvider.autoDispose<int>(name: 'leaf', (
            ref,
          ) async {
            buildCount++;
            final future = ref.watch(midProvider.future);
            return (await future) + 2;
          });

          container.listen<AsyncValue<void>>(leafProvider, (previous, next) {
            if (!next.isLoading && next is AsyncError) {
              Zone.current.handleUncaughtError(next.error, next.stackTrace);
            }
          }, fireImmediately: true);

          final rootElement = container.readProviderElement(rootProvider);
          final midElement = container.readProviderElement(midProvider);
          final leafElement = container.readProviderElement(leafProvider);

          container.invalidate(rootProvider);
          container.invalidate(leafProvider);

          expect(buildCount, 1);

          await container.pump();

          expect(buildCount, 2);
        });

        test('does not update dependents when the future completes', () async {
          final completer = Completer<int>.sync();
          final provider = FutureProvider((_) => completer.future);
          final container = ProviderContainer.test();
          var callCount = 0;
          final dependent = Provider<Future<int>>((ref) {
            callCount++;
            return ref.watch(provider.future);
          });

          final sub = container.listen(dependent, (_, _) {});

          final future = sub.read();
          expect(callCount, 1);

          completer.complete(42);
          // just making sure the dependent isn't updated asynchronously
          await completer.future;
          await container.pump();

          expect(sub.read(), future);
          await expectLater(future, completion(42));
          expect(callCount, 1);
        });

        test('update dependents when the future changes', () async {
          final futureProvider = NotifierProvider(
            () => SettableNotifier((ref) => Future.value(42)),
          );
          // a FutureProvider that can rebuild with a new future
          final provider = FutureProvider<int>(
            (ref) => ref.watch(futureProvider),
          );
          var callCount = 0;
          final dependent = Provider<Future<int>>((ref) {
            callCount++;
            return ref.watch(provider.future);
          });
          final container = ProviderContainer.test();
          final futureController = container.read(futureProvider.notifier);

          await expectLater(container.read(dependent), completion(42));
          expect(callCount, 1);

          futureController.state = Future.value(21);

          await expectLater(container.read(dependent), completion(21));
          expect(callCount, 2);
        });
      });

      group('FutureProvider.autoDispose().future', () {
        test('update dependents when the future changes', () async {
          final futureProvider = NotifierProvider(
            () => SettableNotifier((ref) => Future.value(42)),
            name: 'futureProvider',
          );
          // a FutureProvider that can rebuild with a new future
          final provider = FutureProvider.autoDispose(
            name: 'provider',
            (ref) => ref.watch(futureProvider),
          );
          var callCount = 0;
          final dependent = Provider.autoDispose(name: 'dependent', (ref) {
            callCount++;
            return ref.watch(provider.future);
          });
          final container = ProviderContainer.test();

          final futureController = container.read(futureProvider.notifier);

          final sub = container.listen(dependent, (_, _) {});

          await expectLater(sub.read(), completion(42));
          expect(callCount, 1);

          futureController.state = Future.value(21);

          await expectLater(sub.read(), completion(21));
          expect(callCount, 2);
        });

        test('does not update dependents when the future completes', () async {
          final completer = Completer<int>.sync();
          final provider = FutureProvider.autoDispose((_) => completer.future);
          final container = ProviderContainer.test();
          var callCount = 0;
          final dependent = Provider.autoDispose((ref) {
            callCount++;
            return ref.watch(provider.future);
          });

          final sub = container.listen(dependent, (_, _) {});

          final future = sub.read();
          expect(callCount, 1);

          completer.complete(42);
          // just making sure the dependent isn't updated asynchronously
          await completer.future;
          await container.pump();

          expect(sub.read(), future);
          await expectLater(future, completion(42));
          expect(callCount, 1);
        });

        test('disposes the main provider when no longer used', () async {
          var didDispose = false;
          final provider = FutureProvider.autoDispose((ref) {
            ref.onDispose(() => didDispose = true);
            return Future.value(42);
          });
          final container = ProviderContainer.test();
          final sub = container.listen(provider.future, (_, _) {});

          expect(didDispose, false);

          await container.pump();
          expect(didDispose, false);

          sub.close();

          await container.pump();
          expect(didDispose, true);
        });
      });
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
            retry: (retryCount, _) {
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

    test('Supports void type', () async {
      // Regression test for https://github.com/rrousselGit/riverpod/issues/2028
      final testProvider = FutureProvider<void>((ref) async {
        return Future.value();
      });

      final container = ProviderContainer.test();
      expect(container.read(testProvider), const AsyncLoading<void>());

      await container.read(testProvider.future);

      expect(container.read(testProvider), const AsyncData<void>(null));
    });

    test('can return a value synchronously, bypassing AsyncLoading', () async {
      final provider = FutureProvider((ref) => 0);
      final container = ProviderContainer.test();

      expect(container.read(provider), const AsyncData(0));
      await expectLater(container.read(provider.future), completion(0));
    });

    test('can return an error synchronously, bypassing AsyncLoading', () async {
      final provider = FutureProvider((ref) => throw UnimplementedError());
      final container = ProviderContainer.test();

      expect(
        container.read(provider),
        isA<AsyncError<Never>>().having(
          (e) => e.error,
          'error',
          isUnimplementedError,
        ),
      );
      await expectLater(
        container.read(provider.future),
        throwsUnimplementedError,
      );
    });

    test('can be refreshed', () async {
      var result = 0;
      final container = ProviderContainer.test();
      final provider = FutureProvider((ref) => Future.value(result));

      expect(await container.read(provider.future), 0);
      expect(container.read(provider), const AsyncValue.data(0));

      result = 1;
      expect(
        container.refresh(provider),
        const AsyncLoading<int>().copyWithPrevious(
          const AsyncValue<int>.data(0),
        ),
      );

      expect(await container.read(provider.future), 1);
      expect(container.read(provider), const AsyncValue.data(1));
    });

    test(
      'does not update dependents if the created stream did not change',
      () async {
        final container = ProviderContainer.test();
        final dep = NotifierProvider(() => SettableNotifier((ref) => 0));
        final completer = Completer<int>();
        final provider = FutureProvider((ref) {
          ref.watch(dep);
          return completer.future;
        });
        final listener = Listener<AsyncValue<int>>();

        container.listen(provider, listener.call, fireImmediately: true);

        verifyOnly(listener, listener(null, const AsyncValue.loading()));

        container.read(dep.notifier).state++;
        await container.pump();

        verifyNoMoreInteractions(listener);
      },
    );

    test('throwing inside "create" result in an AsyncValue.error', () {
      final provider = FutureProvider<int>(
        // ignore: only_throw_errors
        (ref) => throw 42,
        retry: (_, _) => null,
      );
      final container = ProviderContainer.test();

      expect(
        container.read(provider),
        isA<AsyncError<int>>().having((s) => s.error, 'error', 42),
      );
    });

    test('can specify name', () {
      final provider = FutureProvider((_) async => 0, name: 'example');

      expect(provider.name, 'example');

      final provider2 = FutureProvider((_) async => 0);

      expect(provider2.name, isNull);
    });

    test('handle errors', () async {
      // ignore: only_throw_errors
      final provider = FutureProvider<int>((_) async => throw 42);
      final container = ProviderContainer.test();

      expect(container.read(provider), const AsyncValue<int>.loading());

      await container.pump();

      expect(
        container.read(provider),
        isA<AsyncValue<int>>().having((s) => s.error, 'error', 42),
      );
    });

    test('noop if fails after provider dispose', () async {
      // ignore: only_throw_errors
      final provider = FutureProvider<int>((_) async => throw 42);
      final container = ProviderContainer.test();

      expect(container.read(provider), const AsyncValue<int>.loading());

      container.dispose();
      await container.pump();

      // No errors are reported to the zone
    });

    test('read', () async {
      final container = ProviderContainer.test();
      final completer = Completer<int>.sync();
      final other = FutureProvider((_) => completer.future);
      final simple = Provider((_) => 21);

      final example = FutureProvider((ref) async {
        final otherValue = await ref.watch(other.future);

        return '${ref.watch(simple)} $otherValue';
      });

      final listener = Listener<AsyncValue<String>>();

      container.listen(example, listener.call, fireImmediately: true);

      verifyOnly(listener, listener(null, const AsyncValue<String>.loading()));
      completer.complete(42);

      await container.read(example.future);

      verifyOnly(
        listener,
        listener(const AsyncValue.loading(), const AsyncValue.data('21 42')),
      );
    });

    test('exposes data', () async {
      final container = ProviderContainer.test();
      final listener = Listener<AsyncValue<int>>();
      final completer = Completer<int>.sync();
      final provider = FutureProvider((_) => completer.future);

      container.listen(provider, listener.call, fireImmediately: true);

      verifyOnly(listener, listener(null, const AsyncValue.loading()));

      completer.complete(42);

      verifyOnly(
        listener,
        listener(const AsyncValue.loading(), const AsyncValue.data(42)),
      );

      await container.read(provider.future);

      verifyNoMoreInteractions(listener);
    });

    group('overrideWithValue', () {
      test('synchronously overrides the value', () {
        var callCount = 0;
        final provider = FutureProvider((ref) async {
          callCount++;
          return 0;
        });
        final container = ProviderContainer.test(
          overrides: [provider.overrideWithValue(const AsyncValue.data(42))],
        );

        addTearDown(container.dispose);

        final sub = container.listen(provider, (_, _) {});

        expect(callCount, 0);
        expect(sub.read(), const AsyncValue.data(42));
      });
    });

    group('overrideWith', () {
      test('supports overrideWith', () {
        final provider = FutureProvider<int>((ref) => 0);
        final autoDispose = FutureProvider.autoDispose<int>((ref) => 0);
        final container = ProviderContainer.test(
          overrides: [
            provider.overrideWith((ref) => 42),
            autoDispose.overrideWith((ref) => 84),
          ],
        );

        expect(container.read(provider).value, 42);
        expect(container.read(autoDispose).value, 84);
      });

      test('supports family overrideWith', () {
        final family = FutureProvider.family<String, int>(
          (ref, arg) => '0 $arg',
        );
        final autoDisposeFamily = FutureProvider.autoDispose
            .family<String, int>((ref, arg) => '0 $arg');
        final container = ProviderContainer.test(
          overrides: [
            family.overrideWith((ref, int arg) => '42 $arg'),
            autoDisposeFamily.overrideWith((ref, int arg) => '84 $arg'),
          ],
        );

        expect(container.read(family(10)).value, '42 10');
        expect(container.read(autoDisposeFamily(10)).value, '84 10');
      });
    });

    group('When going back to AsyncLoading', () {
      test(
        'provider.future resolves with the new data instead of the old future result',
        () async {
          final container = ProviderContainer.test();
          final completer1 = Completer<int>.sync();
          final completer2 = Completer<int>.sync();
          var result = completer1.future;
          final provider = FutureProvider((ref) => result);

          expect(container.read(provider.future), completion(42));

          result = completer2.future;
          container.refresh(provider);

          completer1.complete(21);

          expect(container.read(provider), const AsyncLoading<int>());

          completer2.complete(42);

          await expectLater(container.read(provider.future), completion(42));
        },
      );

      test(
        'sets isRefreshing to true if triggered by a ref.invalidate/ref.refresh',
        () async {
          final container = ProviderContainer.test();
          var count = 0;
          final provider = FutureProvider((ref) => Future.value(count++));

          await expectLater(container.read(provider.future), completion(0));
          expect(container.read(provider), const AsyncData(0));

          expect(
            container.refresh(provider),
            const AsyncLoading<int>().copyWithPrevious(const AsyncData(0)),
          );

          await expectLater(container.read(provider.future), completion(1));
          expect(container.read(provider), const AsyncData(1));

          container.invalidate(provider);

          expect(
            container.read(provider),
            const AsyncLoading<int>().copyWithPrevious(const AsyncData(1)),
          );
          await expectLater(container.read(provider.future), completion(2));
          expect(container.read(provider), const AsyncData(2));
        },
      );

      test(
        'does not set isRefreshing if triggered by a dependency change',
        () async {
          final container = ProviderContainer.test();
          final dep = NotifierProvider(() => SettableNotifier((ref) => 0));
          final provider = FutureProvider(
            (ref) => Future.value(ref.watch(dep)),
          );

          await expectLater(container.read(provider.future), completion(0));
          expect(container.read(provider), const AsyncData(0));

          container.read(dep.notifier).state++;
          expect(
            container.read(provider),
            const AsyncLoading<int>().copyWithPrevious(
              const AsyncData(0),
              isRefresh: false,
            ),
          );

          await expectLater(container.read(provider.future), completion(1));
          expect(container.read(provider), const AsyncData(1));
        },
      );

      test(
        'does not set isRefreshing if both triggered by a dependency change and ref.refresh',
        () async {
          final container = ProviderContainer.test();
          final dep = NotifierProvider(() => SettableNotifier((ref) => 0));
          final provider = FutureProvider(
            (ref) => Future.value(ref.watch(dep)),
          );

          container.listen(provider, (_, _) {});
          await expectLater(container.read(provider.future), completion(0));
          expect(container.read(provider), const AsyncData(0));

          container.read(dep.notifier).state++;
          expect(
            container.refresh(provider),
            const AsyncLoading<int>().copyWithPrevious(
              const AsyncData(0),
              isRefresh: false,
            ),
          );

          await expectLater(container.read(provider.future), completion(1));
          expect(container.read(provider), const AsyncData(1));
        },
      );
    });

    group('scoping', () {
      test('can be auto-scoped', () async {
        final dep = Provider((ref) => 0, dependencies: const []);
        final provider = FutureProvider(
          (ref) => ref.watch(dep),
          dependencies: [dep],
        );
        final root = ProviderContainer.test();
        final container = ProviderContainer.test(
          parent: root,
          overrides: [dep.overrideWithValue(42)],
        );

        expect(container.read(provider), const AsyncData(42));
        expect(container.read(provider.future), completion(42));

        expect(root.getAllProviderElements(), isEmpty);
      });

      group(
        'scoping an override overrides all the associated sub-providers',
        () {
          test('when passing the provider itself', () async {
            final provider = FutureProvider(
              (ref) async => 0,
              dependencies: const [],
            );
            final root = ProviderContainer.test();
            final container = ProviderContainer.test(
              parent: root,
              overrides: [provider],
            );

            expect(await container.read(provider.future), 0);
            expect(container.read(provider), const AsyncValue.data(0));
            expect(root.getAllProviderElementsInOrder(), isEmpty);
            expect(container.getAllProviderElementsInOrder(), [
              isA<ProviderElement>().having(
                (e) => e.origin,
                'origin',
                provider,
              ),
            ]);
          });

          test('when using provider.overrideWithValue', () async {
            final provider = FutureProvider(
              (ref) async => 0,
              dependencies: const [],
            );
            final root = ProviderContainer.test();
            final container = ProviderContainer.test(
              parent: root,
              overrides: [
                provider.overrideWithValue(const AsyncValue.data(42)),
              ],
            );

            expect(await container.read(provider.future), 42);
            expect(container.read(provider), const AsyncValue.data(42));
            expect(root.getAllProviderElementsInOrder(), isEmpty);
            expect(container.getAllProviderElementsInOrder(), [
              isA<ProviderElement>().having(
                (e) => e.origin,
                'origin',
                provider,
              ),
            ]);
          });

          test('when using provider.overrideWith', () async {
            final provider = FutureProvider(
              (ref) async => 0,
              dependencies: const [],
            );
            final root = ProviderContainer.test();
            final container = ProviderContainer.test(
              parent: root,
              overrides: [provider.overrideWith((ref) async => 42)],
            );

            expect(await container.read(provider.future), 42);
            expect(container.read(provider), const AsyncValue.data(42));
            expect(root.getAllProviderElementsInOrder(), isEmpty);
            expect(container.getAllProviderElementsInOrder(), [
              isA<ProviderElement>().having(
                (e) => e.origin,
                'origin',
                provider,
              ),
            ]);
          });
        },
      );
    });
  });

  group('FutureProvider.family', () {
    test('works', () async {
      final provider = FutureProvider.autoDispose.family<int, int>((ref, a) {
        return Future.value(a * 2);
      });
      final container = ProviderContainer.test();
      final listener = Listener<AsyncValue<int>>();

      container.listen(provider(21), listener.call, fireImmediately: true);

      verifyOnly(listener, listener(null, const AsyncValue.loading()));

      await container.pump();

      verifyOnly(
        listener,
        listener(const AsyncValue.loading(), const AsyncValue.data(42)),
      );
    });

    test('works', () async {
      final provider = FutureProvider.family<String, int>((ref, a) {
        return Future.value('$a');
      });
      final container = ProviderContainer.test();

      expect(container.read(provider(0)), const AsyncValue<String>.loading());

      await container.pump();

      expect(container.read(provider(0)), const AsyncValue<String>.data('0'));
    });

    group('scoping', () {
      group(
        'scoping an override overrides all the associated sub-providers',
        () {
          test('can be auto-scoped', () async {
            final dep = Provider((ref) => 0, dependencies: const []);
            final provider = FutureProvider.family.autoDispose<int, int>(
              (ref, i) => ref.watch(dep) + i,
              dependencies: [dep],
            );
            final root = ProviderContainer.test();
            final container = ProviderContainer.test(
              parent: root,
              overrides: [dep.overrideWithValue(42)],
            );

            expect(container.read(provider(10)), const AsyncData(52));
            expect(container.read(provider(10).future), completion(52));

            expect(root.getAllProviderElements(), isEmpty);
          });

          test('when using provider.overrideWith', () async {
            final provider = FutureProvider.autoDispose.family<int, int>(
              (ref, _) => 0,
              dependencies: const [],
            );
            final root = ProviderContainer.test();
            final container = ProviderContainer.test(
              parent: root,
              overrides: [provider.overrideWith((ref, value) => 42)],
            );

            expect(await container.read(provider(0).future), 42);
            expect(container.read(provider(0)), const AsyncData(42));
            expect(root.getAllProviderElementsInOrder(), isEmpty);
            expect(container.getAllProviderElementsInOrder(), [
              isA<ProviderElement>().having(
                (e) => e.origin,
                'origin',
                provider(0),
              ),
            ]);
          });

          test('when passing the provider itself', () async {
            final provider = FutureProvider.family<int, int>(
              (ref, _) async => 0,
              dependencies: const [],
            );
            final root = ProviderContainer.test();
            final container = ProviderContainer.test(
              parent: root,
              overrides: [provider],
            );

            expect(await container.read(provider(0).future), 0);
            expect(container.read(provider(0)), const AsyncData(0));
            expect(container.getAllProviderElementsInOrder(), [
              isA<ProviderElement>().having(
                (e) => e.origin,
                'origin',
                provider(0),
              ),
            ]);
            expect(root.getAllProviderElementsInOrder(), isEmpty);
          });

          test('can be auto-scoped', () async {
            final dep = Provider((ref) => 0, dependencies: const []);
            final provider = FutureProvider.family<int, int>(
              (ref, i) => ref.watch(dep) + i,
              dependencies: [dep],
            );
            final root = ProviderContainer.test();
            final container = ProviderContainer.test(
              parent: root,
              overrides: [dep.overrideWithValue(42)],
            );

            expect(container.read(provider(10)), const AsyncData(52));
            expect(container.read(provider(10).future), completion(52));

            expect(root.getAllProviderElements(), isEmpty);
          });

          test('when using provider.overrideWith', () async {
            final provider = FutureProvider.family<int, int>(
              (ref, _) async => 0,
              dependencies: const [],
            );
            final root = ProviderContainer.test();
            final container = ProviderContainer.test(
              parent: root,
              overrides: [provider.overrideWith((ref, value) async => 42)],
            );

            expect(await container.read(provider(0).future), 42);
            expect(container.read(provider(0)), const AsyncData(42));
            expect(root.getAllProviderElementsInOrder(), isEmpty);
            expect(container.getAllProviderElementsInOrder(), [
              isA<ProviderElement>().having(
                (e) => e.origin,
                'origin',
                provider(0),
              ),
            ]);
          });
        },
      );
    });
  });

  group('FutureProvider.autoDispose', () {
    test('can be auto-scoped', () async {
      final dep = Provider((ref) => 0, dependencies: const []);
      final provider = FutureProvider.autoDispose(
        (ref) => ref.watch(dep),
        dependencies: [dep],
      );
      final root = ProviderContainer.test();
      final container = ProviderContainer.test(
        parent: root,
        overrides: [dep.overrideWithValue(42)],
      );

      expect(container.read(provider), const AsyncData(42));
      expect(container.read(provider.future), completion(42));

      expect(root.getAllProviderElements(), isEmpty);
    });

    test('can return a value synchronously, bypassing AsyncLoading', () async {
      final provider = FutureProvider.autoDispose((ref) => 0);
      final container = ProviderContainer.test();

      container.listen(provider, (_, _) {});

      expect(container.read(provider), const AsyncData(0));
      await expectLater(container.read(provider.future), completion(0));
    });

    test('can return an error synchronously, bypassing AsyncLoading', () async {
      final provider = FutureProvider.autoDispose(
        (ref) => throw UnimplementedError(),
      );
      final container = ProviderContainer.test();

      expect(
        container.read(provider),
        isA<AsyncError<Never>>().having(
          (e) => e.error,
          'error',
          isUnimplementedError,
        ),
      );
      await expectLater(
        container.read(provider.future),
        throwsUnimplementedError,
      );
    });

    test(
      'when going from AsyncLoading to AsyncLoading, does not notify listeners',
      () async {
        final dep = NotifierProvider(
          () => SettableNotifier((ref) => Future.value(42)),
        );
        final provider = FutureProvider.autoDispose((ref) => ref.watch(dep));
        final container = ProviderContainer.test();
        final listener = Listener<AsyncValue<int>>();

        container.listen(provider, (prev, value) {});

        await expectLater(container.read(provider.future), completion(42));
        expect(container.read(provider), const AsyncData<int>(42));

        final completer = Completer<int>();
        container.read(dep.notifier).state = completer.future;

        container.listen(provider, listener.call, fireImmediately: true);

        verifyOnly(
          listener,
          listener(
            null,
            const AsyncLoading<int>().copyWithPrevious(
              const AsyncData(42),
              isRefresh: false,
            ),
          ),
        );

        container.read(dep.notifier).state = Future.value(21);

        verifyNoMoreInteractions(listener);

        await expectLater(container.read(provider.future), completion(21));
        expect(container.read(provider), const AsyncData<int>(21));
      },
    );

    test('can refresh .future', () async {
      var future = Future.value(1);
      final provider = FutureProvider.autoDispose((ref) => future);
      final container = ProviderContainer.test();

      container.listen(provider.future, (prev, value) {});

      expect(await container.read(provider.future), 1);

      future = Future.value(42);

      expect(await container.refresh(provider.future), 42);
      expect(container.read(provider), const AsyncData(42));
    });

    test('can be refreshed', () async {
      var result = 0;
      final container = ProviderContainer.test();
      final provider = FutureProvider.autoDispose(
        (ref) => Future.value(result),
      );

      container.listen(provider, (prev, value) {});

      expect(await container.read(provider.future), 0);
      expect(container.read(provider), const AsyncValue.data(0));

      result = 1;
      expect(
        container.refresh(provider),
        const AsyncLoading<int>().copyWithPrevious(
          const AsyncValue<int>.data(0),
        ),
      );

      expect(await container.read(provider.future), 1);
      expect(container.read(provider), const AsyncValue.data(1));
    });

    test(
      'does not update dependents if the created stream did not change',
      () async {
        final container = ProviderContainer.test();
        final dep = NotifierProvider(() => SettableNotifier((ref) => 0));
        final completer = Completer<int>();
        final provider = FutureProvider.autoDispose((ref) {
          ref.watch(dep);
          return completer.future;
        });
        final listener = Listener<AsyncValue<int>>();

        container.listen(provider, listener.call, fireImmediately: true);

        verifyOnly(listener, listener(null, const AsyncValue.loading()));

        container.read(dep.notifier).state++;
        await container.pump();

        verifyNoMoreInteractions(listener);
      },
    );

    test(
      '.stream does not update dependents if the created stream did not change',
      () async {
        final container = ProviderContainer.test();
        final dep = NotifierProvider(() => SettableNotifier((ref) => 0));
        final completer = Completer<int>();
        final provider = FutureProvider.autoDispose((ref) {
          ref.watch(dep);
          return completer.future;
        });
        final listener = Listener<Future<int>>();

        container.listen(provider.future, listener.call, fireImmediately: true);

        verifyOnly(listener, listener(any, any));

        container.read(dep.notifier).state++;
        await container.pump();

        verifyNoMoreInteractions(listener);

        // No value were emitted, so the future will fail. Catching the error to
        // avoid false positive.
        // ignore: unawaited_futures
        container.read(provider.future).catchError((Object _) => 0);
      },
    );

    test('FutureProvider.autoDispose', () async {
      var future = Future.value(42);
      final onDispose = OnDisposeMock();
      final provider = FutureProvider.autoDispose((ref) {
        ref.onDispose(onDispose.call);
        return future;
      });
      final container = ProviderContainer.test();
      final listener = Listener<AsyncValue<int>>();

      final sub = container.listen(
        provider,
        listener.call,
        fireImmediately: true,
      );

      verifyOnly(listener, listener(null, const AsyncValue.loading()));

      sub.close();
      await container.pump();

      verifyOnly(onDispose, onDispose());

      future = Future.value(21);

      container.listen(provider, listener.call, fireImmediately: true);

      verifyOnly(listener, listener(null, const AsyncValue.loading()));

      await container.pump();

      verifyOnly(
        listener,
        listener(const AsyncValue.loading(), const AsyncValue.data(21)),
      );
    });

    group('scoping', () {
      group(
        'scoping an override overrides all the associated sub-providers',
        () {
          test('when passing the provider itself', () async {
            final provider = FutureProvider.autoDispose(
              (ref) async => 0,
              dependencies: const [],
            );
            final root = ProviderContainer.test();
            final container = ProviderContainer.test(
              parent: root,
              overrides: [provider],
            );

            expect(await container.read(provider.future), 0);
            expect(container.read(provider), const AsyncValue.data(0));
            expect(root.getAllProviderElementsInOrder(), isEmpty);
            expect(container.getAllProviderElementsInOrder(), [
              isA<ProviderElement>().having(
                (e) => e.origin,
                'origin',
                provider,
              ),
            ]);
          });

          test('when using provider.overrideWithValue', () async {
            final provider = FutureProvider.autoDispose(
              (ref) async => 0,
              dependencies: const [],
            );
            final root = ProviderContainer.test();
            final container = ProviderContainer.test(
              parent: root,
              overrides: [
                provider.overrideWithValue(const AsyncValue.data(42)),
              ],
            );

            expect(await container.read(provider.future), 42);
            expect(container.read(provider), const AsyncValue.data(42));
            expect(root.getAllProviderElementsInOrder(), isEmpty);
            expect(container.getAllProviderElementsInOrder(), [
              isA<ProviderElement>().having(
                (e) => e.origin,
                'origin',
                provider,
              ),
            ]);
          });

          test('when using provider.overrideWith', () async {
            final provider = FutureProvider.autoDispose(
              (ref) async => 0,
              dependencies: const [],
            );
            final root = ProviderContainer.test();
            final container = ProviderContainer.test(
              parent: root,
              overrides: [provider.overrideWith((ref) => 42)],
            );

            expect(await container.read(provider.future), 42);
            expect(container.read(provider), const AsyncValue.data(42));
            expect(root.getAllProviderElementsInOrder(), isEmpty);
            expect(container.getAllProviderElementsInOrder(), [
              isA<ProviderElement>().having(
                (e) => e.origin,
                'origin',
                provider,
              ),
            ]);
          });
        },
      );
    });
  });
}
