import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

import '../utils.dart';

void main() {
  group('ProviderContainer', () {
    group('getAllProviderElements', () {
      test('list the currently mounted providers', () async {
        final container = ProviderContainer();
        final unrelated = Provider((_) => 42);
        final provider = Provider.autoDispose((ref) => 0);

        expect(container.read(unrelated), 42);
        var sub = container.listen(provider, (_) {});

        expect(
          container.getAllProviderElements(),
          unorderedMatches(<Matcher>[
            isA<ProviderElementBase<int>>(),
            isA<AutoDisposeProviderElementBase<int>>(),
          ]),
        );

        sub.close();
        await container.pump();

        expect(
          container.getAllProviderElements(),
          [isA<ProviderElementBase<int>>()],
        );

        sub = container.listen(provider, (_) {});

        expect(
          container.getAllProviderElements(),
          unorderedMatches(<Matcher>[
            isA<ProviderElementBase<int>>(),
            isA<AutoDisposeProviderElementBase<int>>(),
          ]),
        );
      });
    });

    test('can downcast the listener value', () {
      final container = createContainer();
      final provider = StateProvider<int>((ref) => 0);
      final listener = Listener<void>();

      container.listen<void>(provider, listener);

      verifyZeroInteractions(listener);

      container.read(provider).state++;

      verifyOnly(listener, listener(any));
    });

    test(
      'can close a ProviderSubscription multiple times with no effect',
      () {
        final container = createContainer();
        final provider =
            StateNotifierProvider<StateController<int>, int>((ref) {
          return StateController(0);
        });
        final listener = Listener<int>();

        final controller = container.read(provider.notifier);

        final sub = container.listen(provider, listener);

        sub.close();
        sub.close();

        controller.state++;

        verifyZeroInteractions(listener);
      },
    );

    test(
      'closing an already closed ProviderSubscription does not remove subscriptions with the same listener',
      () {
        final container = createContainer();
        final provider =
            StateNotifierProvider<StateController<int>, int>((ref) {
          return StateController(0);
        });
        final listener = Listener<int>();

        final controller = container.read(provider.notifier);

        final sub = container.listen(provider, listener);
        container.listen(provider, listener);

        controller.state++;

        verify(listener(1)).called(2);
        verifyNoMoreInteractions(listener);

        sub.close();
        sub.close();

        controller.state++;

        verifyOnly(listener, listener(2));
      },
    );

    test('builds providers at most once per container', () {
      var result = 42;
      final container = createContainer();
      var callCount = 0;
      final provider = Provider((_) {
        callCount++;
        return result;
      });

      expect(callCount, 0);
      expect(container.read(provider), 42);
      expect(callCount, 1);
      expect(container.read(provider), 42);
      expect(callCount, 1);

      final container2 = createContainer();

      result = 21;
      expect(container2.read(provider), 21);
      expect(callCount, 2);
      expect(container2.read(provider), 21);
      expect(callCount, 2);
      expect(container.read(provider), 42);
      expect(callCount, 2);
    });

    group('.listen', () {
      test('calls immediately the listener with the current value', () {
        final provider = Provider((ref) => 0);
        final listener = Listener<int>();

        final container = createContainer();

        container.listen(provider, listener, fireImmediately: true);

        verifyOnly(listener, listener(0));
      });

      test('passing fireImmediately: false skips the initial value', () {
        final provider = StateProvider((ref) => 0);
        final listener = Listener<int>();

        final container = createContainer();

        container.listen<StateController<int>>(
          provider,
          (notifier) => listener(notifier.state),
          fireImmediately: false,
        );

        verifyZeroInteractions(listener);
      });

      test('call listener when provider rebuilds', () async {
        final controller = StreamController<int>();
        addTearDown(controller.close);
        final container = createContainer();

        final count = StateProvider((ref) => 0);
        final provider = Provider((ref) => ref.watch(count).state);

        container.listen(provider, controller.add, fireImmediately: true);

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
          (c) => listener(c.state),
          fireImmediately: false,
        );

        container.read(count).state++;

        verifyOnly(listener, listener(1));

        container.read(count).state++;

        verifyOnly(listener, listener(2));
      });

      test('supports selectors', () {}, skip: true);
    });

    test(
        'does not refresh providers if their dependencies changes but they have no active listeners',
        () {},
        skip: true);
  });
}
