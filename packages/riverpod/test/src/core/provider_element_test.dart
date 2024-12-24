import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:riverpod/src/internals.dart';
import 'package:test/test.dart';

import '../../third_party/fake_async.dart';
import '../matrix.dart';
import '../utils.dart';

void main() {
  group('ProviderElement', () {
    test('Only includes direct subscriptions in subscription lists', () {
      final container = ProviderContainer.test();
      final provider = FutureProvider((ref) => 0);
      final dep = Provider((ref) {
        ref.watch(provider.future.select((value) => 0));
      });

      container.read(dep);

      final providerElement = container.readProviderElement(provider);
      final depElement = container.readProviderElement(dep);

      expect(providerElement.subscriptions, null);
      expect(
        providerElement.dependents,
        [isA<ProviderSubscription<int>>()],
      );
      expect(providerElement.weakDependents, isEmpty);

      expect(depElement.subscriptions, [
        isA<ProviderSubscription<int>>(),
      ]);
      expect(depElement.dependents, isEmpty);
      expect(depElement.weakDependents, isEmpty);
    });

    group('retry', () {
      test(
        skip: 'unimplemented',
        'default retry delays from 200ms to 6.4 seconds',
        () {},
      );

      group('custom retry', () {
        test(
          'if returns null, stops retrying',
          () => fakeAsync((fake) {
            final container = ProviderContainer.test(retry: (_, __) => null);
            var buildCount = 0;
            final provider = Provider((ref) {
              buildCount++;
              throw StateError('');
            });

            container.listen(
              provider,
              (prev, next) {},
              fireImmediately: true,
              onError: (e, s) {},
            );
            expect(buildCount, 1);

            fake.elapse(const Duration(seconds: 100));

            expect(buildCount, 1);
          }),
        );

        test(
          'passes the correct retry count and error',
          () => fakeAsync((fake) {
            final retry = RetryMock();
            when(retry(any, any)).thenReturn(const Duration(milliseconds: 200));
            final container = ProviderContainer.test(retry: retry.call);
            final provider = Provider((ref) => throw StateError(''));

            container.listen(
              provider,
              (prev, next) {},
              fireImmediately: true,
              onError: (e, s) {},
            );

            verifyOnly(retry, retry(0, isStateError));

            fake.elapse(const Duration(milliseconds: 200));

            verifyOnly(retry, retry(1, isStateError));

            fake.elapse(const Duration(milliseconds: 200));

            verifyOnly(retry, retry(2, isStateError));

            container.invalidate(provider, asReload: true);
            fake.elapse(const Duration(milliseconds: 50));

            // On reload, resets counter to 0
            verifyOnly(retry, retry(0, isStateError));
          }),
        );

        test(
          'delays by the duration returned',
          () => fakeAsync((fake) {
            final container = ProviderContainer.test(
              retry: (_, __) => const Duration(milliseconds: 3),
            );
            final errorListener = ErrorListener();
            var msg = '0';
            final provider = Provider((ref) => throw StateError(msg));

            container.listen(
              provider,
              (prev, next) {},
              fireImmediately: true,
              onError: errorListener.call,
            );

            verifyOnly(
              errorListener,
              errorListener(
                argThat(isStateErrorWith(message: '0')),
                any,
              ),
            );

            msg = '1';
            fake.elapse(const Duration(milliseconds: 1));

            verifyNoMoreInteractions(errorListener);

            fake.elapse(const Duration(milliseconds: 1));

            verifyNoMoreInteractions(errorListener);

            fake.elapse(const Duration(milliseconds: 1));

            verifyOnly(
              errorListener,
              errorListener(
                argThat(isStateErrorWith(message: '1')),
                any,
              ),
            );
          }),
        );

        test(
          'if the retry function throws, stops retrying and report the error',
          () => fakeAsync((fake) {
            final errors = <Object>[];
            runZonedGuarded(
              () {
                final container = ProviderContainer.test(
                  retry: (_, __) => throw StateError('Oops!'),
                );
                final errorListener = ErrorListener();
                final provider = Provider((ref) => throw StateError('msg'));

                container.listen(
                  provider,
                  (prev, next) {},
                  fireImmediately: true,
                  onError: errorListener.call,
                );

                verifyOnly(
                  errorListener,
                  errorListener(
                    argThat(isStateErrorWith(message: 'msg')),
                    any,
                  ),
                );

                fake.elapse(const Duration(milliseconds: 1));

                verifyNoMoreInteractions(errorListener);
              },
              (e, s) => errors.add(e),
            );

            expect(
              errors,
              equals([isStateErrorWith(message: 'Oops!')]),
            );
          }),
        );

        test(
            "If the provider specifies retry, uses the provider's "
            'logic instead of the container one.', () {
          final retry1 = RetryMock();
          final retry2 = RetryMock();
          final container = ProviderContainer.test(
            retry: retry1.call,
          );

          final provider = Provider(
            retry: retry2.call,
            (ref) => throw StateError(''),
          );

          container.listen(
            provider,
            (prev, next) {},
            fireImmediately: true,
            onError: (e, s) {},
          );

          verifyOnly(retry2, retry2(0, isStateError));
          verifyNoMoreInteractions(retry1);
        });
      });

      test(
        'disposes of the timer when the element is disposed',
        () => fakeAsync((fake) {
          final retry = RetryMock();
          when(retry(any, any)).thenReturn(const Duration(milliseconds: 200));
          final container = ProviderContainer.test(retry: retry.call);
          final provider = Provider((ref) => throw StateError(''));

          container.listen(
            provider,
            (prev, next) {},
            fireImmediately: true,
            onError: (e, s) {},
          );

          expect(fake.pendingTimers, hasLength(1));

          container.dispose();

          expect(fake.pendingTimers, isEmpty);
        }),
      );
    });

    test(
        'does not throw outdated error when a dependency is flushed while the dependent is building',
        () async {
      final container = ProviderContainer.test();
      final a = StateProvider((ref) => 0);

      final dep = Provider<int>((ref) {
        return ref.watch(a) + 10;
      });
      final dependent = Provider<int?>((ref) {
        if (ref.watch(a) > 0) {
          ref.watch(dep);
          // Voluntarily using "watch" twice.
          // When `dep` is flushed, it could cause subsequent "watch" calls to throw
          // because `dependent` is considered as outdated
          return ref.watch(dep);
        }
        return null;
      });
      final listener = Listener<int?>();

      expect(container.read(dep), 10);
      container.listen<int?>(dependent, listener.call, fireImmediately: true);

      verifyOnly(listener, listener(null, null));

      // schedules `dep` and `dependent` to rebuild
      // Will build `dependent` before `dep` because `dependent` doesn't depend on `dep` yet
      // And since nothing is watching `dep` at the moment, then `dependent` will
      // rebuild before `dep` even though `dep` is its ancestor.
      // This is fine since nothing is listening to `dep` yet, but it should
      // not cause certain assertions to trigger
      container.read(a.notifier).state++;
      await container.pump();

      verifyOnly(listener, listener(null, 11));
    });

    group('readSelf', () {
      test('throws on providers that threw', () {
        final container = ProviderContainer.test();
        final provider = Provider((ref) => throw UnimplementedError());

        final element = container.readProviderElement(provider);

        expect(
          element.readSelf,
          throwsUnimplementedError,
        );
      });
    });

    group('visitChildren', () {
      test('includes ref.watch dependents', () {
        final container = ProviderContainer.test();
        final provider = Provider((ref) => 0);
        final dependent = Provider((ref) {
          ref.watch(provider);
        });
        final dependent2 = Provider((ref) {
          ref.watch(provider);
        });

        container.read(dependent);
        container.read(dependent2);

        final children = <ProviderElement>[];

        container.readProviderElement(provider).visitChildren(
              elementVisitor: children.add,
              listenableVisitor: (_) {},
            );
        expect(
          children,
          unorderedMatches(<Object>[
            isA<ProviderElement>()
                .having((e) => e.provider, 'provider', dependent),
            isA<ProviderElement>()
                .having((e) => e.provider, 'provider', dependent2),
          ]),
        );
      });

      test('includes ref.listen dependents', () {
        final container = ProviderContainer.test();
        final provider = Provider((ref) => 0);
        final dependent = Provider((ref) {
          ref.listen(provider, (_, __) {});
        });
        final dependent2 = Provider((ref) {
          ref.listen(provider, (_, __) {});
        });
        final dependent3 = Provider((ref) {
          ref.listen(provider, (_, __) {}, weak: true);
        });

        container.read(dependent);
        container.read(dependent2);
        container.read(dependent3);

        final children = <ProviderElement>[];

        container.readProviderElement(provider).visitChildren(
              elementVisitor: children.add,
              listenableVisitor: (_) {},
            );

        expect(
          children,
          unorderedMatches(<Object>[
            isA<ProviderElement>()
                .having((e) => e.provider, 'provider', dependent),
            isA<ProviderElement>()
                .having((e) => e.provider, 'provider', dependent2),
            isA<ProviderElement>()
                .having((e) => e.provider, 'provider', dependent3),
          ]),
        );
      });
    });

    group('isActive', () {
      test('Is paused if all watchers are paused', () {
        final container = ProviderContainer.test();
        final provider = Provider(name: 'foo', (ref) => 0);
        final dep = Provider(name: 'dep', (ref) => ref.watch(provider));
        final dep2 = Provider(name: 'dep2', (ref) => ref.watch(provider));

        final depSub = container.listen(dep, (a, b) {});
        final dep2Sub = container.listen(dep2, (a, b) {});
        final element = container.readProviderElement(provider);

        expect(element.isActive, true);

        depSub.close();

        expect(element.isActive, true);

        dep2Sub.close();

        expect(element.isActive, false);
      });

      test('Is paused if all subscriptions are paused', () {
        final container = ProviderContainer.test();
        final provider = Provider((ref) => 0);

        final element = container.readProviderElement(provider);

        final sub = container.listen(provider, (_, __) {});
        final sub2 = container.listen(provider, (_, __) {});

        expect(element.isActive, true);

        sub.pause();

        expect(element.isActive, true);

        sub2.pause();

        expect(element.isActive, false);
      });

      test('rejects weak listeners', () {
        final provider = Provider((ref) => 0);
        final container = ProviderContainer.test();

        final element = container.readProviderElement(provider);

        expect(element.isActive, false);

        container.listen(provider, weak: true, (_, __) {});

        expect(element.isActive, false);
      });

      test('includes provider listeners', () async {
        final provider = Provider((ref) => 0);
        final dep = Provider((ref) {
          ref.listen(provider, (prev, value) {});
        });
        final container = ProviderContainer.test();

        expect(container.readProviderElement(provider).isActive, false);

        container.listen(dep, (p, n) {});

        expect(container.readProviderElement(provider).isActive, true);
      });

      test('includes provider dependents', () async {
        final provider = Provider((ref) => 0);
        final dep = Provider((ref) {
          ref.watch(provider);
        });
        final container = ProviderContainer.test();

        expect(container.readProviderElement(provider).isActive, false);

        container.listen(dep, (p, n) {});

        expect(container.readProviderElement(provider).isActive, true);
      });

      test('includes container listeners', () async {
        final provider = Provider((ref) => 0);
        final container = ProviderContainer.test();

        expect(container.readProviderElement(provider).isActive, false);

        container.listen(provider, (_, __) {});

        expect(container.readProviderElement(provider).isActive, true);
      });
    });

    group('hasNonWeakListeners', () {
      test('excludes weak listeners', () {
        final provider = Provider((ref) => 0);
        final container = ProviderContainer.test();

        final element = container.readProviderElement(provider);

        expect(element.hasNonWeakListeners, false);

        container.listen(provider, weak: true, (_, __) {});

        expect(element.hasNonWeakListeners, false);
      });

      test('includes provider listeners', () async {
        final provider = Provider((ref) => 0);
        final dep = Provider((ref) {
          ref.listen(provider, (prev, value) {});
        });
        final container = ProviderContainer.test();

        expect(
          container.readProviderElement(provider).hasNonWeakListeners,
          false,
        );

        container.read(dep);

        expect(
          container.readProviderElement(provider).hasNonWeakListeners,
          true,
        );
      });

      test('includes provider dependents', () async {
        final provider = Provider((ref) => 0);
        final dep = Provider((ref) {
          ref.watch(provider);
        });
        final container = ProviderContainer.test();

        expect(
          container.readProviderElement(provider).hasNonWeakListeners,
          false,
        );

        container.read(dep);

        expect(
          container.readProviderElement(provider).hasNonWeakListeners,
          true,
        );
      });

      test('includes container listeners', () async {
        final provider = Provider((ref) => 0);
        final container = ProviderContainer.test();

        expect(
          container.readProviderElement(provider).hasNonWeakListeners,
          false,
        );

        container.listen(provider, (_, __) {});

        expect(
          container.readProviderElement(provider).hasNonWeakListeners,
          true,
        );
      });
    });

    test('does not notify listeners twice when using fireImmediately',
        () async {
      final container = ProviderContainer.test();
      final listener = Listener<int>();

      final dep = StateProvider((ref) => 0);
      final provider = NotifierProvider<DeferredNotifier<int>, int>(
        () => DeferredNotifier((ref, self) {
          ref.watch(dep);
          return self.state = 0;
        }),
      );

      container.listen(provider, listener.call, fireImmediately: true);

      verifyOnly(listener, listener(null, 0));
    });

    test('does not notify listeners when rebuilding the state', () async {
      final container = ProviderContainer.test();
      final listener = Listener<int>();

      final dep = StateProvider((ref) => 0);
      final provider = NotifierProvider<DeferredNotifier<int>, int>(
        () => DeferredNotifier((ref, self) {
          ref.watch(dep);
          return self.state = 0;
        }),
      );

      container.listen(provider, listener.call, fireImmediately: true);

      verifyOnly(listener, listener(null, 0));

      container.read(dep.notifier).state++;
      await container.pump();

      verifyNoMoreInteractions(listener);
    });
  });
}
