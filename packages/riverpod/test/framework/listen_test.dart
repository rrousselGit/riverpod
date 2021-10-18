import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

import '../utils.dart';

void main() {
  group('Ref.listen', () {
    test('expose previous and new value on change', () {
      final container = createContainer();
      final dep = StateNotifierProvider<StateController<int>, int>(
        (ref) => StateController(0),
      );
      final listener = Listener<int>();
      final provider = Provider((ref) {
        ref.listen<int>(dep, listener, fireImmediately: true);
      });

      container.read(provider);

      verifyOnly(listener, listener(null, 0));

      container.read(dep.notifier).state++;

      verifyOnly(listener, listener(0, 1));
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
          listener,
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
  });

  group('ProviderContainer.listen', () {
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
        listener,
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

      container.listen<int>(provider, listener, fireImmediately: true);

      verifyOnly(listener, listener(null, 0));

      container.read(provider.notifier).state++;

      verifyOnly(listener, listener(0, 1));
    });

    test('can downcast the value', () async {
      final listener = Listener<num>();
      final dep = StateProvider((ref) => 0);

      final container = createContainer();

      container.listen<StateController<num>>(
        dep,
        (prev, value) => listener(prev?.state, value.state),
      );

      verifyZeroInteractions(listener);

      container.read(dep).state++;
      await container.pump();

      verifyOnly(listener, listener(1, 1));
    });

    test(
        'if a listener adds a container.listen, the new listener is not called immediately',
        () {
      final provider = StateProvider((ref) => 0);
      final container = createContainer();

      final listener = Listener<int>();

      container.listen<StateController<int>>(provider, (prev, value) {
        listener(prev?.state, value.state);
        container.listen<StateController<int>>(provider, (prev, value) {
          listener(prev?.state, value.state);
        });
      });

      verifyZeroInteractions(listener);

      container.read(provider).state++;

      verify(listener(1, 1)).called(1);

      container.read(provider).state++;

      verify(listener(2, 2)).called(2);
    });

    test(
        'if a listener removes another provider.listen, the removed listener is still called',
        () {
      final provider = StateProvider((ref) => 0);
      final container = createContainer();

      final listener = Listener<int>();
      final listener2 = Listener<int>();

      final p = Provider((ref) {
        void Function()? a;
        ref.listen<StateController<int>>(provider, (prev, value) {
          listener(prev?.state, value.state);
          a?.call();
          a = null;
        });

        a = ref.listen<StateController<int>>(provider, (prev, value) {
          listener2(prev?.state, value.state);
        });
      });
      container.read(p);

      verifyZeroInteractions(listener);
      verifyZeroInteractions(listener2);

      container.read(provider).state++;

      verifyInOrder([
        listener(1, 1),
        listener2(1, 1),
      ]);

      container.read(provider).state++;

      verify(listener(2, 2)).called(1);
      verifyNoMoreInteractions(listener2);
    });

    test(
        'if a listener adds a provider.listen, the new listener is not called immediately',
        () {
      final provider = StateProvider((ref) => 0);
      final container = createContainer();

      final listener = Listener<int>();

      final p = Provider((ref) {
        ref.listen<StateController<int>>(provider, (prev, value) {
          listener(prev?.state, value.state);
          ref.listen<StateController<int>>(provider, (prev, value) {
            listener(prev?.state, value.state);
          });
        });
      });
      container.read(p);

      verifyZeroInteractions(listener);

      container.read(provider).state++;

      verify(listener(1, 1)).called(1);

      container.read(provider).state++;

      verify(listener(2, 2)).called(2);
    });

    test(
        'if a listener removes another container.listen, the removed listener is still called',
        () {
      final provider = StateProvider((ref) => 0);
      final container = createContainer();

      final listener = Listener<int>();
      final listener2 = Listener<int>();

      ProviderSubscription? a;
      container.listen<StateController<int>>(provider, (prev, value) {
        listener(prev?.state, value.state);
        a?.close();
        a = null;
      });

      a = container.listen<StateController<int>>(provider, (prev, value) {
        listener2(prev?.state, value.state);
      });

      verifyZeroInteractions(listener);
      verifyZeroInteractions(listener2);

      container.read(provider).state++;

      verifyInOrder([
        listener(1, 1),
        listener2(1, 1),
      ]);

      container.read(provider).state++;

      verify(listener(2, 2)).called(1);
      verifyNoMoreInteractions(listener2);
    });

    group('fireImmediately', () {
      test('supports selectors', () {
        final container = createContainer();
        final provider =
            StateNotifierProvider<Counter, int>((ref) => Counter());
        final listener = Listener<bool>();
        final listener2 = Listener<bool>();

        container.listen(
          provider.select((v) => v.isEven),
          listener,
          fireImmediately: true,
        );
        container.listen(provider.select((v) => v.isEven), listener2);

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

        container.listen<StateController<int>>(
          provider,
          (prev, notifier) => listener(prev?.state, notifier.state),
          fireImmediately: false,
        );

        verifyZeroInteractions(listener);
      });

      test('correctly listens to the provider if selector listener throws', () {
        final provider = StateProvider((ref) => 0);
        final listener = Listener<int>();
        var isFirstCall = true;

        final container = createContainer();
        final errors = <Object>[];

        final sub = runZonedGuarded(
          () => container.listen<int>(
            provider.select((value) => value.state),
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

        container.read(provider).state++;

        verifyOnly(listener, listener(0, 1));
      });

      test('correctly listens to the provider if normal listener throws', () {
        final provider = StateProvider((ref) => 0);
        final listener = Listener<int>();
        var isFirstCall = true;

        final container = createContainer();
        final errors = <Object>[];

        final sub = runZonedGuarded(
          () => container.listen<StateController<int>>(
            provider,
            (prev, notifier) {
              listener(prev?.state, notifier.state);
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

        container.read(provider).state++;

        verifyOnly(listener, listener(1, 1));
      });
    });

    test('.read on closed subscription throws', () {
      final notifier = Counter();
      final provider = StateNotifierProvider<Counter, int>((_) => notifier);
      final container = createContainer();
      final listener = Listener<int>();

      final sub = container.listen(provider, listener, fireImmediately: true);

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
        listener,
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

      expect(sub, isA<ProviderSubscription>());
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
        provider.select(isAdultSelector),
        isAdultListener,
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

      container.listen(provider, listener, fireImmediately: true);

      verifyOnly(listener, listener(null, 0));
    });

    test('call listener when provider rebuilds', () async {
      final controller = StreamController<int>();
      addTearDown(controller.close);
      final container = createContainer();

      final count = StateProvider((ref) => 0);
      final provider = Provider((ref) => ref.watch(count).state);

      container.listen<int>(
        provider,
        (prev, value) => controller.add(value),
        fireImmediately: true,
      );

      container.read(count).state++;

      await expectLater(
        controller.stream,
        emitsInOrder(<dynamic>[0, 1]),
      );
    });

    test('call listener when provider emits an update', () async {
      final container = createContainer();

      final count = StateProvider((ref) => 0);
      final listener = Listener<int>();

      container.listen<StateController<int>>(
        count,
        (prev, value) => listener(prev?.state, value.state),
        fireImmediately: false,
      );

      container.read(count).state++;

      verifyOnly(listener, listener(1, 1));

      container.read(count).state++;

      verifyOnly(listener, listener(2, 2));
    });

    test('supports selectors', () {
      final container = createContainer();

      final count = StateProvider((ref) => 0);
      final listener = Listener<bool>();

      container.listen<bool>(
        count.select((value) => value.state.isEven),
        listener,
        fireImmediately: true,
      );

      verifyOnly(listener, listener(null, true));

      container.read(count).state = 2;

      verifyNoMoreInteractions(listener);

      container.read(count).state = 3;

      verifyOnly(listener, listener(true, false));
    });
  });
}
