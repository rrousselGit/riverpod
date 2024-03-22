import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart' hide ErrorListener;
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import '../utils.dart';

void main() {
  group('Ref.listenSelf', () {
    test('does not break autoDispose', () async {
      final container = createContainer();
      final provider = Provider.autoDispose((ref) {
        ref.listenSelf((previous, next) {});
      });

      container.read(provider);
      expect(container.getAllProviderElements(), [anything]);

      await container.pump();

      expect(container.getAllProviderElements(), isEmpty);
    });

    test('listens to mutations post build', () async {
      final container = createContainer();
      final listener = Listener<int>();
      final listener2 = Listener<int>();

      late ProviderRef<int> ref;
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
      final container = createContainer();
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
      final container = createContainer();
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
      final container = createContainer();
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
      final container = createContainer();
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
      final container = createContainer();
      final errorListener = ErrorListener();
      final errorListener2 = ErrorListener();
      Exception? error;
      final provider = Provider<int>((ref) {
        ref.listenSelf((prev, next) {}, onError: errorListener.call);

        if (error != null) Error.throwWithStackTrace(error, StackTrace.empty);

        return 0;
      });

      container.listen(provider, (prev, next) {}, onError: errorListener2.call);

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
      final container = createContainer();
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

  group('Ref.listen', () {
    test(
        'when rebuild throws identical error/stack, listeners are still notified',
        () {
      final container = createContainer();
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
      final container = createContainer();
      final listener = Listener<int>();
      late ProviderRef<int> ref;
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
      final container = createContainer();
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
      final container = createContainer();
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
      final container = createContainer();
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
      final container = createContainer();
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
      final container = createContainer();
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
      final container = createContainer();
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
      final container = createContainer();
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
        final container = createContainer();
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
        final container = createContainer();
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
        final container = createContainer();
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

      test('when selecting provider that threw, fireImmediately calls onError',
          () {
        final container = createContainer();
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

      test('correctly listens to the provider if selector listener throws', () {
        final dep = StateProvider((ref) => 0);
        final listener = Listener<int>();
        var isFirstCall = true;

        final container = createContainer();
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

        final container = createContainer();
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

        final container = createContainer();
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

        final container = createContainer();
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

  group('ProviderContainer.listen', () {
    test('when no onError is specified, fallbacks to handleUncaughtError',
        () async {
      final container = createContainer();
      final isErrored = StateProvider((ref) => false);
      final dep = Provider<int>((ref) {
        if (ref.watch(isErrored)) throw UnimplementedError();
        return 0;
      });
      final listener = Listener<int>();
      final errors = <Object>[];

      runZonedGuarded(
        () => container.listen(dep, listener.call),
        (err, stack) => errors.add(err),
      );

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
      final container = createContainer();
      final isErrored = StateProvider((ref) => false);
      final dep = Provider<int>((ref) {
        if (ref.watch(isErrored)) throw UnimplementedError();
        return 0;
      });
      final listener = Listener<int>();
      final errors = <Object>[];

      runZonedGuarded(
        () => container.listen(dep.select((value) => value), listener.call),
        (err, stack) => errors.add(err),
      );

      verifyZeroInteractions(listener);
      expect(errors, isEmpty);

      container.read(isErrored.notifier).state = true;

      await container.pump();

      verifyZeroInteractions(listener);
      expect(errors, [isUnimplementedError]);
    });

    test('when rebuild throws, calls onError', () async {
      final container = createContainer();
      final dep = StateProvider((ref) => 0);
      final provider = Provider((ref) {
        if (ref.watch(dep) != 0) {
          throw UnimplementedError();
        }
        return 0;
      });
      final errorListener = ErrorListener();
      final listener = Listener<int>();

      container.listen(provider, listener.call, onError: errorListener.call);

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
      final container = createContainer();
      final dep = StateProvider((ref) => 0);
      final provider = Provider((ref) {
        if (ref.watch(dep) != 0) {
          throw UnimplementedError();
        }
        return 0;
      });
      final errorListener = ErrorListener();
      final listener = Listener<int>();

      container.listen(
        provider.select((value) => value),
        listener.call,
        onError: errorListener.call,
      );

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

    test(
        'when using selectors, `previous` is the latest notification instead of latest event',
        () {
      final container = createContainer();
      final provider = StateNotifierProvider<StateController<int>, int>(
        (ref) => StateController(0),
      );
      final listener = Listener<bool>();

      container.listen<bool>(
        provider.select((value) => value.isEven),
        listener.call,
        fireImmediately: true,
      );

      verifyOnly(listener, listener(null, true));

      container.read(provider.notifier).state += 2;

      verifyNoMoreInteractions(listener);

      container.read(provider.notifier).state++;

      verifyOnly(listener, listener(true, false));
    });

    test('expose previous and new value on change', () {
      final container = createContainer();
      final provider = StateNotifierProvider<StateController<int>, int>(
        (ref) => StateController(0),
      );
      final listener = Listener<int>();

      container.listen<int>(provider, listener.call, fireImmediately: true);

      verifyOnly(listener, listener(null, 0));

      container.read(provider.notifier).state++;

      verifyOnly(listener, listener(0, 1));
    });

    test('can downcast the value', () async {
      final listener = Listener<num>();
      final dep = StateProvider((ref) => 0);

      final container = createContainer();

      container.listen<num>(dep, listener.call);

      verifyZeroInteractions(listener);

      container.read(dep.notifier).state++;
      await container.pump();

      verifyOnly(listener, listener(0, 1));
    });

    test(
        'if a listener adds a container.listen, the new listener is not called immediately',
        () {
      final provider = StateProvider((ref) => 0);
      final container = createContainer();

      final listener = Listener<int>();

      container.listen<int>(provider, (prev, value) {
        listener(prev, value);
        container.listen<int>(provider, listener.call);
      });

      verifyZeroInteractions(listener);

      container.read(provider.notifier).state++;

      verify(listener(0, 1)).called(1);

      container.read(provider.notifier).state++;

      verify(listener(1, 2)).called(2);
    });

    test(
        'if a listener removes another provider.listen, the removed listener is still called',
        () {
      final provider = StateProvider((ref) => 0);
      final container = createContainer();

      final listener = Listener<int>();
      final listener2 = Listener<int>();

      final p = Provider((ref) {
        ProviderSubscription<int>? a;
        ref.listen<int>(provider, (prev, value) {
          listener(prev, value);
          a?.close();
          a = null;
        });

        a = ref.listen<int>(provider, listener2.call);
      });
      container.read(p);

      verifyZeroInteractions(listener);
      verifyZeroInteractions(listener2);

      container.read(provider.notifier).state++;

      verifyInOrder([
        listener(0, 1),
        listener2(0, 1),
      ]);

      container.read(provider.notifier).state++;

      verify(listener(1, 2)).called(1);
      verifyNoMoreInteractions(listener2);
    });

    test(
      'if a listener removes another provider.listen, the removed listener is still called (ProviderListenable)',
      skip: true,
      () {
        final provider = StateProvider((ref) => 0);
        final container = createContainer();

        final listener = Listener<int>();
        final listener2 = Listener<int>();

        final p = Provider((ref) {
          ProviderSubscription<int>? a;
          ref.listen<int>(provider, (prev, value) {
            listener(prev, value);
            a?.close();
            a = null;
          });

          a = ref.listen<int>(provider, listener2.call);
        });
        container.read(p);

        verifyZeroInteractions(listener);
        verifyZeroInteractions(listener2);

        container.read(provider.notifier).state++;

        verifyInOrder([
          listener(1, 1),
          listener2(1, 1),
        ]);

        container.read(provider.notifier).state++;

        verify(listener(2, 2)).called(1);
        verifyNoMoreInteractions(listener2);
        // TODO the problem is that ProviderListenable subscriptions are separate from
        // ProviderElement subscriptions. So the ProviderElement.notifyListeners
        // making a local copy of the list of subscriptions before notifying listeners
        // does not apply to ProviderListenables
        // Support for modifying listeners within a listener probably should be dropped anyway for performance.
        // This would remove a list copy
      },
    );

    test(
        'if a listener adds a provider.listen, the new listener is not called immediately',
        () {
      final provider = StateProvider((ref) => 0);
      final container = createContainer();

      final listener = Listener<int>();

      final p = Provider((ref) {
        ref.listen<int>(provider, (prev, value) {
          listener(prev, value);
          ref.listen<int>(provider, listener.call);
        });
      });
      container.read(p);

      verifyZeroInteractions(listener);

      container.read(provider.notifier).state++;

      verify(listener(0, 1)).called(1);

      container.read(provider.notifier).state++;

      verify(listener(1, 2)).called(2);
    });

    test(
      'if a listener removes another container.listen, the removed listener is still called (ProviderListenable)',
      skip: true,
      () {
        final provider = StateProvider((ref) => 0);
        final container = createContainer();

        final listener = Listener<int>();
        final listener2 = Listener<int>();

        ProviderSubscription<Object?>? a;
        container.listen<int>(provider, (prev, value) {
          listener(prev, value);
          a?.close();
          a = null;
        });

        a = container.listen<int>(provider, listener2.call);

        verifyZeroInteractions(listener);
        verifyZeroInteractions(listener2);

        container.read(provider.notifier).state++;

        verifyInOrder([
          listener(1, 1),
          listener2(1, 1),
        ]);

        container.read(provider.notifier).state++;

        verify(listener(2, 2)).called(1);
        verifyNoMoreInteractions(listener2);
        // TODO the problem is that ProviderListenable subscriptions are separate from
        // ProviderElement subscriptions. So the ProviderElement.notifyListeners
        // making a local copy of the list of subscriptions before notifying listeners
        // does not apply to ProviderListenables
        // Support for modifying listeners within a listener probably should be dropped anyway for performance.
        // This would remove a list copy
      },
    );

    test(
        'if a listener removes another container.listen, the removed listener is still called',
        () {
      final provider = StateProvider((ref) => 0);
      final container = createContainer();

      final listener = Listener<int>();
      final listener2 = Listener<int>();

      ProviderSubscription<Object?>? a;
      container.listen<int>(provider, (prev, value) {
        listener(prev, value);
        a?.close();
        a = null;
      });

      a = container.listen<int>(provider, listener2.call);

      verifyZeroInteractions(listener);
      verifyZeroInteractions(listener2);

      container.read(provider.notifier).state++;

      verifyInOrder([
        listener(0, 1),
        listener2(0, 1),
      ]);

      container.read(provider.notifier).state++;

      verify(listener(1, 2)).called(1);
      verifyNoMoreInteractions(listener2);
    });

    group('fireImmediately', () {
      test('when no onError is specified, fallbacks to handleUncaughtError',
          () {
        final container = createContainer();
        final dep = Provider<int>((ref) => throw UnimplementedError());
        final listener = Listener<int>();
        final errors = <Object>[];

        runZonedGuarded(
          () {
            container.listen(
              dep,
              listener.call,
              fireImmediately: true,
            );
          },
          (err, stack) => errors.add(err),
        );

        verifyZeroInteractions(listener);
        expect(errors, [
          isUnimplementedError,
        ]);
      });

      test(
          'when no onError is specified on selectors, fallbacks to handleUncaughtError',
          () {
        final container = createContainer();
        final dep = Provider<int>((ref) => throw UnimplementedError());
        final listener = Listener<int>();
        final errors = <Object>[];

        runZonedGuarded(
          () {
            container.listen(
              dep.select((value) => value),
              listener.call,
              fireImmediately: true,
            );
          },
          (err, stack) => errors.add(err),
        );

        verifyZeroInteractions(listener);
        expect(errors, [
          isUnimplementedError,
        ]);
      });

      test('on provider that threw, fireImmediately calls onError', () {
        final container = createContainer();
        final provider = Provider<int>((ref) => throw UnimplementedError());
        final listener = Listener<int>();
        final errorListener = ErrorListener();

        container.listen(
          provider,
          listener.call,
          onError: errorListener.call,
          fireImmediately: true,
        );

        verifyZeroInteractions(listener);
        verifyOnly(
          errorListener,
          errorListener(isUnimplementedError, argThat(isNotNull)),
        );
      });

      test('supports selectors', () {
        final container = createContainer();
        final provider =
            StateNotifierProvider<Counter, int>((ref) => Counter());
        final listener = Listener<bool>();
        final listener2 = Listener<bool>();

        container.listen(
          provider.select((v) => v.isEven),
          listener.call,
          fireImmediately: true,
        );
        container.listen(provider.select((v) => v.isEven), listener2.call);

        verifyOnly(listener, listener(null, true));
        verifyZeroInteractions(listener2);

        container.read(provider.notifier).state = 21;

        verifyOnly(listener, listener(true, false));
        verifyOnly(listener2, listener2(true, false));
      });

      test('passing fireImmediately: false skips the initial value', () {
        final provider = StateProvider((ref) => 0);
        final listener = Listener<int>();

        final container = createContainer();

        container.listen<int>(provider, listener.call);

        verifyZeroInteractions(listener);
      });

      test(
          'correctly listens to the provider if selector onError listener throws',
          () async {
        final dep = StateProvider<int>((ref) => 0);
        final provider = Provider<int>((ref) {
          if (ref.watch(dep) == 0) {
            throw UnimplementedError();
          }
          return ref.watch(dep);
        });
        final listener = Listener<int>();
        final errorListener = ErrorListener();
        var isFirstCall = true;

        final container = createContainer();
        final errors = <Object>[];

        final sub = runZonedGuarded(
          () => container.listen<int>(
            provider.select((value) => value),
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

        container.listen(provider, (prev, value) {});

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
        final provider = Provider<int>((ref) {
          if (ref.watch(dep) == 0) {
            throw UnimplementedError();
          }
          return ref.watch(dep);
        });
        final listener = Listener<int>();
        final errorListener = ErrorListener();
        var isFirstCall = true;

        final container = createContainer();
        final errors = <Object>[];

        final sub = runZonedGuarded(
          () => container.listen<int>(
            provider,
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

        container.listen(provider, (prev, value) {});

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

      test('correctly listens to the provider if selector listener throws', () {
        final provider = StateProvider((ref) => 0);
        final listener = Listener<int>();
        var isFirstCall = true;

        final container = createContainer();
        final errors = <Object>[];

        final sub = runZonedGuarded(
          () => container.listen<int>(
            provider.select((value) => value),
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

        expect(sub, isNotNull);
        verifyOnly(listener, listener(null, 0));
        expect(errors, [isStateError]);

        container.read(provider.notifier).state++;

        verifyOnly(listener, listener(0, 1));
      });

      test('correctly listens to the provider if normal listener throws', () {
        final provider = StateProvider((ref) => 0);
        final listener = Listener<int>();
        var isFirstCall = true;

        final container = createContainer();
        final errors = <Object>[];

        final sub = runZonedGuarded(
          () => container.listen<int>(
            provider,
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

        expect(sub, isNotNull);
        verifyOnly(listener, listener(null, 0));
        expect(errors, [isStateError]);

        container.read(provider.notifier).state++;

        verifyOnly(listener, listener(0, 1));
      });

      test('correctly listens to the provider if normal listener throws', () {
        final provider = StateProvider((ref) => 0);
        final listener = Listener<int>();
        var isFirstCall = true;

        final container = createContainer();
        final errors = <Object>[];

        final sub = runZonedGuarded(
          () => container.listen<int>(
            provider,
            (prev, notifier) {
              listener(prev, notifier);
              if (isFirstCall) {
                isFirstCall = false;
                throw StateError('Some error');
              }
            },
            fireImmediately: true,
          ),
          (err, stack) => errors.add(err),
        );

        expect(sub, isNotNull);
        verifyOnly(listener, listener(null, 0));
        expect(errors, [isStateError]);

        container.read(provider.notifier).state++;

        verifyOnly(listener, listener(0, 1));
      });
    });

    test('.read on closed subscription throws', () {
      final notifier = Counter();
      final provider = StateNotifierProvider<Counter, int>((_) => notifier);
      final container = createContainer();
      final listener = Listener<int>();

      final sub = container.listen(
        provider,
        listener.call,
        fireImmediately: true,
      );

      verify(listener(null, 0)).called(1);
      verifyNoMoreInteractions(listener);

      sub.close();
      notifier.increment();

      expect(sub.read, throwsStateError);

      verifyNoMoreInteractions(listener);
    });

    test('.read on closed selector subscription throws', () {
      final notifier = Counter();
      final provider = StateNotifierProvider<Counter, int>((_) => notifier);
      final container = createContainer();
      final listener = Listener<int>();

      final sub = container.listen(
        provider.select((value) => value * 2),
        listener.call,
        fireImmediately: true,
      );

      verify(listener(null, 0)).called(1);
      verifyNoMoreInteractions(listener);

      sub.close();
      notifier.increment();

      expect(sub.read, throwsStateError);
      verifyNoMoreInteractions(listener);
    });

    test("doesn't trow when creating a provider that failed", () {
      final container = createContainer();
      final provider = Provider((ref) {
        throw Error();
      });

      final sub = container.listen(provider, (_, __) {});

      expect(sub, isA<ProviderSubscription<Object?>>());
    });

    test('selectors can close listeners', () {
      final container = createContainer();
      final provider = StateNotifierProvider<Counter, int>((ref) => Counter());

      expect(container.readProviderElement(provider).hasListeners, false);

      final sub = container.listen<bool>(
        provider.select((count) => count.isEven),
        (prev, isEven) {},
      );

      expect(container.readProviderElement(provider).hasListeners, true);

      sub.close();

      expect(container.readProviderElement(provider).hasListeners, false);
    });

    test('can watch selectors', () async {
      final container = createContainer();
      final provider = StateNotifierProvider<Counter, int>((ref) => Counter());
      final isAdultSelector = Selector<int, bool>(false, (c) => c >= 18);
      final isAdultListener = Listener<bool>();

      final controller = container.read(provider.notifier);
      container.listen<bool>(
        provider.select(isAdultSelector.call),
        isAdultListener.call,
        fireImmediately: true,
      );

      verifyOnly(isAdultSelector, isAdultSelector(0));
      verifyOnly(isAdultListener, isAdultListener(null, false));

      controller.state += 10;

      verifyOnly(isAdultSelector, isAdultSelector(10));
      verifyNoMoreInteractions(isAdultListener);

      controller.state += 10;

      verifyOnly(isAdultSelector, isAdultSelector(20));
      verifyOnly(isAdultListener, isAdultListener(false, true));

      controller.state += 10;

      verifyOnly(isAdultSelector, isAdultSelector(30));
      verifyNoMoreInteractions(isAdultListener);
    });

    test('calls immediately the listener with the current value', () {
      final provider = Provider((ref) => 0);
      final listener = Listener<int>();

      final container = createContainer();

      container.listen(provider, listener.call, fireImmediately: true);

      verifyOnly(listener, listener(null, 0));
    });

    test('call listener when provider rebuilds', () async {
      final controller = StreamController<int>();
      addTearDown(controller.close);
      final container = createContainer();

      final count = StateProvider((ref) => 0);
      final provider = Provider((ref) => ref.watch(count));

      container.listen<int>(
        provider,
        (prev, value) => controller.add(value),
        fireImmediately: true,
      );

      container.read(count.notifier).state++;

      await expectLater(
        controller.stream,
        emitsInOrder(<dynamic>[0, 1]),
      );
    });

    test('call listener when provider emits an update', () async {
      final container = createContainer();

      final count = StateProvider((ref) => 0);
      final listener = Listener<int>();

      container.listen<int>(count, listener.call);

      container.read(count.notifier).state++;

      verifyOnly(listener, listener(0, 1));

      container.read(count.notifier).state++;

      verifyOnly(listener, listener(1, 2));
    });

    test('supports selectors', () {
      final container = createContainer();

      final count = StateProvider((ref) => 0);
      final listener = Listener<bool>();

      container.listen<bool>(
        count.select((value) => value.isEven),
        listener.call,
        fireImmediately: true,
      );

      verifyOnly(listener, listener(null, true));

      container.read(count.notifier).state = 2;

      verifyNoMoreInteractions(listener);

      container.read(count.notifier).state = 3;

      verifyOnly(listener, listener(true, false));
    });
  });
}
