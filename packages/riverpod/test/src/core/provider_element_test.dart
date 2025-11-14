import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:riverpod/src/internals.dart';
import 'package:test/test.dart';

import '../../third_party/fake_async.dart';
import '../matrix.dart';
import '../utils.dart';

void main() {
  group('ProviderElement', () {
    group('pausedActiveSubscriptionCount', () {
      test('Handles subscription.pause', () async {
        final container = ProviderContainer.test();
        final provider = FutureProvider(name: 'provider', (ref) => 0);

        final sub = container.listen(provider, (_, _) {});
        final sub2 = container.listen(provider.future, (_, _) {});
        final element = container.readProviderElement(provider);

        expect(element.pausedActiveSubscriptionCount, 0);
        sub.pause();
        expect(element.pausedActiveSubscriptionCount, 1);
        sub2.pause();
        expect(element.pausedActiveSubscriptionCount, 2);

        sub.resume();
        expect(element.pausedActiveSubscriptionCount, 1);
        sub2.resume();
        expect(element.pausedActiveSubscriptionCount, 0);
      });

      test('Handles removing a subscription that is paused', () async {
        final container = ProviderContainer.test();
        final provider = Provider(name: 'provider', (ref) => 0);
        final dep = Provider(name: 'dep', (ref) {
          ref.watch(provider);
        });

        container.read(dep);
        container.refresh(dep);

        final element = container.readProviderElement(provider);

        expect(element.pausedActiveSubscriptionCount, 1);
      });

      test('Does not count weak subscription', () {
        final container = ProviderContainer.test();
        final provider = FutureProvider(name: 'provider', (ref) => 0);

        container.listen(provider, (_, _) {}).pause();

        final sub = container.listen(provider, (_, _) {}, weak: true)..pause();
        final element = container.readProviderElement(provider);

        expect(
          element.pausedActiveSubscriptionCount,
          1,
          reason: 'Ignores weak',
        );

        sub.resume();

        expect(
          element.pausedActiveSubscriptionCount,
          1,
          reason: 'Ignores weak',
        );

        sub.pause();
        sub.close();

        expect(
          element.pausedActiveSubscriptionCount,
          1,
          reason: 'Ignores weak',
        );
      });

      test('Handles pause/resume/remove on Element views', () async {
        final container = ProviderContainer.test();
        final provider = FutureProvider(name: 'provider', (ref) => 0);

        container.listen(provider, (_, _) {}).pause();

        final sub = container.listen(provider.future, (_, _) {})..pause();
        final element = container.readProviderElement(provider);

        expect(
          element.pausedActiveSubscriptionCount,
          2,
          reason: 'should not increment twice',
        );

        sub.resume();

        expect(
          element.pausedActiveSubscriptionCount,
          1,
          reason: 'should not decrement twice',
        );

        sub.pause();
        sub.close();

        expect(
          element.pausedActiveSubscriptionCount,
          1,
          reason: 'should not decrement twice',
        );
      });
    });

    group('listenerCount', () {
      test('Handles Element views', () async {
        final container = ProviderContainer.test();
        final provider = FutureProvider(name: 'provider', (ref) => 0);

        final sub = container.listen(provider.future, (_, _) {});
        final element = container.readProviderElement(provider);

        expect(element.listenerCount, 1);

        sub.close();

        expect(element.listenerCount, 0);
      });
    });

    group('_debugAssertNotificationAllowed', () {
      test('allows ref.listen to call state= for dependencies', () {
        // Regression test for false positive with the assert when
        // a dependency is using ref.listen((transitiveDeps) => state = ...);
        final container = ProviderContainer.test();
        final transitiveProvider = Provider(
          name: 'transitiveProvider',
          (ref) => Object(),
        );
        final dep = NotifierProvider<DeferredNotifier<Object>, Object>(
          name: 'dep',
          () => DeferredNotifier((ref, self) {
            ref.listen(transitiveProvider, (prev, next) => self.state = next);
            return 0;
          }),
        );
        final provider = Provider(name: 'provider', (ref) {
          ref.watch(dep);
          return 0;
        });

        container.read(dep);
        container.invalidate(transitiveProvider);

        // Should not emit an assertion error
        container.read(provider);
      });
    });

    test("adding and removing a dep shouldn't stop its listeners", () async {
      // Regression test for https://github.com/rrousselGit/riverpod/issues/4117
      final numberProvider = StreamProvider.autoDispose<int>(name: 'number', (
        ref,
      ) {
        final controller = StreamController<int>();

        var counter = 0;
        final timer = Timer.periodic(const Duration(milliseconds: 10), (_) {
          if (!controller.isClosed) controller.sink.add(counter++);
        });

        ref.onDispose(() {
          timer.cancel();
          controller.close();
        });

        return controller.stream;
      });
      final provider1 = FutureProvider.autoDispose(
        (ref) => ref.watch(numberProvider.future),
        name: 'one',
      );
      final provider2 = FutureProvider.autoDispose(
        (ref) => ref.watch(numberProvider.future),
        name: 'two',
      );

      final container = ProviderContainer.test();

      final element = container.readProviderElement(numberProvider);

      Future.delayed(Duration.zero, () async {
        Future<void> pushAndPop() async {
          if (container.disposed) return;
          final sub2 = container.listen(provider2, (previous, next) {});
          await Future.microtask(() {});
          sub2.close();
        }

        await pushAndPop();
        await Future<void>.delayed(Duration.zero);

        await pushAndPop();
      });

      container.listen(provider1, (previous, next) {});

      await expectLater(container.read(numberProvider.future), completes);
    });

    test(
      'pauses old subscriptions upon invalidation until the completion of the new computation',
      () async {
        final container = ProviderContainer.test();
        final depProvider = Provider.family<int, String>((ref, _) => 0);
        final futureP = FutureProvider<Ref>(Future.value);
        final streamP = StreamProvider<Ref>(Stream.value);
        final p = Provider<Ref>((ref) => ref);

        final depP = container.readProviderElement(depProvider('p'));
        final depF = container.readProviderElement(depProvider('f'));
        final depS = container.readProviderElement(depProvider('s'));

        container.listen(p, (a, b) {}).read().watch(depProvider('p'));
        (await container.listen(futureP.future, (a, b) {}).read()).watch(
          depProvider('f'),
        );
        (await container.listen(streamP.future, (a, b) {}).read()).watch(
          depProvider('s'),
        );

        container.invalidate(p);
        container.invalidate(futureP);
        container.invalidate(streamP);

        expect(depP.hasNonWeakListeners, true);
        expect(depF.hasNonWeakListeners, true);
        expect(depS.hasNonWeakListeners, true);
        expect(depP.isActive, false);
        expect(depF.isActive, false);
        expect(depS.isActive, false);

        await container.pump();

        expect(depP.hasNonWeakListeners, false);
        expect(depF.hasNonWeakListeners, true);
        expect(depS.hasNonWeakListeners, true);
        expect(depP.isActive, false);
        expect(depF.isActive, false);
        expect(depS.isActive, false);

        await container.read(streamP.future);
        await container.read(futureP.future);

        expect(depP.hasNonWeakListeners, false);
        expect(depF.hasNonWeakListeners, false);
        expect(depS.hasNonWeakListeners, false);
        expect(depP.isActive, false);
        expect(depF.isActive, false);
        expect(depS.isActive, false);
      },
    );

    test(
      'Adding a listener on a provider with only paused proxy subscriptions unpauses the provider',
      () async {
        // Regression test for when "resume" somehow triggers too late
        final container = ProviderContainer.test();
        final onResume = OnResume();
        final dep = FutureProvider<int>((ref) {
          ref.onResume(onResume.call);
          return 0;
        });

        final sub = container.listen(dep.future, (_, _) {})..pause();
        clearInteractions(onResume);

        container.listen(dep, (_, _) {});
        verifyOnly(onResume, onResume.call());
      },
    );

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
      expect(providerElement.dependents, [isA<ProviderSubscription<int>>()]);
      expect(providerElement.weakDependents, isEmpty);

      expect(depElement.subscriptions, [isA<ProviderSubscription<int>>()]);
      expect(depElement.dependents, isEmpty);
      expect(depElement.weakDependents, isEmpty);
    });

    group('retry', () {
      test(
        'does not start retry if error is emitted after element dispose',
        () async {
          final container = ProviderContainer.test();
          final completer = Completer<int>();
          final retryMock = RetryMock();
          final provider = FutureProvider<int>(
            (ref) => completer.future,
            retry: retryMock.call,
          );

          container.listen(
            provider,
            (prev, next) {},
            fireImmediately: true,
            onError: (e, s) {},
          );

          container.dispose();

          completer.completeError('err');
          await completer.future.catchError((_) => 0);

          verifyZeroInteractions(retryMock);
        },
      );

      test(
        'default ignores ProviderExceptions',
        () => fakeAsync((fake) async {
          final container = ProviderContainer.test();
          final dep = Provider(
            (ref) => throw Exception('message'),
            retry: (count, err) => null,
          );
          var buildCount = 0;
          final provider = Provider((ref) {
            buildCount++;
            ref.watch(dep);
          });

          container.listen(provider, (prev, next) {}, onError: (e, s) {});

          fake.elapse(const Duration(hours: 1));

          expect(buildCount, 1);
        }),
      );

      test(
        'default ignores Errors',
        () => fakeAsync((fake) async {
          final container = ProviderContainer.test();
          final dep = Provider((ref) => throw Error());
          var buildCount = 0;
          final provider = Provider((ref) {
            buildCount++;
            ref.watch(dep);
          });

          container.listen(provider, (prev, next) {}, onError: (e, s) {});

          fake.elapse(const Duration(hours: 1));

          expect(buildCount, 1);
        }),
      );

      test(
        'default retry delays from 200ms to 6.4 seconds',
        () => fakeAsync((fake) async {
          final container = ProviderContainer.test();
          var buildCount = 0;
          final provider = Provider((ref) {
            buildCount++;
            throw Exception('');
          });

          container.listen(
            provider,
            (prev, next) {},
            fireImmediately: true,
            onError: (e, s) {},
          );

          const times = [200, 400, 800, 1600, 3200, 6400, 6400];

          for (final (index, time) in times.indexed) {
            fake.elapse(Duration(milliseconds: time - 10));
            expect(buildCount, index + 1, reason: 'expect retry time of $time');

            fake.elapse(const Duration(milliseconds: 10));
            expect(buildCount, index + 2);
          }
        }),
      );

      test(
        'default retries at most 10 times',
        () => fakeAsync((fake) async {
          final container = ProviderContainer.test();
          var buildCount = 0;
          final provider = Provider((ref) {
            buildCount++;
            throw Exception('');
          });

          container.listen(
            provider,
            (prev, next) {},
            fireImmediately: true,
            onError: (e, s) {},
          );

          fake.elapse(const Duration(hours: 1));

          expect(buildCount, 11);
        }),
      );

      group('custom retry', () {
        test(
          'if returns null, stops retrying',
          () => fakeAsync((fake) {
            final container = ProviderContainer.test(retry: (_, _) => null);
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
              retry: (_, _) => const Duration(milliseconds: 3),
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
              errorListener(argThat(isStateErrorWith(message: '0')), any),
            );

            msg = '1';
            fake.elapse(const Duration(milliseconds: 1));

            verifyNoMoreInteractions(errorListener);

            fake.elapse(const Duration(milliseconds: 1));

            verifyNoMoreInteractions(errorListener);

            fake.elapse(const Duration(milliseconds: 1));

            verifyOnly(
              errorListener,
              errorListener(argThat(isStateErrorWith(message: '1')), any),
            );
          }),
        );

        test(
          'if the retry function throws, stops retrying and report the error',
          () => fakeAsync((fake) {
            final errors = <Object>[];
            runZonedGuarded(() {
              final container = ProviderContainer.test(
                retry: (_, _) => throw StateError('Oops!'),
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
                errorListener(argThat(isStateErrorWith(message: 'msg')), any),
              );

              fake.elapse(const Duration(milliseconds: 1));

              verifyNoMoreInteractions(errorListener);
            }, (e, s) => errors.add(e));

            expect(errors, equals([isStateErrorWith(message: 'Oops!')]));
          }),
        );

        test("If the provider specifies retry, uses the provider's "
            'logic instead of the container one.', () {
          final retry1 = RetryMock();
          final retry2 = RetryMock();
          final container = ProviderContainer.test(retry: retry1.call);

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
      },
    );

    group('visitAncestors', () {
      test('includes inactive subscriptions', () async {
        final container = ProviderContainer.test();
        final provider = Provider<void>((ref) => 0);
        Completer<void>? completer;
        final dependent = FutureProvider<void>((ref) async {
          await completer?.future;

          ref.watch(provider);
        });

        final sub = container.listen(dependent.future, (_, _) {});
        await sub.read();
        final element = container.readProviderElement(dependent);

        completer = Completer<void>();
        addTearDown(() => completer?.complete());

        container.refresh(dependent);
        // Don't await sub.read(), to ensure that the new ref.watch isn't
        // triggered yet

        final children = <ProviderElement>[];
        element.visitAncestors(children.add);

        expect(children.map((e) => e.origin).toList(), [provider]);
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

        container.readProviderElement(provider).visitChildren(children.add);
        expect(
          children,
          unorderedMatches(<Object>[
            isA<ProviderElement>().having(
              (e) => e.provider,
              'provider',
              dependent,
            ),
            isA<ProviderElement>().having(
              (e) => e.provider,
              'provider',
              dependent2,
            ),
          ]),
        );
      });

      test('includes ref.listen dependents', () {
        final container = ProviderContainer.test();
        final provider = Provider((ref) => 0);
        final dependent = Provider((ref) {
          ref.listen(provider, (_, _) {});
        });
        final dependent2 = Provider((ref) {
          ref.listen(provider, (_, _) {});
        });
        final dependent3 = Provider((ref) {
          ref.listen(provider, (_, _) {}, weak: true);
        });

        container.read(dependent);
        container.read(dependent2);
        container.read(dependent3);

        final children = <ProviderElement>[];

        container.readProviderElement(provider).visitChildren(children.add);

        expect(
          children,
          unorderedMatches(<Object>[
            isA<ProviderElement>().having(
              (e) => e.provider,
              'provider',
              dependent,
            ),
            isA<ProviderElement>().having(
              (e) => e.provider,
              'provider',
              dependent2,
            ),
            isA<ProviderElement>().having(
              (e) => e.provider,
              'provider',
              dependent3,
            ),
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

        final sub = container.listen(provider, (_, _) {});
        final sub2 = container.listen(provider, (_, _) {});

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

        container.listen(provider, weak: true, (_, _) {});

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

        container.listen(provider, (_, _) {});

        expect(container.readProviderElement(provider).isActive, true);
      });
    });

    group('hasNonWeakListeners', () {
      test('excludes weak listeners', () {
        final provider = Provider((ref) => 0);
        final container = ProviderContainer.test();

        final element = container.readProviderElement(provider);

        expect(element.hasNonWeakListeners, false);

        container.listen(provider, weak: true, (_, _) {});

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

        container.listen(provider, (_, _) {});

        expect(
          container.readProviderElement(provider).hasNonWeakListeners,
          true,
        );
      });
    });

    test(
      'does not notify listeners twice when using fireImmediately',
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
      },
    );

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
