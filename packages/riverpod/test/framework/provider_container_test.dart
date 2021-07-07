import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

import '../utils.dart';

void main() {
  group('ProviderContainer', () {
    group('.pump', () {
      test(
        'on scoped container correctly awaits disposal',
        () {},
        skip: true,
      );

      test(
        'on scoped container through another scoped container correctly awaits disposal',
        () {},
        skip: true,
      );
    });

    test('depth', () {
      final root = createContainer();
      final a = createContainer(parent: root);
      final b = createContainer(parent: a);
      final c = createContainer(parent: a);

      final root2 = createContainer();

      expect(root.depth, 0);
      expect(root2.depth, 0);
      expect(a.depth, 1);
      expect(b.depth, 2);
      expect(c.depth, 2);
    });

    group('getAllProviderElements', () {
      // TODO list only elements associated with this container (ingoring inherited elements)

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

    test(
        'does not re-initialize a provider if read by a child container after the provider was initialized',
        () {
      final root = createContainer();
      // the child must be created before the provider is initialized
      final child = createContainer(parent: root);

      var buildCount = 0;
      final provider = Provider((ref) {
        buildCount++;
        return 0;
      });

      expect(root.read(provider), 0);

      expect(buildCount, 1);

      expect(child.read(provider), 0);

      expect(buildCount, 1);
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
      test(
          'if a listener adds a container.listen, the new listener is not called immediately',
          () {
        final provider = StateProvider((ref) => 0);
        final container = createContainer();

        final listener = Listener<int>();

        container.listen<StateController<int>>(provider, (value) {
          listener(value.state);
          container.listen<StateController<int>>(provider, (value) {
            listener(value.state);
          });
        });

        verifyZeroInteractions(listener);

        container.read(provider).state++;

        verify(listener(1)).called(1);

        container.read(provider).state++;

        verify(listener(2)).called(2);
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
          ref.listen<StateController<int>>(provider, (value) {
            listener(value.state);
            a?.call();
            a = null;
          });

          a = ref.listen<StateController<int>>(provider, (value) {
            listener2(value.state);
          });
        });
        container.read(p);

        verifyZeroInteractions(listener);
        verifyZeroInteractions(listener2);

        container.read(provider).state++;

        verifyInOrder([
          listener(1),
          listener2(1),
        ]);

        container.read(provider).state++;

        verify(listener(2)).called(1);
        verifyNoMoreInteractions(listener2);
      });

      test(
          'if a listener adds a provider.listen, the new listener is not called immediately',
          () {
        final provider = StateProvider((ref) => 0);
        final container = createContainer();

        final listener = Listener<int>();

        final p = Provider((ref) {
          ref.listen<StateController<int>>(provider, (value) {
            listener(value.state);
            ref.listen<StateController<int>>(provider, (value) {
              listener(value.state);
            });
          });
        });
        container.read(p);

        verifyZeroInteractions(listener);

        container.read(provider).state++;

        verify(listener(1)).called(1);

        container.read(provider).state++;

        verify(listener(2)).called(2);
      });

      test(
          'if a listener removes another container.listen, the removed listener is still called',
          () {
        final provider = StateProvider((ref) => 0);
        final container = createContainer();

        final listener = Listener<int>();
        final listener2 = Listener<int>();

        ProviderSubscription? a;
        container.listen<StateController<int>>(provider, (value) {
          listener(value.state);
          a?.close();
          a = null;
        });

        a = container.listen<StateController<int>>(provider, (value) {
          listener2(value.state);
        });

        verifyZeroInteractions(listener);
        verifyZeroInteractions(listener2);

        container.read(provider).state++;

        verifyInOrder([
          listener(1),
          listener2(1),
        ]);

        container.read(provider).state++;

        verify(listener(2)).called(1);
        verifyNoMoreInteractions(listener2);
      });

      test('.read on closed subscription throws', () {
        final notifier = Counter();
        final provider = StateNotifierProvider<Counter, int>((_) => notifier);
        final container = createContainer();
        final listener = Listener<int>();

        final sub = container.listen(provider, listener, fireImmediately: true);

        verify(listener(0)).called(1);
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

        verify(listener(0)).called(1);
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

        final sub = container.listen(provider, (_) {});

        expect(sub, isA<ProviderSubscription>());
      });

      test('selectors fireImmediately', () {
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

        verifyOnly(listener, listener(true));
        verifyZeroInteractions(listener2);

        container.read(provider.notifier).state = 21;

        verifyOnly(listener, listener(false));
        verifyOnly(listener2, listener2(false));
      });

      test('selectors can close listeners', () {
        final container = createContainer();
        final provider =
            StateNotifierProvider<Counter, int>((ref) => Counter());

        expect(container.readProviderElement(provider).hasListeners, false);

        final sub = container.listen<bool>(
          provider.select((count) => count.isEven),
          (isEven) {},
        );

        expect(container.readProviderElement(provider).hasListeners, true);

        sub.close();

        expect(container.readProviderElement(provider).hasListeners, false);
      });

      test('can watch selectors', () async {
        final container = createContainer();
        final provider =
            StateNotifierProvider<Counter, int>((ref) => Counter());
        final isAdultSelector = Selector<int, bool>(false, (c) => c >= 18);
        final isAdultListener = Listener<bool>();

        final controller = container.read(provider.notifier);
        container.listen<bool>(
          provider.select(isAdultSelector),
          isAdultListener,
          fireImmediately: true,
        );

        verifyOnly(isAdultSelector, isAdultSelector(0));
        verifyOnly(isAdultListener, isAdultListener(false));

        controller.state += 10;

        verifyOnly(isAdultSelector, isAdultSelector(10));
        verifyNoMoreInteractions(isAdultListener);

        controller.state += 10;

        verifyOnly(isAdultSelector, isAdultSelector(20));
        verifyOnly(isAdultListener, isAdultListener(true));

        controller.state += 10;

        verifyOnly(isAdultSelector, isAdultSelector(30));
        verifyNoMoreInteractions(isAdultListener);
      });

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
