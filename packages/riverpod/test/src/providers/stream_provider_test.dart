import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod/src/internals.dart'
    show InternalProviderContainer, ProviderElement;
import 'package:test/test.dart';

import '../utils.dart';

void main() {
  group('StreamProvider', () {
    test(
      'when going from AsyncLoading to AsyncLoading, does not notify listeners',
      () async {
        final dep = NotifierProvider(
          () => SettableNotifier((ref) => Stream.value(42)),
        );
        final provider = StreamProvider((ref) => ref.watch(dep));
        final container = ProviderContainer.test();
        final listener = Listener<AsyncValue<int>>();
        final controller = StreamController<int>();
        addTearDown(controller.close);

        container.listen(provider, (p, n) {});
        await expectLater(container.read(provider.future), completion(42));
        expect(container.read(provider), const AsyncData<int>(42));

        container.read(dep.notifier).state = controller.stream;
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

        container.read(dep.notifier).state = Stream.value(21);

        verifyNoMoreInteractions(listener);

        await expectLater(container.read(provider.future), completion(21));
        expect(container.read(provider), const AsyncData<int>(21));
      },
    );

    test('can be refreshed', () async {
      var result = 0;
      final container = ProviderContainer.test();
      final provider = StreamProvider((ref) => Stream.value(result));

      container.listen(provider, (p, n) {});
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

    test('Loading to data', () {
      final container = ProviderContainer.test();
      final controller = StreamController<int>(sync: true);
      addTearDown(() => controller.close);
      final provider = StreamProvider((ref) => controller.stream);

      container.listen(provider, (p, n) {});

      expect(container.read(provider), const AsyncValue<int>.loading());

      controller.add(42);

      expect(container.read(provider), const AsyncValue<int>.data(42));
    });

    test('Loading to error', () {
      final container = ProviderContainer.test(retry: (_, _) => null);
      final controller = StreamController<int>(sync: true);
      addTearDown(() => controller.close);
      final provider = StreamProvider((ref) => controller.stream);

      container.listen(provider, (p, n) {});

      expect(container.read(provider), const AsyncValue<int>.loading());

      final stack = StackTrace.current;
      controller.addError(42, stack);

      expect(container.read(provider), AsyncValue<int>.error(42, stack));
    });

    test('does not filter identical values', () async {
      final container = ProviderContainer.test();
      final controller = StreamController<int>(sync: true);
      addTearDown(() => controller.close);
      final provider = StreamProvider((ref) => controller.stream);

      final sub = container.listen(provider, (_, _) {});

      expect(sub.read(), const AsyncValue<int>.loading());

      controller.add(42);
      await container.pump();

      expect(sub.read(), const AsyncValue<int>.data(42));

      controller.add(42);
      await container.pump();

      expect(sub.read(), const AsyncValue<int>.data(42));
    });

    test('throwing inside "create" result in an AsyncValue.error', () {
      final container = ProviderContainer.test();

      final provider = StreamProvider<int>(
        (ref) => throw 42,
        retry: (_, _) => null,
      );

      expect(
        container.read(provider),
        isA<AsyncError<int>>().having((s) => s.error, 'error', 42),
      );
    });

    test(
      'does not update dependents if the created stream did not change',
      () async {
        final container = ProviderContainer.test();

        final dep = NotifierProvider(() => SettableNotifier((ref) => 0));
        final provider = StreamProvider((ref) {
          ref.watch(dep);
          return const Stream<int>.empty();
        });
        final listener = Listener<AsyncValue<int>>();

        container.listen(provider, listener.call, fireImmediately: true);

        verifyOnly(listener, listener(null, const AsyncValue.loading()));

        container.read(dep.notifier).state++;
        await container.pump();

        verifyNoMoreInteractions(listener);
      },
    );

    test('can specify name', () {
      final provider = StreamProvider(
        (_) => const Stream<int>.empty(),
        name: 'example',
      );

      expect(provider.name, 'example');

      final provider2 = StreamProvider((_) => const Stream<int>.empty());

      expect(provider2.name, isNull);
    });

    test(
      'subscribe exposes loading synchronously then value on change',
      () async {
        final container = ProviderContainer.test();
        final controller = StreamController<int>(sync: true);
        final provider = StreamProvider((_) => controller.stream);
        final listener = Listener<AsyncValue<int>>();

        container.listen(provider, listener.call, fireImmediately: true);

        verifyOnly(listener, listener(null, const AsyncValue<int>.loading()));

        controller.add(42);

        verifyOnly(
          listener,
          listener(const AsyncValue.loading(), const AsyncValue<int>.data(42)),
        );

        controller.add(21);

        verifyOnly(
          listener,
          listener(const AsyncValue.data(42), const AsyncValue<int>.data(21)),
        );

        await controller.close();
      },
    );

    test('errors', () async {
      final container = ProviderContainer.test();
      final controller = StreamController<int>(sync: true);
      final provider = StreamProvider((_) => controller.stream);
      final listener = Listener<AsyncValue<int>>();
      final error = Error();
      final stack = StackTrace.current;

      container.listen(provider, listener.call, fireImmediately: true);

      verifyOnly(listener, listener(null, const AsyncValue<int>.loading()));

      controller.addError(error, stack);

      verifyOnly(
        listener,
        listener(
          const AsyncValue.loading(),
          AsyncValue<int>.error(error, stack),
        ),
      );

      controller.add(21);

      verifyOnly(
        listener,
        listener(
          AsyncError<int>(error, stack),
          const AsyncValue.data(21).copyWithPrevious(AsyncError(error, stack)),
        ),
      );

      await controller.close();
    });

    test('stops subscription', () async {
      final container = ProviderContainer.test();
      final controller = StreamController<int>(sync: true);
      final dispose = OnDisposeMock();
      final provider = StreamProvider((ref) {
        ref.onDispose(dispose.call);
        return controller.stream;
      });
      final listener = Listener<AsyncValue<int>>();

      container.listen(provider, listener.call, fireImmediately: true);

      verifyOnly(listener, listener(null, const AsyncValue<int>.loading()));

      controller.add(42);

      verifyOnly(
        listener,
        listener(const AsyncValue.loading(), const AsyncValue<int>.data(42)),
      );
      verifyNoMoreInteractions(dispose);

      container.dispose();

      verify(dispose()).called(1);
      verifyNoMoreInteractions(dispose);

      // if the listener wasn't removed, this would throw because markNeedsNotifyListeners
      // cannot be called once the provider was disposed.
      controller.add(21);

      await controller.close();
    });

    group('overrideWith', () {
      test('supports overrideWith', () {
        final provider = StreamProvider<int>((ref) => Stream.value(1));
        final autoDispose = StreamProvider.autoDispose<int>(
          (ref) => Stream.value(1),
        );
        final container = ProviderContainer.test(
          overrides: [
            provider.overrideWith((ref) => Stream.value(42)),
            autoDispose.overrideWith((ref) => Stream.value(84)),
          ],
        );

        expect(
          container.listen(provider.future, (a, b) {}).read(),
          completion(42),
        );
        expect(
          container.listen(autoDispose.future, (a, b) {}).read(),
          completion(84),
        );
      });

      test('supports family overrideWith', () {
        final family = StreamProvider.family<String, int>((ref, arg) {
          return Stream.value('0 $arg');
        });
        final autoDisposeFamily = StreamProvider.autoDispose
            .family<String, int>((ref, arg) => Stream.value('0 $arg'));
        final container = ProviderContainer.test(
          overrides: [
            family.overrideWith((ref, int arg) => Stream.value('42 $arg')),
            autoDisposeFamily.overrideWith(
              (ref, int arg) => Stream.value('84 $arg'),
            ),
          ],
        );

        expect(
          container.listen(family(10).future, (a, b) {}).read(),
          completion('42 10'),
        );
        expect(
          container.listen(autoDisposeFamily(10).future, (a, b) {}).read(),
          completion('84 10'),
        );
      });
    });

    group('When going back to AsyncLoading', () {
      test(
        'sets isRefreshing to true if triggered by a ref.invalidate/ref.refresh',
        () async {
          final container = ProviderContainer.test();
          var count = 0;
          final provider = StreamProvider((ref) => Stream.value(count++));

          container.listen(provider, (p, n) {});

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
          final provider = StreamProvider(
            (ref) => Stream.value(ref.watch(dep)),
          );

          container.listen(provider, (p, n) {});

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
          final provider = StreamProvider(
            (ref) => Stream.value(ref.watch(dep)),
          );

          container.listen(provider, (p, n) {});

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
        final provider = StreamProvider(
          (ref) => Stream.value(ref.watch(dep)),
          dependencies: [dep],
        );
        final root = ProviderContainer.test();
        final container = ProviderContainer.test(
          parent: root,
          overrides: [dep.overrideWithValue(42)],
        );

        container.listen(provider, (p, n) {});
        await expectLater(container.read(provider.future), completion(42));
        expect(container.read(provider), const AsyncData(42));

        expect(root.getAllProviderElements(), isEmpty);
      });

      group(
        'scoping an override overrides all the associated sub-providers',
        () {
          test('when passing the provider itself', () async {
            final provider = StreamProvider(
              (ref) => Stream.value(0),
              dependencies: const [],
            );
            final root = ProviderContainer.test();
            final container = ProviderContainer.test(
              parent: root,
              overrides: [provider],
            );

            container.listen(provider, (p, n) {});
            expect(await container.read(provider.future), 0);
            expect(container.read(provider), const AsyncValue.data(0));
            expect(root.getAllProviderElements(), isEmpty);
            expect(
              container.getAllProviderElements(),
              unorderedEquals(<Object?>[
                isA<ProviderElement>().having(
                  (e) => e.origin,
                  'origin',
                  provider,
                ),
              ]),
            );
          });

          test('when using provider.overrideWithValue', () async {
            final provider = StreamProvider(
              (ref) => Stream.value(0),
              dependencies: const [],
            );
            final root = ProviderContainer.test();
            final container = ProviderContainer.test(
              parent: root,
              overrides: [
                provider.overrideWithValue(const AsyncValue.data(42)),
              ],
            );

            container.listen(provider, (p, n) {});
            expect(await container.read(provider.future), 42);
            expect(container.read(provider), const AsyncValue.data(42));
            expect(root.getAllProviderElements(), isEmpty);
            expect(
              container.getAllProviderElements(),
              unorderedEquals(<Object?>[
                isA<ProviderElement>().having(
                  (e) => e.origin,
                  'origin',
                  provider,
                ),
              ]),
            );
          });

          test('when using provider.overrideWith', () async {
            final provider = StreamProvider(
              (ref) => Stream.value(0),
              dependencies: const [],
            );
            final root = ProviderContainer.test();
            final container = ProviderContainer.test(
              parent: root,
              overrides: [provider.overrideWith((ref) => Stream.value(42))],
            );

            container.listen(provider, (p, n) {});
            expect(await container.read(provider.future), 42);
            expect(container.read(provider), const AsyncValue.data(42));
            expect(root.getAllProviderElements(), isEmpty);
            expect(
              container.getAllProviderElements(),
              unorderedEquals(<Object?>[
                isA<ProviderElement>().having(
                  (e) => e.origin,
                  'origin',
                  provider,
                ),
              ]),
            );
          });
        },
      );
    });

    group('.future', () {
      test(
        '.future does not update dependents if the created future did not change',
        () async {
          final container = ProviderContainer.test();

          final dep = NotifierProvider(() => SettableNotifier((ref) => 0));

          final provider = StreamProvider((ref) {
            ref.watch(dep);
            return const Stream<int>.empty();
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

          // No value were emitted, so the future will fail. Catching the error to
          // avoid false positive.
          unawaited(
            container.read(provider.future).catchError((Object _) => 0),
          );
        },
      );

      group('from StreamProvider', () {
        test('read currentValue before first value', () async {
          final container = ProviderContainer.test();
          final controller = StreamController<int>();
          final provider = StreamProvider<int>((_) => controller.stream);

          container.listen(provider, (p, n) {});
          final future = container.read(provider.future);

          controller.add(42);

          await expectLater(future, completion(42));

          await controller.close();
        });

        test('read currentValue before after value', () async {
          final container = ProviderContainer.test();
          final controller = StreamController<int>();
          final provider = StreamProvider<int>((_) => controller.stream);

          controller.add(42);

          container.listen(provider, (p, n) {});
          final future = container.read(provider.future);

          await expectLater(future, completion(42));

          await controller.close();
        });

        test('read currentValue after error', () async {
          final container = ProviderContainer.test();
          final controller = StreamController<int>();
          final provider = StreamProvider<int>(
            (_) => controller.stream,
            retry: (_, _) => null,
          );

          controller.addError(42);

          container.listen(provider, (p, n) {});
          final future = container.read(provider.future);

          await expectLater(future, throwsA(42));

          await controller.close();
        });
      });
    });
  });

  group('StreamProvider.family', () {
    test('override', () async {
      final provider = StreamProvider.autoDispose.family<int, int>((ref, a) {
        return Stream.value(a * 2);
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

    test('overrideWith', () async {
      final provider = StreamProvider.autoDispose.family<int, int>((ref, a) {
        return Stream.value(a * 2);
      });
      final container = ProviderContainer.test(
        overrides: [provider.overrideWith((ref, a) => Stream.value(a * 4))],
      );
      final listener = Listener<AsyncValue<int>>();

      container.listen(provider(21), listener.call, fireImmediately: true);

      verifyOnly(listener, listener(null, const AsyncValue.loading()));

      await container.pump();

      verifyOnly(
        listener,
        listener(const AsyncLoading(), const AsyncValue.data(84)),
      );
    });

    test('StreamProvider.family override', () async {
      final provider = StreamProvider.family<String, int>((ref, a) {
        return Stream.value('$a');
      });
      final container = ProviderContainer.test(
        overrides: [
          provider.overrideWith((ref, a) => Stream.value('override $a')),
        ],
      );

      container.listen(provider(0), (p, n) {});

      expect(container.read(provider(0)), const AsyncValue<String>.loading());

      await container.pump();

      expect(
        container.read(provider(0)),
        const AsyncValue<String>.data('override 0'),
      );
    });

    test('StreamProvider.family', () async {
      final provider = StreamProvider.family<String, int>((ref, a) {
        return Stream.value('$a');
      });
      final container = ProviderContainer.test();

      container.listen(provider(0), (p, n) {});

      expect(container.read(provider(0)), const AsyncValue<String>.loading());

      await container.pump();

      expect(container.read(provider(0)), const AsyncValue<String>.data('0'));
    });

    group('scoping', () {
      group(
        'scoping an override overrides all the associated subproviders',
        () {
          test('when passing the provider itself', () async {
            final provider = StreamProvider.autoDispose.family<int, int>(
              (ref, _) => Stream.value(0),
              dependencies: const [],
            );
            final root = ProviderContainer.test();
            final container = ProviderContainer.test(
              parent: root,
              overrides: [provider],
            );

            container.listen(provider(0), (p, n) {});

            expect(await container.read(provider(0).future), 0);
            expect(container.read(provider(0)), const AsyncData(0));
            expect(root.getAllProviderElements(), isEmpty);
            expect(
              container.getAllProviderElements(),
              unorderedEquals(<Object?>[
                isA<ProviderElement>().having(
                  (e) => e.origin,
                  'origin',
                  provider(0),
                ),
              ]),
            );
          });

          test('when passing the provider itself', () async {
            final provider = StreamProvider.family<int, int>(
              (ref, _) => Stream.value(0),
              dependencies: const [],
            );
            final root = ProviderContainer.test();
            final container = ProviderContainer.test(
              parent: root,
              overrides: [provider],
            );

            container.listen(provider(0), (p, n) {});

            expect(await container.read(provider(0).future), 0);
            expect(container.read(provider(0)), const AsyncData(0));
            expect(root.getAllProviderElements(), isEmpty);
            expect(
              container.getAllProviderElements(),
              unorderedEquals(<Object?>[
                isA<ProviderElement>().having(
                  (e) => e.origin,
                  'origin',
                  provider(0),
                ),
              ]),
            );
          });

          test('when using provider.overrideWith', () async {
            final provider = StreamProvider.family<int, int>(
              (ref, _) => Stream.value(0),
              dependencies: const [],
            );
            final root = ProviderContainer.test();
            final container = ProviderContainer.test(
              parent: root,
              overrides: [
                provider.overrideWith((ref, value) => Stream.value(42)),
              ],
            );

            container.listen(provider(0), (p, n) {});

            expect(await container.read(provider(0).future), 42);
            expect(container.read(provider(0)), const AsyncData(42));
            expect(root.getAllProviderElements(), isEmpty);
            expect(
              container.getAllProviderElements(),
              unorderedEquals(<Object?>[
                isA<ProviderElement>().having(
                  (e) => e.origin,
                  'origin',
                  provider(0),
                ),
              ]),
            );
          });
        },
      );

      test('can be auto-scoped', () async {
        final dep = Provider((ref) => 0, dependencies: const []);
        final provider = StreamProvider.autoDispose.family<int, int>(
          (ref, i) => Stream.value(ref.watch(dep) + i),
          dependencies: [dep],
        );
        final root = ProviderContainer.test();
        final container = ProviderContainer.test(
          parent: root,
          overrides: [dep.overrideWithValue(42)],
        );

        container.listen(provider(10), (p, n) {});

        await expectLater(container.read(provider(10).future), completion(52));
        expect(container.read(provider(10)), const AsyncData(52));

        expect(root.getAllProviderElements(), isEmpty);
      });

      test('can be auto-scoped', () async {
        final dep = Provider((ref) => 0, dependencies: const []);
        final provider = StreamProvider.family<int, int>(
          (ref, i) => Stream.value(ref.watch(dep) + i),
          dependencies: [dep],
        );
        final root = ProviderContainer.test();
        final container = ProviderContainer.test(
          parent: root,
          overrides: [dep.overrideWithValue(42)],
        );

        container.listen(provider(10), (p, n) {});

        await expectLater(container.read(provider(10).future), completion(52));
        expect(container.read(provider(10)), const AsyncData(52));

        expect(root.getAllProviderElements(), isEmpty);
      });
    });
  });

  group('StreamProvider.autoDispose', () {
    test('can be auto-scoped', () async {
      final dep = Provider((ref) => 0, dependencies: const []);
      final provider = StreamProvider.autoDispose(
        (ref) => Stream.value(ref.watch(dep)),
        dependencies: [dep],
      );
      final root = ProviderContainer.test();
      final container = ProviderContainer.test(
        parent: root,
        overrides: [dep.overrideWithValue(42)],
      );

      container.listen(provider, (p, n) {});

      await expectLater(container.read(provider.future), completion(42));
      expect(container.read(provider), const AsyncData(42));

      expect(root.getAllProviderElements(), isEmpty);
    });

    test(
      'when going from AsyncLoading to AsyncLoading, does not notify listeners',
      () async {
        final dep = NotifierProvider(
          () => SettableNotifier((ref) => Stream.value(42)),
        );
        final provider = StreamProvider.autoDispose((ref) => ref.watch(dep));
        final container = ProviderContainer.test();
        final listener = Listener<AsyncValue<int>>();
        final controller = StreamController<int>();
        addTearDown(controller.close);

        container.listen(provider, (prev, value) {});

        await expectLater(container.read(provider.future), completion(42));
        expect(container.read(provider), const AsyncData<int>(42));

        container.read(dep.notifier).state = controller.stream;
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

        container.read(dep.notifier).state = Stream.value(21);

        verifyNoMoreInteractions(listener);

        await expectLater(container.read(provider.future), completion(21));
        expect(container.read(provider), const AsyncData<int>(21));
      },
    );

    test('can be refreshed', () async {
      var result = 0;
      final container = ProviderContainer.test();
      final provider = StreamProvider.autoDispose(
        (ref) => Stream.value(result),
      );

      container.listen(provider, (_, _) {});

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
        final provider = StreamProvider.autoDispose((ref) {
          ref.watch(dep);
          return const Stream<int>.empty();
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
      '.future does not update dependents if the created future did not change',
      () async {
        final container = ProviderContainer.test();
        final dep = NotifierProvider(() => SettableNotifier((ref) => 0));
        final provider = StreamProvider.autoDispose((ref) {
          ref.watch(dep);
          return const Stream<int>.empty();
        });
        final listener = Listener<Future<int>>();

        container.listen(provider.future, listener.call, fireImmediately: true);

        verifyOnly(listener, listener(any, any));

        container.read(dep.notifier).state++;
        await container.pump();

        verifyNoMoreInteractions(listener);

        // No value were emitted, so the future will fail. Catching the error to
        // avoid false positive.
        unawaited(container.read(provider.future).catchError((Object _) => 0));
      },
    );

    group('scoping an override overrides all the associated subproviders', () {
      test('when passing the provider itself', () async {
        final provider = StreamProvider.autoDispose(
          (ref) => Stream.value(0),
          dependencies: const [],
        );
        final root = ProviderContainer.test();
        final container = ProviderContainer.test(
          parent: root,
          overrides: [provider],
        );

        container.listen(provider, (p, n) {});

        expect(await container.read(provider.future), 0);
        expect(container.read(provider), const AsyncValue.data(0));
        expect(root.getAllProviderElements(), isEmpty);
        expect(
          container.getAllProviderElements(),
          unorderedEquals(<Object?>[
            isA<ProviderElement>().having((e) => e.origin, 'origin', provider),
          ]),
        );
      });

      test('when using provider.overrideWithValue', () async {
        final provider = StreamProvider.autoDispose(
          (ref) => Stream.value(0),
          dependencies: [],
        );
        final root = ProviderContainer.test();
        final container = ProviderContainer.test(
          parent: root,
          overrides: [provider.overrideWithValue(const AsyncValue.data(42))],
        );

        expect(await container.read(provider.future), 42);
        expect(container.read(provider), const AsyncValue.data(42));
        expect(root.getAllProviderElements(), isEmpty);
        expect(
          container.getAllProviderElements(),
          unorderedEquals(<Object?>[
            isA<ProviderElement>().having((e) => e.origin, 'origin', provider),
          ]),
        );
      });

      test('when using provider.overrideWith', () async {
        final provider = StreamProvider.autoDispose(
          (ref) => Stream.value(0),
          dependencies: const [],
        );
        final root = ProviderContainer.test();
        final container = ProviderContainer.test(
          parent: root,
          overrides: [provider.overrideWith((ref) => Stream.value(42))],
        );

        container.listen(provider, (p, n) {});

        expect(await container.read(provider.future), 42);
        expect(container.read(provider), const AsyncValue.data(42));
        expect(root.getAllProviderElements(), isEmpty);
        expect(
          container.getAllProviderElements(),
          unorderedEquals(<Object?>[
            isA<ProviderElement>().having((e) => e.origin, 'origin', provider),
          ]),
        );
      });
    });

    test('works', () async {
      var stream = Stream.value(42);
      final onDispose = OnDisposeMock();
      final provider = StreamProvider.autoDispose((ref) {
        ref.onDispose(onDispose.call);
        return stream;
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

      stream = Stream.value(21);

      container.listen(provider, listener.call, fireImmediately: true);

      verifyOnly(listener, listener(null, const AsyncValue.loading()));

      await container.pump();

      verifyOnly(
        listener,
        listener(const AsyncValue.loading(), const AsyncValue.data(21)),
      );
    });
  });
}
