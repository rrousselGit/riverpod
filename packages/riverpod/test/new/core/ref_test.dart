import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:riverpod/legacy.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod/src/internals.dart' show ProviderElementBase;
import 'package:test/test.dart';

import '../utils.dart';

// TODO automatically generate this list for maintainability
final refMethodsThatDependOnProviders =
    <String, void Function(Ref<Object?> ref, ProviderBase<Object?>)>{
  'watch': (ref, p) => ref.watch(p),
  'read': (ref, p) => ref.read(p),
  'listen': (ref, p) => ref.listen(p, (prev, next) {}),
  'invalidate': (ref, p) => ref.invalidate(p),
  'refresh': (ref, p) => ref.refresh(p),
};
final refMethodsThatDependOnListenables =
    <String, void Function(Ref<Object?> ref, ProviderListenable<Object?>)>{
  'watch': (ref, p) => ref.watch(p),
  'read': (ref, p) => ref.read(p),
  'listen': (ref, p) => ref.listen(p, (prev, next) {}),
};
final refMethodsThatDependOnProviderOrFamilies =
    <String, void Function(Ref<Object?> ref, ProviderOrFamily)>{
  'invalidate': (ref, p) => ref.invalidate(p),
};

void main() {
  group('Ref', () {
    // TODO ref.invalidate does not mount providers if they are not already mounted

    test(
      'cannot call ref.watch/ref.read/ref.listen/ref.onDispose after a dependency changed',
      () {
        // TODO assert invalidate & co also throw
        late Ref<Object?> ref;
        final container = ProviderContainer.test();
        final dep = StateProvider((ref) => 0);
        final provider = Provider((r) {
          r.watch(dep);
          ref = r;
        });

        container.read(provider);

        container.read(dep.notifier).state++;

        final another = Provider((ref) => 0);

        expect(
          () => ref.watch(another),
          throwsA(isA<AssertionError>()),
        );
        expect(
          () => ref.refresh(another),
          throwsA(isA<AssertionError>()),
        );
        expect(
          () => ref.read(another),
          throwsA(isA<AssertionError>()),
        );
        expect(
          () => ref.onDispose(() {}),
          throwsA(isA<AssertionError>()),
        );
        expect(
          () => ref.listen(another, (_, __) {}),
          throwsA(isA<AssertionError>()),
        );
      },
    );

    group(
        'asserts that a provider cannot depend on a provider that is not in its dependencies:',
        () {
      for (final entry in refMethodsThatDependOnProviders.entries) {
        final method = entry.key;
        final call = entry.value;

        test('Using `$method` when passing a provider', () {
          // TODO changelog "reading a provider that is not part of its dependencies is now forbidden"
          final transitiveDep = Provider((ref) => 0, dependencies: const []);
          final dep = Provider((ref) => 0, dependencies: [transitiveDep]);
          final depFamily = Provider.family(
            (ref, id) => 0,
            dependencies: const [],
          );
          final unrelatedScoped = Provider((ref) => 0, dependencies: const []);
          final unrelatedScopedFamily = Provider.family(
            (ref, i) => 0,
            dependencies: const [],
          );
          final nonScopedProvider = Provider((ref) => 0);
          final provider = Provider(
            (ref) => ref,
            dependencies: [dep, depFamily],
          );
          final family = Provider.family(
            (ref, id) => ref,
            dependencies: [dep, depFamily],
          );

          final container = ProviderContainer.test();
          final ref = container.read(provider);
          final ref2 = container.read(family(0));

          // accepts providers that are part of its dependencies
          call(ref, dep);
          call(ref2, dep);
          call(ref, depFamily(42));
          call(ref2, depFamily(42));

          // accepts non-scoped providers
          call(ref, nonScopedProvider);
          call(ref2, nonScopedProvider);

          // rejects providers that are not part of its dependencies
          expect(
            () => call(ref, transitiveDep),
            throwsA(isA<StateError>()),
          );
          expect(
            () => call(ref2, transitiveDep),
            throwsA(isA<StateError>()),
          );
          expect(
            () => call(ref, unrelatedScoped),
            throwsA(isA<StateError>()),
          );
          expect(
            () => call(ref2, unrelatedScoped),
            throwsA(isA<StateError>()),
          );
          expect(
            () => call(ref2, unrelatedScopedFamily(42)),
            throwsA(isA<StateError>()),
          );
        });
      }

      for (final entry in refMethodsThatDependOnListenables.entries) {
        final method = entry.key;
        final call = entry.value;

        test('Using `$method` when passing a listenable', () async {
          // TODO changelog "reading a provider that is not part of its dependencies is now forbidden"
          final transitiveDep = FutureProvider(
            (ref) => 0,
            dependencies: const [],
          );
          final dep = FutureProvider((ref) => 0, dependencies: [transitiveDep]);
          final depFamily = FutureProvider.family(
            (ref, id) => 0,
            dependencies: const [],
          );
          final unrelatedScoped = FutureProvider(
            (ref) => 0,
            dependencies: const [],
          );
          final nonScopedProvider = FutureProvider((ref) => 0);
          final provider = FutureProvider(
            (ref) => ref,
            dependencies: [dep, depFamily],
          );

          final container = ProviderContainer.test();
          final ref = container.read(provider).requireValue;

          // accepts providers that are part of its dependencies
          call(ref, dep.select((value) => 0));
          call(ref, dep.selectAsync((value) => 0));
          call(ref, depFamily(42).select((value) => 0));

          // accepts non-scoped providers
          call(ref, nonScopedProvider.select((value) => 0));

          // rejects providers that are not part of its dependencies
          await expectLater(
            () => call(ref, unrelatedScoped.select((value) => 0)),
            throwsA(isA<StateError>()),
          );
          await expectLater(
            () => call(ref, unrelatedScoped.selectAsync((value) => 0)),
            throwsA(isA<StateError>()),
          );
          await expectLater(
            () => call(ref, unrelatedScoped.future),
            throwsA(isA<StateError>()),
          );
        });
      }

      for (final entry in refMethodsThatDependOnProviderOrFamilies.entries) {
        final method = entry.key;
        final call = entry.value;

        test('Using `$method` when passing a family (not `family(arg)`)', () {
          final transitiveDep = Provider.family(
            (ref, i) => 0,
            dependencies: const [],
          );
          final dep = Provider.family(
            (ref, id) => 0,
            dependencies: [transitiveDep],
          );
          final unrelatedScoped = Provider.family(
            (ref, i) => 0,
            dependencies: const [],
          );
          final nonScopedProvider = Provider.family((ref, i) => 0);

          final provider = Provider(
            (ref) => ref,
            dependencies: [dep],
          );

          final container = ProviderContainer.test();
          final ref = container.read(provider);

          // accepts providers that are part of its dependencies
          call(ref, dep);

          // accepts non-scoped providers
          call(ref, nonScopedProvider);

          // rejects providers that are not part of its dependencies
          expect(
            () => call(ref, transitiveDep),
            throwsA(isA<StateError>()),
          );
          expect(
            () => call(ref, unrelatedScoped),
            throwsA(isA<StateError>()),
          );
        });
      }
    });

    group('listenSelf', () {
      test('does not break autoDispose', () async {
        final container = ProviderContainer.test();
        final provider = Provider.autoDispose((ref) {
          ref.listenSelf((previous, next) {});
        });

        container.read(provider);
        expect(container.getAllProviderElements(), [anything]);

        await container.pump();

        expect(container.getAllProviderElements(), isEmpty);
      });

      test('listens to mutations post build', () async {
        final container = ProviderContainer.test();
        final listener = Listener<int>();
        final listener2 = Listener<int>();

        late Ref<int> ref;
        final provider = Provider<int>((r) {
          ref = r;
          ref.listenSelf(listener.call);
          ref.listenSelf(listener2.call);

          return 0;
        });

        container.read(provider);

        verifyInOrder([
          listener(null, 0),
          listener2(null, 0),
        ]);
        verifyNoMoreInteractions(listener);
        verifyNoMoreInteractions(listener2);

        ref.state = 42;

        verifyInOrder([
          listener(0, 42),
          listener2(0, 42),
        ]);
        verifyNoMoreInteractions(listener);
        verifyNoMoreInteractions(listener2);
      });

      test('listens to rebuild', () async {
        final container = ProviderContainer.test();
        final listener = Listener<int>();
        final listener2 = Listener<int>();
        var result = 0;
        final provider = Provider<int>((ref) {
          ref.listenSelf(listener.call);
          ref.listenSelf(listener2.call);

          return result;
        });

        container.read(provider);

        verifyInOrder([
          listener(null, 0),
          listener2(null, 0),
        ]);
        verifyNoMoreInteractions(listener);
        verifyNoMoreInteractions(listener2);

        result = 42;
        container.refresh(provider);

        verifyInOrder([
          listener(0, 42),
          listener2(0, 42),
        ]);
        verifyNoMoreInteractions(listener);
        verifyNoMoreInteractions(listener2);
      });

      test('notify listeners independently from updateShouldNotify', () async {
        final container = ProviderContainer.test();
        final listener = Listener<int>();
        final listener2 = Listener<int>();
        final provider = Provider<int>((ref) {
          ref.listenSelf(listener.call);
          ref.listenSelf(listener2.call);

          return 0;
        });

        container.read(provider);

        verifyInOrder([
          listener(null, 0),
          listener2(null, 0),
        ]);
        verifyNoMoreInteractions(listener);
        verifyNoMoreInteractions(listener2);

        container.refresh(provider);

        verifyInOrder([
          listener(0, 0),
          listener2(0, 0),
        ]);
        verifyNoMoreInteractions(listener);
        verifyNoMoreInteractions(listener2);
      });

      test('clears state listeners on rebuild', () async {
        final container = ProviderContainer.test();
        final listener = Listener<int>();
        final listener2 = Listener<int>();
        var result = 0;
        final provider = Provider<int>((ref) {
          if (result == 0) {
            ref.listenSelf(listener.call);
          } else {
            ref.listenSelf(listener2.call);
          }

          return result;
        });

        container.read(provider);

        verifyOnly(listener, listener(null, 0));
        verifyNoMoreInteractions(listener);
        verifyNoMoreInteractions(listener2);

        result = 42;
        container.refresh(provider);

        verifyOnly(listener2, listener2(0, 42));
        verifyNoMoreInteractions(listener);
        verifyNoMoreInteractions(listener2);
      });

      test('listens to errors', () {
        final container = ProviderContainer.test();
        final listener = Listener<int>();
        final errorListener = ErrorListener();
        final errorListener2 = ErrorListener();
        var error = 42;
        final provider = Provider<int>((ref) {
          ref.listenSelf(listener.call, onError: errorListener.call);
          ref.listenSelf((prev, next) {}, onError: errorListener2.call);

          Error.throwWithStackTrace(error, StackTrace.empty);
        });

        expect(() => container.read(provider), throwsA(42));

        verifyZeroInteractions(listener);
        verifyInOrder([
          errorListener(42, StackTrace.empty),
          errorListener2(42, StackTrace.empty),
        ]);
        verifyNoMoreInteractions(errorListener);
        verifyNoMoreInteractions(errorListener2);

        error = 21;
        expect(() => container.refresh(provider), throwsA(21));

        verifyZeroInteractions(listener);

        verifyInOrder([
          errorListener(21, StackTrace.empty),
          errorListener2(21, StackTrace.empty),
        ]);
        verifyNoMoreInteractions(errorListener);
        verifyNoMoreInteractions(errorListener2);
      });

      test('executes error listener before other listeners', () {
        final container = ProviderContainer.test();
        final errorListener = ErrorListener();
        final errorListener2 = ErrorListener();
        Exception? error;
        final provider = Provider<int>((ref) {
          ref.listenSelf((prev, next) {}, onError: errorListener.call);

          if (error != null) Error.throwWithStackTrace(error, StackTrace.empty);

          return 0;
        });

        container.listen(
          provider,
          (prev, next) {},
          onError: errorListener2.call,
        );

        verifyZeroInteractions(errorListener);
        verifyZeroInteractions(errorListener2);

        error = Exception();
        expect(() => container.refresh(provider), throwsA(error));

        verifyInOrder([
          errorListener(error, StackTrace.empty),
          errorListener2(error, StackTrace.empty),
        ]);
        verifyNoMoreInteractions(errorListener);
        verifyNoMoreInteractions(errorListener2);
      });

      test('executes state listener before other listeners', () {
        final container = ProviderContainer.test();
        final listener = Listener<int>();
        final listener2 = Listener<int>();
        var result = 0;
        final provider = Provider<int>((ref) {
          ref.listenSelf(listener.call);
          return result;
        });

        container.listen(provider, listener2.call, fireImmediately: true);

        verifyInOrder([
          listener(null, 0),
          listener2(null, 0),
        ]);
        verifyNoMoreInteractions(listener);
        verifyNoMoreInteractions(listener2);

        result = 42;
        container.refresh(provider);

        verifyInOrder([
          listener(0, 42),
          listener2(0, 42),
        ]);
        verifyNoMoreInteractions(listener);
        verifyNoMoreInteractions(listener2);
      });

      test('listeners are not allowed to modify the state', () {});
    });

    group('listen', () {
      test('ref.listen on outdated provider causes it to rebuild', () {
        final dep = StateProvider((ref) => 0);
        var buildCount = 0;
        final provider = Provider((ref) {
          buildCount++;
          return ref.watch(dep);
        });
        final listener = Listener<int>();
        final another = Provider((ref) {
          ref.listen<int>(provider, listener.call, fireImmediately: true);
        });
        final container = ProviderContainer.test();

        expect(container.read(provider), 0);
        expect(buildCount, 1);

        container.read(dep.notifier).state = 42;

        expect(buildCount, 1);

        container.read(another);

        expect(buildCount, 2);
        verifyOnly(listener, listener(null, 42));
      });

      test('can downcast the value', () async {
        final listener = Listener<num>();
        final dep = StateProvider((ref) => 0);
        final provider = Provider((ref) {
          ref.listen<num>(dep, listener.call);
        });

        final container = ProviderContainer.test();
        container.read(provider);

        verifyZeroInteractions(listener);

        container.read(dep.notifier).state++;
        await container.pump();

        verifyOnly(listener, listener(0, 1));
      });

      test('can listen selectors', () async {
        final container = ProviderContainer.test();
        final provider =
            StateNotifierProvider<StateController<int>, int>((ref) {
          return StateController(0);
        });
        final isEvenSelector = Selector<int, bool>(false, (c) => c.isEven);
        final isEvenListener = Listener<bool>();
        var buildCount = 0;

        final another = Provider<int>((ref) {
          buildCount++;
          ref.listen<bool>(
            provider.select(isEvenSelector.call),
            isEvenListener.call,
          );
          return 0;
        });

        container.read(another);

        expect(buildCount, 1);
        verifyZeroInteractions(isEvenListener);
        verifyOnly(isEvenSelector, isEvenSelector(0));

        container.read(provider.notifier).state = 2;

        verifyOnly(isEvenSelector, isEvenSelector(2));
        verifyZeroInteractions(isEvenListener);

        container.read(provider.notifier).state = 3;

        verifyOnly(isEvenSelector, isEvenSelector(3));
        verifyOnly(isEvenListener, isEvenListener(true, false));

        container.read(provider.notifier).state = 4;

        verifyOnly(isEvenSelector, isEvenSelector(4));
        verifyOnly(isEvenListener, isEvenListener(false, true));

        await container.pump();

        expect(buildCount, 1);
      });

      test('listen on selectors supports fireImmediately', () async {
        final container = ProviderContainer.test();
        final provider =
            StateNotifierProvider<StateController<int>, int>((ref) {
          return StateController(0);
        });
        final isEvenSelector = Selector<int, bool>(false, (c) => c.isEven);
        final isEvenListener = Listener<bool>();
        var buildCount = 0;

        final another = Provider<int>((ref) {
          buildCount++;
          ref.listen<bool>(
            provider.select(isEvenSelector.call),
            isEvenListener.call,
            fireImmediately: true,
          );
          return 0;
        });

        container.read(another);

        expect(buildCount, 1);
        verifyOnly(isEvenListener, isEvenListener(null, true));
        verifyOnly(isEvenSelector, isEvenSelector(0));

        container.read(provider.notifier).state = 2;

        verifyOnly(isEvenSelector, isEvenSelector(2));
        verifyNoMoreInteractions(isEvenListener);

        container.read(provider.notifier).state = 3;

        verifyOnly(isEvenSelector, isEvenSelector(3));
        verifyOnly(isEvenListener, isEvenListener(true, false));

        await container.pump();

        expect(buildCount, 1);
      });

      test(
          'when rebuild throws identical error/stack, listeners are still notified',
          () {
        final container = ProviderContainer.test();
        const stack = StackTrace.empty;
        final listener = Listener<int>();
        final errorListener = ErrorListener();
        final provider = Provider<int>((ref) {
          Error.throwWithStackTrace(42, stack);
        });

        container.listen(
          provider,
          listener.call,
          onError: errorListener.call,
          fireImmediately: true,
        );

        verifyZeroInteractions(listener);
        verifyOnly(errorListener, errorListener(42, stack));

        expect(() => container.refresh(provider), throwsA(42));

        verifyZeroInteractions(listener);
        verifyOnly(errorListener, errorListener(42, stack));
      });

      test('cannot listen itself', () {
        final container = ProviderContainer.test();
        final listener = Listener<int>();
        late Ref<int> ref;
        late Provider<int> provider;
        provider = Provider<int>((r) {
          ref = r;
          ref.listen(provider, (previous, next) {});
          return 0;
        });

        expect(() => container.read(provider), throwsA(isAssertionError));

        ref.state = 42;

        verifyZeroInteractions(listener);
      });

      test('expose previous and new value on change', () {
        final container = ProviderContainer.test();
        final dep = StateNotifierProvider<StateController<int>, int>(
          (ref) => StateController(0),
        );
        final listener = Listener<int>();
        final provider = Provider((ref) {
          ref.listen<int>(dep, listener.call, fireImmediately: true);
        });

        container.read(provider);

        verifyOnly(listener, listener(null, 0));

        container.read(dep.notifier).state++;

        verifyOnly(listener, listener(0, 1));
      });

      test(
          'calling ref.listen on a provider with an outdated dependency flushes it, then add the listener',
          () {
        final container = ProviderContainer.test();
        var buildCount = 0;
        final dep2 = StateNotifierProvider<StateController<int>, int>(
          (ref) => StateController(0),
        );
        final dep = Provider<int>((ref) {
          buildCount++;
          return ref.watch(dep2);
        });
        final listener = Listener<int>();
        final provider = Provider((ref) {
          ref.listen<int>(dep, listener.call);
        });

        container.read(dep);
        container.read(dep2.notifier).state++; // mark `dep` as outdated

        expect(buildCount, 1);
        verifyZeroInteractions(listener);

        container.read(provider);

        expect(buildCount, 2);
        verifyZeroInteractions(listener);
      });

      test(
          'when using selectors, `previous` is the latest notification instead of latest event',
          () {
        final container = ProviderContainer.test();
        final dep = StateNotifierProvider<StateController<int>, int>(
          (ref) => StateController(0),
        );
        final listener = Listener<bool>();
        final provider = Provider((ref) {
          ref.listen<bool>(
            dep.select((value) => value.isEven),
            listener.call,
            fireImmediately: true,
          );
        });

        container.read(provider);
        verifyOnly(listener, listener(null, true));

        container.read(dep.notifier).state += 2;

        verifyNoMoreInteractions(listener);

        container.read(dep.notifier).state++;

        verifyOnly(listener, listener(true, false));
      });

      test('when no onError is specified, fallbacks to handleUncaughtError',
          () async {
        final container = ProviderContainer.test();
        final isErrored = StateProvider((ref) => false);
        final dep = Provider<int>((ref) {
          if (ref.watch(isErrored)) throw UnimplementedError();
          return 0;
        });
        final listener = Listener<int>();
        final errors = <Object>[];
        final provider = Provider((ref) {
          runZonedGuarded(
            () => ref.listen(dep, listener.call),
            (err, stack) => errors.add(err),
          );
        });

        container.read(provider);

        verifyZeroInteractions(listener);
        expect(errors, isEmpty);

        container.read(isErrored.notifier).state = true;

        await container.pump();

        verifyZeroInteractions(listener);
        expect(errors, [isUnimplementedError]);
      });

      test(
          'when no onError is specified, selectors fallbacks to handleUncaughtError',
          () async {
        final container = ProviderContainer.test();
        final isErrored = StateProvider((ref) => false);
        final dep = Provider<int>((ref) {
          if (ref.watch(isErrored)) throw UnimplementedError();
          return 0;
        });
        final listener = Listener<int>();
        final errors = <Object>[];
        final provider = Provider((ref) {
          runZonedGuarded(
            () => ref.listen(dep.select((value) => value), listener.call),
            (err, stack) => errors.add(err),
          );
        });

        container.read(provider);

        verifyZeroInteractions(listener);
        expect(errors, isEmpty);

        container.read(isErrored.notifier).state = true;

        await container.pump();

        verifyZeroInteractions(listener);
        expect(errors, [isUnimplementedError]);
      });

      test('when rebuild throws, calls onError', () async {
        final container = ProviderContainer.test();
        final dep = StateProvider((ref) => 0);
        final provider = Provider((ref) {
          if (ref.watch(dep) != 0) {
            throw UnimplementedError();
          }
          return 0;
        });
        final errorListener = ErrorListener();
        final listener = Listener<int>();

        final a = Provider((ref) {
          ref.listen(provider, listener.call, onError: errorListener.call);
        });

        container.read(a);

        verifyZeroInteractions(errorListener);
        verifyZeroInteractions(listener);

        container.read(dep.notifier).state++;
        await container.pump();

        verifyZeroInteractions(listener);
        verifyOnly(
          errorListener,
          errorListener(isUnimplementedError, any),
        );
      });

      test('when rebuild throws on selector, calls onError', () async {
        final container = ProviderContainer.test();
        final dep = StateProvider((ref) => 0);
        final provider = Provider((ref) {
          if (ref.watch(dep) != 0) {
            throw UnimplementedError();
          }
          return 0;
        });
        final errorListener = ErrorListener();
        final listener = Listener<int>();

        final a = Provider((ref) {
          ref.listen(
            provider.select((value) => value),
            listener.call,
            onError: errorListener.call,
          );
        });

        container.read(a);

        verifyZeroInteractions(errorListener);
        verifyZeroInteractions(listener);

        container.read(dep.notifier).state++;
        await container.pump();

        verifyZeroInteractions(listener);
        verifyOnly(
          errorListener,
          errorListener(isUnimplementedError, any),
        );
      });

      group('fireImmediately', () {
        test('when no onError is specified, fallbacks to handleUncaughtError',
            () {
          final container = ProviderContainer.test();
          final dep = Provider<int>((ref) => throw UnimplementedError());
          final listener = Listener<int>();
          final errors = <Object>[];
          final provider = Provider((ref) {
            runZonedGuarded(
              () {
                ref.listen(
                  dep,
                  listener.call,
                  fireImmediately: true,
                );
              },
              (err, stack) => errors.add(err),
            );
          });

          container.read(provider);

          verifyZeroInteractions(listener);
          expect(errors, [
            isUnimplementedError,
          ]);
        });

        test(
            'when no onError is specified on selectors, fallbacks to handleUncaughtError',
            () {
          final container = ProviderContainer.test();
          final dep = Provider<int>((ref) => throw UnimplementedError());
          final listener = Listener<int>();
          final errors = <Object>[];
          final provider = Provider((ref) {
            runZonedGuarded(
              () {
                ref.listen(
                  dep.select((value) => value),
                  listener.call,
                  fireImmediately: true,
                );
              },
              (err, stack) => errors.add(err),
            );
          });

          container.read(provider);

          verifyZeroInteractions(listener);
          expect(errors, [
            isUnimplementedError,
          ]);
        });

        test('on provider that threw, fireImmediately calls onError', () {
          final container = ProviderContainer.test();
          final dep = Provider<int>((ref) => throw UnimplementedError());
          final listener = Listener<int>();
          final errorListener = ErrorListener();
          final provider = Provider((ref) {
            ref.listen(
              dep,
              listener.call,
              onError: errorListener.call,
              fireImmediately: true,
            );
          });

          container.read(provider);

          verifyZeroInteractions(listener);
          verifyOnly(
            errorListener,
            errorListener(isUnimplementedError, argThat(isNotNull)),
          );
        });

        test(
            'when selecting provider that threw, fireImmediately calls onError',
            () {
          final container = ProviderContainer.test();
          final dep = Provider<String>((ref) => throw UnimplementedError());
          final listener = Listener<int>();
          final errorListener = ErrorListener();
          final provider = Provider((ref) {
            ref.listen<int>(
              dep.select((value) => 0),
              listener.call,
              onError: errorListener.call,
              fireImmediately: true,
            );
          });

          container.read(provider);

          verifyZeroInteractions(listener);
          verifyOnly(
            errorListener,
            errorListener(isUnimplementedError, argThat(isNotNull)),
          );
        });

        test('correctly listens to the provider if selector listener throws',
            () {
          final dep = StateProvider((ref) => 0);
          final listener = Listener<int>();
          var isFirstCall = true;

          final container = ProviderContainer.test();
          final errors = <Object>[];

          ProviderSubscription<int>? sub;

          final provider = Provider((ref) {
            sub = runZonedGuarded(
              () => ref.listen<int>(
                dep.select((value) => value),
                (prev, value) {
                  listener(prev, value);
                  if (isFirstCall) {
                    isFirstCall = false;
                    throw StateError('Some error');
                  }
                },
                fireImmediately: true,
              ),
              (err, stack) => errors.add(err),
            );
          });

          container.listen<void>(provider, (prev, value) {});

          expect(sub, isNotNull);
          verifyOnly(listener, listener(null, 0));
          expect(errors, [isStateError]);

          container.read(dep.notifier).state++;
          verifyOnly(listener, listener(0, 1));
        });

        test('correctly listens to the provider if normal listener throws', () {
          final dep = StateProvider((ref) => 0);
          final listener = Listener<int>();
          var isFirstCall = true;

          final container = ProviderContainer.test();
          final errors = <Object>[];

          ProviderSubscription<int>? sub;

          final provider = Provider((ref) {
            sub = runZonedGuarded(
              () => ref.listen<int>(
                dep,
                (prev, value) {
                  listener(prev, value);
                  if (isFirstCall) {
                    isFirstCall = false;
                    throw StateError('Some error');
                  }
                },
                fireImmediately: true,
              ),
              (err, stack) => errors.add(err),
            );
          });

          container.listen<void>(provider, (prev, value) {});

          expect(sub, isNotNull);
          verifyOnly(listener, listener(null, 0));
          expect(errors, [isStateError]);

          container.read(dep.notifier).state++;
          verifyOnly(listener, listener(0, 1));
        });

        test(
            'correctly listens to the provider if selector onError listener throws',
            () async {
          final dep = StateProvider<int>((ref) => 0);
          final dep2 = Provider<int>((ref) {
            if (ref.watch(dep) == 0) {
              throw UnimplementedError();
            }
            return ref.watch(dep);
          });
          final listener = Listener<int>();
          final errorListener = ErrorListener();
          var isFirstCall = true;

          final container = ProviderContainer.test();
          final errors = <Object>[];

          ProviderSubscription<int>? sub;

          final provider = Provider((ref) {
            sub = runZonedGuarded(
              () => ref.listen<int>(
                dep2.select((value) => value),
                listener.call,
                onError: (err, stack) {
                  errorListener(err, stack);
                  if (isFirstCall) {
                    isFirstCall = false;
                    throw StateError('Some error');
                  }
                },
                fireImmediately: true,
              ),
              (err, stack) => errors.add(err),
            );
          });

          container.read(provider);

          expect(sub, isNotNull);
          verifyZeroInteractions(listener);
          verifyOnly(
            errorListener,
            errorListener(argThat(isUnimplementedError), argThat(isNotNull)),
          );
          expect(errors, [isStateError]);

          container.read(dep.notifier).state++;
          await container.pump();

          verifyNoMoreInteractions(errorListener);
          verifyOnly(listener, listener(null, 1));
        });

        test(
            'correctly listens to the provider if normal onError listener throws',
            () async {
          final dep = StateProvider<int>((ref) => 0);
          final dep2 = Provider<int>((ref) {
            if (ref.watch(dep) == 0) {
              throw UnimplementedError();
            }
            return ref.watch(dep);
          });
          final listener = Listener<int>();
          final errorListener = ErrorListener();
          var isFirstCall = true;

          final container = ProviderContainer.test();
          final errors = <Object>[];

          ProviderSubscription<int>? sub;

          final provider = Provider((ref) {
            sub = runZonedGuarded(
              () => ref.listen<int>(
                dep2,
                listener.call,
                onError: (err, stack) {
                  errorListener(err, stack);
                  if (isFirstCall) {
                    isFirstCall = false;
                    throw StateError('Some error');
                  }
                },
                fireImmediately: true,
              ),
              (err, stack) => errors.add(err),
            );
          });

          container.read(provider);

          expect(sub, isNotNull);
          verifyZeroInteractions(listener);
          verifyOnly(
            errorListener,
            errorListener(argThat(isUnimplementedError), argThat(isNotNull)),
          );
          expect(errors, [isStateError]);

          container.read(dep.notifier).state++;
          await container.pump();

          verifyNoMoreInteractions(errorListener);
          verifyOnly(listener, listener(null, 1));
        });
      });
    });

    group('keepAlive', () {
      test(
          'Does not cause an infinite loop if aborted directly in the callback',
          () async {
        final container = ProviderContainer.test();
        var buildCount = 0;
        var disposeCount = 0;
        final provider = Provider.autoDispose<String>((ref) {
          buildCount++;
          ref.onDispose(() => disposeCount++);
          final link = ref.keepAlive();
          link.close();
          return 'value';
        });

        container.read(provider);

        expect(buildCount, 1);
        expect(disposeCount, 0);
        expect(
          container.getAllProviderElements().map((e) => e.provider),
          [provider],
        );

        await container.pump();

        expect(buildCount, 1);
        expect(disposeCount, 1);
        expect(
          container.getAllProviderElements().map((e) => e.provider),
          isEmpty,
        );
      });

      test('when the provider rebuilds, links are cleared', () async {
        final container = ProviderContainer.test();
        final dep = StateProvider((ref) => 0);
        KeepAliveLink? a;

        final provider = Provider.autoDispose<void>((ref) {
          ref.watch(dep);
          a ??= ref.keepAlive();
        });

        container.read(provider);
        await container.pump();

        expect(
          container.getAllProviderElements().map((e) => e.provider),
          contains(provider),
        );

        container.read(dep.notifier).state++;
        // manually trigger rebuild, as the provider is not listened
        container.read(provider);
        await container.pump();

        expect(
          container.getAllProviderElements().map((e) => e.provider),
          isNot(contains(provider)),
        );
      });

      test('maintains the state of the provider until all links are closed',
          () async {
        final container = ProviderContainer.test();
        late KeepAliveLink a;
        late KeepAliveLink b;

        final provider = Provider.autoDispose<void>((ref) {
          a = ref.keepAlive();
          b = ref.keepAlive();
        });

        container.read(provider);

        expect(
          container.getAllProviderElements().map((e) => e.provider),
          [provider],
        );

        await container.pump();

        expect(
          container.getAllProviderElements().map((e) => e.provider),
          [provider],
        );

        a.close();
        await container.pump();

        expect(
          container.getAllProviderElements().map((e) => e.provider),
          [provider],
        );

        b.close();
        await container.pump();

        expect(
          container.getAllProviderElements(),
          isEmpty,
        );
      });

      test(
          'when closing KeepAliveLink, does not dispose the provider if it is still being listened to',
          () async {
        final container = ProviderContainer.test();
        late KeepAliveLink a;

        final provider = Provider.autoDispose<void>((ref) {
          a = ref.keepAlive();
        });

        final sub = container.listen<void>(provider, (previous, next) {});

        a.close();
        await container.pump();

        expect(
          container.getAllProviderElements().map((e) => e.provider),
          [provider],
        );

        sub.close();
        await container.pump();

        expect(
          container.getAllProviderElements().map((e) => e.provider),
          isEmpty,
        );
      });

      test(
          'when closing the last KeepAliveLink, then immediately adding a new link, '
          'the provider will not be disposed.', () async {
        final container = ProviderContainer.test();
        late KeepAliveLink a;
        late Ref<Object?> ref;

        final provider = Provider.autoDispose<void>((r) {
          ref = r;
          a = ref.keepAlive();
        });

        container.read<void>(provider);

        a.close();
        final b = ref.keepAlive();
        await container.pump();

        expect(
          container.getAllProviderElements().map((e) => e.provider),
          [provider],
        );

        b.close();
        await container.pump();

        expect(
          container.getAllProviderElements().map((e) => e.provider),
          isEmpty,
        );
      });
    });

    group('refresh', () {
      test('refreshes a provider and return the new state', () {
        var value = 0;
        final state = Provider((ref) => value);
        late Ref<Object?> ref;
        final provider = Provider((r) {
          ref = r;
        });
        final container = ProviderContainer.test();

        container.read(provider);

        expect(container.read(state), 0);

        value = 42;
        expect(ref.refresh(state), 42);
        expect(container.read(state), 42);
      });
    });

    group('.onDispose', () {
      test(
          'calls all the listeners in order when the ProviderContainer is disposed',
          () {
        final onDispose = OnDisposeMock();
        final onDispose2 = OnDisposeMock();
        final provider = Provider((ref) {
          ref.onDispose(onDispose.call);
          ref.onDispose(onDispose2.call);
        });

        final container = ProviderContainer();
        addTearDown(container.dispose);

        container.read(provider); // register the onDispose hooks

        verifyZeroInteractions(onDispose);
        verifyZeroInteractions(onDispose2);

        container.dispose();

        verifyInOrder([
          onDispose(),
          onDispose2(),
        ]);
        verifyNoMoreInteractions(onDispose);
        verifyNoMoreInteractions(onDispose2);
      });

      test('calls all listeners in order when one of its dependency changed',
          () async {
        final onDispose = OnDisposeMock();
        final onDispose2 = OnDisposeMock();

        final count = StateProvider((ref) => 0);
        final provider = Provider((ref) {
          ref.watch(count);
          ref.onDispose(onDispose.call);
          ref.onDispose(onDispose2.call);
        });

        final container = ProviderContainer();
        addTearDown(container.dispose);

        container.read(provider); // register the onDispose hooks

        verifyZeroInteractions(onDispose);
        verifyZeroInteractions(onDispose2);

        container.read(count.notifier).state++;
        await container.pump();

        verifyInOrder([
          onDispose(),
          onDispose2(),
        ]);
        verifyNoMoreInteractions(onDispose);
        verifyNoMoreInteractions(onDispose2);
      });

      test('does not call listeners again if more than one dependency changed',
          () {
        final onDispose = OnDisposeMock();

        final count = StateProvider((ref) => 0);
        final count2 = StateProvider((ref) => 0);
        final provider = Provider((ref) {
          ref.watch(count);
          ref.watch(count2);
          ref.onDispose(onDispose.call);
        });

        final container = ProviderContainer();
        addTearDown(container.dispose);

        container.read(provider); // register the onDispose hooks

        verifyZeroInteractions(onDispose);

        container.read(count.notifier).state++;
        container.read(count2.notifier).state++;

        verifyOnly(onDispose, onDispose());
      });

      test(
          'does not call listeners again if a dependency changed then ProviderContainer was disposed',
          () async {
        final onDispose = OnDisposeMock();
        var buildCount = 0;

        final count = StateProvider((ref) => 0);
        final provider = Provider((ref) {
          buildCount++;
          ref.watch(count);
          ref.onDispose(onDispose.call);
        });

        final container = ProviderContainer();
        addTearDown(container.dispose);

        container.read(provider); // register the onDispose hooks
        expect(buildCount, 1);

        verifyZeroInteractions(onDispose);

        container.read(count.notifier).state++;
        // no pump() because that would rebuild the provider, which means it would
        // need to be disposed once again.

        verifyOnly(onDispose, onDispose());

        container.dispose();

        expect(buildCount, 1);
        verifyNoMoreInteractions(onDispose);
      });

      test(
        'once a provider was disposed, cannot add more listeners until it is rebuilt',
        () {},
        skip: 'TODO',
      );
    });

    group('mounted', () {
      test('is false during onDispose caused by ref.watch', () {
        final container = ProviderContainer.test();
        bool? mounted;
        late ProviderElementBase<Object?> element;
        final dep = StateProvider((ref) => 0);
        final provider = Provider((ref) {
          ref.watch(dep);
          element = ref as ProviderElementBase;
          ref.onDispose(() => mounted = element.mounted);
        });

        container.read(provider);
        expect(mounted, null);

        container.read(dep.notifier).state++;

        expect(mounted, false);
      });

      test('is false during onDispose caused by container dispose', () {
        final container = ProviderContainer.test();
        bool? mounted;
        late ProviderElementBase<Object?> element;
        final dep = StateProvider((ref) => 0);
        final provider = Provider((ref) {
          ref.watch(dep);
          element = ref as ProviderElementBase;
          ref.onDispose(() => mounted = element.mounted);
        });

        container.read(provider);
        expect(mounted, null);

        container.dispose();

        expect(mounted, false);
      });

      test('is false in between rebuilds', () {
        final container = ProviderContainer.test();
        final dep = StateProvider((ref) => 0);
        late ProviderElementBase<Object?> element;
        final provider = Provider((ref) {
          ref.watch(dep);
          element = ref as ProviderElementBase;
        });

        container.read(provider);
        expect(element.mounted, true);

        container.read(dep.notifier).state++;

        expect(element.mounted, false);
      });
    });
  });
}
