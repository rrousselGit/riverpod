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

      test('rebuilding a provider can modify other providers', () async {
        final dep = settableProvider((ref) => 0);
        final provider = Provider((ref) => ref.watch(dep));
        final another = NotifierProvider<Notifier<int>, int>(
          () => DeferredNotifier((ref, self) {
            ref.listen(provider, (prev, value) => self.state++);
            return 0;
          }),
        );
        final container = ProviderContainer.test();

        expect(container.read(another), 0);

        container.read(dep.notifier).state = 42;

        expect(container.read(another), 1);
      });

      test("initState can't dirty ancestors", () {
        final container = ProviderContainer.test();
        final ancestor = settableProvider((_) => 0);
        final child = Provider((ref) {
          ref.watch(ancestor.notifier).state++;
          return ref.watch(ancestor);
        });

        expect(errorsOf(() => container.read(child)), isNotEmpty);
      });

      test("initState can't dirty siblings", () {
        final container = ProviderContainer.test();
        final ancestor = settableProvider((_) => 0, name: 'ancestor');
        late DeferredNotifier<int> counter;
        final sibling = NotifierProvider<DeferredNotifier<int>, int>(
          name: 'sibling',
          () => counter = DeferredNotifier((ref, self) {
            ref.watch(ancestor);
            return 0;
          }),
        );
        var didWatchAncestor = false;
        final child = Provider(name: 'child', (ref) {
          ref.watch(ancestor);
          didWatchAncestor = true;
          counter.state++;
        });

        container.read(sibling);

        expect(errorsOf(() => container.read(child)), isNotEmpty);
        expect(didWatchAncestor, true);
      });

      test("initState can't mark dirty other provider", () {
        final container = ProviderContainer.test();
        final provider = settableProvider((ref) => 0);
        final provider2 = Provider((ref) {
          ref.watch(provider.notifier).state = 42;
          return 0;
        });

        expect(container.read(provider), 0);

        expect(errorsOf(() => container.read(provider2)), isNotEmpty);
      });

      test("nested initState can't mark dirty other providers", () {
        final container = ProviderContainer.test();
        late Counter counter;
        final provider = NotifierProvider<Counter, int>(
          () => counter = Counter(),
        );
        final nested = Provider((_) => 0);
        final provider2 = Provider((ref) {
          ref.watch(nested);
          counter.increment();
          return 0;
        });

        expect(container.read(provider), 0);

        expect(errorsOf(() => container.read(provider2)), isNotEmpty);
      });

      test("Provider can't dirty anything on create", () {
        final container = ProviderContainer.test();
        late Counter counter;
        final provider = NotifierProvider<Counter, int>(
          () => counter = Counter(),
        );
        late List<Object> errors;
        final computed = Provider((ref) {
          errors = errorsOf(counter.increment);
          return 0;
        });
        final listener = Listener<int>();

        expect(container.read(provider), 0);

        container.listen(computed, listener.call, fireImmediately: true);

        verify(listener(null, 0)).called(1);
        verifyNoMoreInteractions(listener);
        expect(errors, isNotEmpty);
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
        'Calling invalidate(asReload: true) after a retry does not cause an infinite retry loop',
        () => fakeAsync((fake) async {
          final container = ProviderContainer.test();
          const retryDelay = Duration(milliseconds: 200);
          final onRetry = RetryMock();
          when(onRetry.call(any, any)).thenAnswer((i) => retryDelay);
          var shouldThrow = false;
          const awaitDelay = Duration(milliseconds: 100);
          var buildCount = 0;
          late Ref ref;
          final provider = FutureProvider.family<Object?, Object?>((
            r,
            _,
          ) async {
            ref = r;
            buildCount++;
            await Future<void>.delayed(awaitDelay);
            if (shouldThrow) throw Exception('message');

            return Object();
          }, retry: onRetry.call);

          final sub = container.listen(
            provider(false).future,
            (prev, next) {},
            onError: (e, s) {},
          );

          fake.elapse(awaitDelay);
          expect(buildCount, 1);

          shouldThrow = true;

          container.invalidate(provider, asReload: true);

          fake.elapse(awaitDelay + retryDelay * 2);
          verify(onRetry(0, isA<Exception>()));
          verify(onRetry(1, isA<Exception>()));
          verifyNoMoreInteractions(onRetry);
        }),
      );

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
        final a = settableProvider((ref) => 0);

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

      test(
        'when selecting a provider, element.visitAncestors visits the selected provider',
        () {
          final container = ProviderContainer.test();
          final selected = settableProvider((ref) => 0);
          final provider = Provider((ref) {
            ref.watch(selected.select((value) => null));
          });

          container.read(provider);
          container.read(selected);

          final element = container.readProviderElement(provider);
          final selectedElement = container.readProviderElement(selected);

          final ancestors = <ProviderElement>[];
          element.visitAncestors(ancestors.add);

          expect(ancestors, [selectedElement]);
        },
      );
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

      test('re-evaluating a provider can stop listening to a dependency', () {
        final container = ProviderContainer.test();
        final first = settableProvider((ref) => 0);
        final second = settableProvider((ref) => 0);
        final computed = Provider<String>((ref) {
          if (ref.watch(first) == 0) {
            return ref.watch(second).toString();
          }
          return 'fallback';
        });
        final firstElement = container.readProviderElement(first);
        final secondElement = container.readProviderElement(second);
        final computedElement = container.readProviderElement(computed);
        final sub = container.listen(computed, (_, _) {});

        expect(sub.read(), '0');
        var firstDependents = <ProviderElement>[];
        firstElement.visitChildren(firstDependents.add);
        var secondDependents = <ProviderElement>[];
        secondElement.visitChildren(secondDependents.add);

        expect(firstDependents, [computedElement]);
        expect(firstElement.hasNonWeakListeners, true);
        expect(secondDependents, [computedElement]);
        expect(secondElement.hasNonWeakListeners, true);

        container.read(first.notifier).state++;
        expect(sub.read(), 'fallback');

        firstDependents = <ProviderElement>[];
        firstElement.visitChildren(firstDependents.add);
        secondDependents = <ProviderElement>[];
        secondElement.visitChildren(secondDependents.add);
        expect(firstDependents, [computedElement]);
        expect(firstElement.hasNonWeakListeners, true);
        expect(secondDependents, <$ProviderElement<Object?>>[]);
        expect(secondElement.hasNonWeakListeners, false);
      });

      test('remove dependencies on dispose', () async {
        final container = ProviderContainer.test();
        final first = settableProvider((ref) => 0);
        final computed = Provider.autoDispose((ref) {
          return ref.watch(first);
        });
        final firstElement = container.readProviderElement(first);
        final computedElement = container.readProviderElement(computed);
        final sub = container.listen(computed, (_, _) {});

        expect(sub.read(), 0);
        var firstDependents = <ProviderElement>[];
        firstElement.visitChildren(firstDependents.add);
        expect(firstDependents, {computedElement});
        expect(firstElement.hasNonWeakListeners, true);

        sub.close();
        await container.pump();

        firstDependents = <ProviderElement>[];
        firstElement.visitChildren(firstDependents.add);
        expect(firstDependents, <$ProviderElement<Object?>>{});
        expect(firstElement.hasNonWeakListeners, false);
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

      test(
        'does not refresh providers if their dependencies changes but they have no active listeners',
        () async {
          final container = ProviderContainer.test();

          var buildCount = 0;
          final dep = settableProvider((ref) => 0);
          final provider = Provider((ref) {
            buildCount++;
            return ref.watch(dep);
          });

          container.read(provider);

          expect(buildCount, 1);

          container.read(dep.notifier).state++;
          await container.pump();

          expect(buildCount, 1);
        },
      );
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

        final dep = settableProvider((ref) => 0);
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

      final dep = settableProvider((ref) => 0);
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

    test(
      'throws StateError if the provider is disposed before a value was emitted',
      () async {
        final provider = StreamProvider<int>((ref) async* {});
        final container = ProviderContainer.test(
          overrides: [provider.overrideWithValue(const AsyncLoading())],
        );

        final future = container.read(provider.future);

        container.dispose();

        await expectLater(
          future,
          throwsA(
            isStateError.having(
              (e) => e.message,
              'message',
              equalsIgnoringHashCodes(
                'The provider StreamProvider<int>#00000 was disposed during loading state, '
                'yet no value could be emitted.',
              ),
            ),
          ),
        );
      },
    );

    group('auto dispose', () {
      test(
        'when a provider conditionally depends on another provider, rebuilding without the dependency can dispose the dependency',
        () async {
          final container = ProviderContainer.test();
          var dependencyDisposeCount = 0;
          final dependency = Provider.autoDispose(name: 'dependency', (ref) {
            ref.onDispose(() => dependencyDisposeCount++);
            return 0;
          });
          final isDependingOnDependency = settableProvider(
            name: 'isDependingOnDependency',
            (ref) => true,
          );
          final provider = Provider.autoDispose(name: 'provider', (ref) {
            if (ref.watch(isDependingOnDependency)) {
              ref.watch(dependency);
            }
          });

          container.listen<void>(provider, (_, _) {});

          expect(dependencyDisposeCount, 0);
          expect(
            container.getAllProviderElements().map((e) => e.provider),
            unorderedEquals(<Object>[
              dependency,
              provider,
              isDependingOnDependency,
            ]),
          );

          container.read(isDependingOnDependency.notifier).state = false;
          await container.pump();

          expect(dependencyDisposeCount, 1);
          expect(
            container.getAllProviderElements().map((e) => e.provider),
            unorderedEquals(<Object>[provider, isDependingOnDependency]),
          );
        },
      );

      test('works if used across a ProviderContainer', () async {
        var value = 0;
        var buildCount = 0;
        var disposeCount = 0;
        final listener = Listener<int>();
        final provider = Provider.autoDispose((ref) {
          buildCount++;
          ref.onDispose(() => disposeCount++);
          return value;
        });

        final root = ProviderContainer.test();
        final container = ProviderContainer.test(parent: root);

        final sub = container.listen(
          provider,
          listener.call,
          fireImmediately: true,
        );

        verifyOnly(listener, listener(null, 0));
        expect(buildCount, 1);
        expect(disposeCount, 0);

        sub.close();
        await container.pump();

        expect(buildCount, 1);
        expect(disposeCount, 1);
        verifyNoMoreInteractions(listener);
        expect(root.getAllProviderElements(), isEmpty);
        expect(container.getAllProviderElements(), isEmpty);

        value = 42;
        container.listen(provider, listener.call, fireImmediately: true);

        expect(buildCount, 2);
        expect(disposeCount, 1);
        verifyOnly(listener, listener(null, 42));
      });

      test(
        'unsub to A then make B sub to A then unsub to B disposes B before A',
        () async {
          final container = ProviderContainer.test();
          final aDispose = OnDisposeMock();
          final a = Provider.autoDispose((ref) {
            ref.onDispose(aDispose.call);
            return 42;
          });
          final bDispose = OnDisposeMock();
          final b = Provider.autoDispose((ref) {
            ref.onDispose(bDispose.call);
            ref.watch(a);
            return '42';
          });

          final subA = container.listen(a, (prev, value) {});
          subA.close();

          final subB = container.listen(b, (prev, value) {});
          subB.close();

          verifyNoMoreInteractions(aDispose);
          verifyNoMoreInteractions(bDispose);

          await container.pump();

          verifyInOrder([bDispose(), aDispose()]);
          verifyNoMoreInteractions(aDispose);
          verifyNoMoreInteractions(bDispose);
        },
      );

      test('chain', () async {
        final container = ProviderContainer.test();
        final onDispose = OnDisposeMock();
        var value = 42;
        final provider = Provider.autoDispose((ref) {
          ref.onDispose(onDispose.call);
          return value;
        });
        final onDispose2 = OnDisposeMock();
        final provider2 = Provider.autoDispose((ref) {
          ref.onDispose(onDispose2.call);
          return ref.watch(provider);
        });
        final listener = Listener<int>();

        var sub = container.listen(
          provider2,
          listener.call,
          fireImmediately: true,
        );

        verify(listener(null, 42)).called(1);
        verifyNoMoreInteractions(listener);
        verifyNoMoreInteractions(onDispose);
        verifyNoMoreInteractions(onDispose2);

        sub.close();

        verifyNoMoreInteractions(listener);
        verifyNoMoreInteractions(onDispose);
        verifyNoMoreInteractions(onDispose2);

        await container.pump();

        verifyNoMoreInteractions(listener);
        verifyInOrder([onDispose2(), onDispose()]);
        verifyNoMoreInteractions(onDispose);
        verifyNoMoreInteractions(onDispose2);

        value = 21;
        sub = container.listen(provider2, listener.call, fireImmediately: true);

        verify(listener(null, 21)).called(1);
        verifyNoMoreInteractions(listener);
        verifyNoMoreInteractions(onDispose);
        verifyNoMoreInteractions(onDispose2);
      });

      test(
        "auto dispose A then auto dispose B doesn't dispose A again",
        () async {
          final container = ProviderContainer.test();
          final aDispose = OnDisposeMock();
          final a = Provider.autoDispose((ref) {
            ref.onDispose(aDispose.call);
            return 42;
          });
          final bDispose = OnDisposeMock();
          final b = Provider.autoDispose((ref) {
            ref.onDispose(bDispose.call);
            return 42;
          });

          var subA = container.listen(a, (prev, value) {});
          verifyNoMoreInteractions(aDispose);
          verifyNoMoreInteractions(bDispose);
          subA.close();

          await container.pump();

          verify(aDispose()).called(1);
          verifyNoMoreInteractions(aDispose);
          verifyNoMoreInteractions(bDispose);

          subA = container.listen(a, (prev, value) {});
          final subB = container.listen(b, (prev, value) {});

          subB.close();

          await container.pump();

          verify(bDispose()).called(1);
          verifyNoMoreInteractions(aDispose);
          verifyNoMoreInteractions(bDispose);
        },
      );

      test('unsub no-op if another sub is added before event-loop', () async {
        final container = ProviderContainer.test();
        final onDispose = OnDisposeMock();
        final provider = Provider.autoDispose((ref) {
          ref.onDispose(onDispose.call);
          return 42;
        });

        final sub = container.listen(provider, (prev, value) {});

        verifyNoMoreInteractions(onDispose);

        sub.close();
        verifyNoMoreInteractions(onDispose);

        final sub2 = container.listen(provider, (prev, value) {});

        await container.pump();

        verifyNoMoreInteractions(onDispose);

        sub2.close();
        await container.pump();

        verify(onDispose()).called(1);
        verifyNoMoreInteractions(onDispose);
      });

      test(
        'no-op if when removing listener if there is still a listener',
        () async {
          final container = ProviderContainer.test();
          final onDispose = OnDisposeMock();
          final provider = Provider.autoDispose((ref) {
            ref.onDispose(onDispose.call);
            return 42;
          });

          final sub = container.listen(provider, (prev, value) {});
          final sub2 = container.listen(provider, (prev, value) {});

          verifyNoMoreInteractions(onDispose);

          sub.close();
          await container.pump();

          verifyNoMoreInteractions(onDispose);

          sub2.close();
          await container.pump();

          verify(onDispose()).called(1);
          verifyNoMoreInteractions(onDispose);
        },
      );

      test(
        'Supports clearing the state of elements with only weak listeners',
        () async {
          final container = ProviderContainer.test();
          final onDispose = OnDisposeMock();
          var buildCount = 0;
          final provider = Provider.autoDispose((ref) {
            buildCount++;
            ref.onDispose(onDispose.call);
            return 0;
          });

          final element = container.readProviderElement(provider);

          final sub = container.listen(
            provider,
            weak: true,
            (previous, value) {},
          );

          expect(sub.read(), 0);
          expect(buildCount, 1);
          verifyZeroInteractions(onDispose);

          await container.pump();

          verifyOnly(onDispose, onDispose());

          expect(buildCount, 1);
          expect(container.readProviderElement(provider), same(element));
          expect(element.stateResult(), null);

          expect(sub.read(), 0);
          expect(element.stateResult(), $ResultData(0));
          expect(buildCount, 2);
        },
      );

      test('if a dependency changed, the element is still disposed, '
          'but without calling ref.onDispose again', () async {
        final container = ProviderContainer.test();
        final onDispose = OnDisposeMock();
        final dep = settableProvider((ref) => 0);
        final provider = Provider.autoDispose((ref) {
          ref.onDispose(onDispose.call);
          return ref.watch(dep);
        });

        container.read(provider);
        verifyZeroInteractions(onDispose);
        container.read(dep.notifier).state++;

        expect(container.pointerManager.readPointer(provider), isNotNull);

        await container.pump();

        verify(onDispose()).called(1);

        expect(container.pointerManager.readPointer(provider), isNull);
      });
    });

    group('flush', () {
      test(
        'flushes listened-to providers even if they have no external listeners',
        () async {
          final dep = settableProvider((ref) => 0);
          final provider = Provider((ref) => ref.watch(dep));
          final another = NotifierProvider<Notifier<int>, int>(
            () => DeferredNotifier((ref, self) {
              ref.listen(provider, (prev, value) => self.state++);
              return 0;
            }),
          );
          final container = ProviderContainer.test();

          expect(container.read(another), 0);

          container.read(dep.notifier).state = 42;

          expect(container.read(another), 1);
        },
      );

      test(
        'flushes listened-to providers even if they have no external listeners (with ProviderListenable)',
        () async {
          final dep = settableProvider(name: 'dep', (ref) => 0);
          final provider = Provider(name: 'provider', (ref) => ref.watch(dep));
          final another = NotifierProvider<Notifier<int>, int>(
            name: 'another',
            () => DeferredNotifier((ref, self) {
              ref.listen(provider, (prev, value) => self.state++);
              return 0;
            }),
          );
          final container = ProviderContainer.test();

          expect(container.read(another), 0);

          container.read(dep.notifier).state = 42;

          expect(container.read(another), 1);
        },
      );
    });

    group('caching', () {
      test('the value is cached between multiple listeners', () {
        final container = ProviderContainer.test();
        final provider = NotifierProvider<Counter, int>(Counter.new);
        var callCount = 0;
        final computed = Provider((ref) {
          callCount++;
          return [ref.watch(provider)];
        });

        late List<int> first;
        final firstListener = Listener<List<int>>();
        container.listen<List<int>>(computed, fireImmediately: true, (
          prev,
          value,
        ) {
          first = value;
          firstListener(prev, value);
        });

        late List<int> second;
        final secondListener = Listener<List<int>>();
        container.listen<List<int>>(computed, fireImmediately: true, (
          prev,
          value,
        ) {
          second = value;
          secondListener(prev, value);
        });

        expect(first, [0]);
        expect(callCount, 1);
        expect(identical(first, second), isTrue);
        verifyInOrder([
          firstListener(null, [0]),
          secondListener(null, [0]),
        ]);
        verifyNoMoreInteractions(firstListener);
        verifyNoMoreInteractions(secondListener);
      });
    });

    group('rebuild', () {
      test(
        'Providers still rethrow error if dependency rebuilt but did not change',
        () {
          final container = ProviderContainer.test();
          var callCount = 0;
          final atom = settableProvider((ref) => 0);
          final dependency = Provider((ref) => ref.watch(atom));
          final provider = Provider((ref) {
            callCount++;
            ref.watch(dependency);
            if (callCount == 1) {
              throw StateError('err');
            }
          });

          expect(
            () => container.read(provider),
            throwsProviderException(isStateError),
          );
          expect(callCount, 1);

          container.read(atom.notifier).state = 0;

          expect(
            () => container.read(provider),
            throwsProviderException(isStateError),
          );
          expect(callCount, 1);
        },
      );
    });
  });
}
