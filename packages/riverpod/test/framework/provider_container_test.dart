import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

import '../utils.dart';

void main() {
  group('ProviderContainer', () {
    test(
        'after a child container is disposed, ref.watch keeps working on providers associated with the ancestor container',
        () async {
      final container = createContainer();
      final dep = StateProvider((ref) => 0);
      final provider = Provider((ref) => ref.watch(dep).state);
      final listener = Listener<int>();
      final child = createContainer(parent: container);

      container.listen<int>(provider, listener, fireImmediately: true);

      verifyOnly(listener, listener(0));

      child.dispose();

      container.read(dep).state++;
      await container.pump();

      verifyOnly(listener, listener(1));
    });

    test('flushes listened providers even if they have no external listeners',
        () async {
      final dep = StateProvider((ref) => 0);
      final provider = Provider((ref) => ref.watch(dep).state);
      final another = StateProvider<int>((ref) {
        ref.listen(provider, (value) => ref.controller.state++);
        return 0;
      });
      final container = createContainer();

      expect(container.read(another).state, 0);

      container.read(dep).state = 42;

      expect(container.read(another).state, 1);
    });

    group('.pump', () {
      test(
          'waits for providers to rebuild or get disposed, no matter from which container they are associated in the graph',
          () async {
        final dep = StateProvider((ref) => 0);
        final a = Provider((ref) => ref.watch(dep).state);
        final b = Provider((ref) => ref.watch(dep).state);
        final aListener = Listener<int>();
        final bListener = Listener<int>();

        final root = createContainer();
        final scoped = createContainer(parent: root, overrides: [b]);

        scoped.listen(a, aListener, fireImmediately: true);
        scoped.listen(b, bListener, fireImmediately: true);

        verifyOnly(aListener, aListener(0));
        verifyOnly(bListener, bListener(0));

        root.read(dep).state++;
        await root.pump();

        verifyOnly(aListener, aListener(1));
        verifyOnly(bListener, bListener(1));

        scoped.read(dep).state++;
        await scoped.pump();

        verifyOnly(aListener, aListener(2));
        verifyOnly(bListener, bListener(2));
      });
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
      test('list scoped providers that depends on nothing', () {
        final scopedProvider = Provider<int>((ref) => 0);
        final parent = createContainer();
        final child = createContainer(
          parent: parent,
          overrides: [scopedProvider],
        );

        child.read(scopedProvider);

        expect(
          child.getAllProviderElements().single,
          isA<ProviderElement>()
              .having((e) => e.origin, 'origin', scopedProvider),
        );
      });

      test(
          'list scoped providers that depends on providers from another container',
          () {
        final dependency = Provider((ref) => 0);
        final scopedProvider = Provider<int>((ref) => ref.watch(dependency));
        final parent = createContainer();
        final child = createContainer(
          parent: parent,
          overrides: [scopedProvider],
        );

        child.read(scopedProvider);

        expect(
          child.getAllProviderElements().single,
          isA<ProviderElement>()
              .having((e) => e.origin, 'origin', scopedProvider),
        );
      });

      test(
          'list only elements associated with the container (ingoring inherited and descendent elements)',
          () {
        final provider = Provider((ref) => 0);
        final provider2 = Provider((ref) => 0);
        final provider3 = Provider((ref) => 0);
        final root = createContainer();
        final mid = createContainer(parent: root, overrides: [provider2]);
        final leaf = createContainer(parent: mid, overrides: [provider3]);

        leaf.read(provider);
        leaf.read(provider2);
        leaf.read(provider3);

        expect(
          root.getAllProviderElements().single,
          isA<ProviderElement>()
              .having((e) => e.provider, 'provider', provider),
        );
        expect(
          mid.getAllProviderElements().single,
          isA<ProviderElement>()
              .having((e) => e.provider, 'provider', provider2),
        );
        expect(
          leaf.getAllProviderElements().single,
          isA<ProviderElement>()
              .having((e) => e.provider, 'provider', provider3),
        );
      });

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

    group('getAllProviderElementsInOrder', () {
      test('list scoped providers that depends on nothing', () {
        final scopedProvider = Provider<int>((ref) => 0);
        final parent = createContainer();
        final child = createContainer(
          parent: parent,
          overrides: [scopedProvider],
        );

        child.read(scopedProvider);

        expect(
          child.getAllProviderElementsInOrder().single,
          isA<ProviderElement>()
              .having((e) => e.origin, 'origin', scopedProvider),
        );
      });

      test(
          'list scoped providers that depends on providers from another container',
          () {
        final dependency = Provider((ref) => 0);
        final scopedProvider = Provider<int>((ref) => ref.watch(dependency));
        final parent = createContainer();
        final child = createContainer(
          parent: parent,
          overrides: [scopedProvider],
        );

        child.read(scopedProvider);

        expect(
          child.getAllProviderElementsInOrder().single,
          isA<ProviderElement>()
              .having((e) => e.origin, 'origin', scopedProvider),
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
      test('can downcast the value', () async {
        final listener = Listener<num>();
        final dep = StateProvider((ref) => 0);

        final container = createContainer();

        container.listen<StateController<num>>(
          dep,
          (value) => listener(value.state),
        );

        verifyZeroInteractions(listener);

        container.read(dep).state++;
        await container.pump();

        verifyOnly(listener, listener(1));
      });

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

      test('supports selectors', () {
        final container = createContainer();

        final count = StateProvider((ref) => 0);
        final listener = Listener<bool>();

        container.listen<bool>(
          count.select((value) => value.state.isEven),
          listener,
          fireImmediately: true,
        );

        verifyOnly(listener, listener(true));

        container.read(count).state = 2;

        verifyNoMoreInteractions(listener);

        container.read(count).state = 3;

        verifyOnly(listener, listener(false));
      });
    });

    test(
      'does not refresh providers if their dependencies changes but they have no active listeners',
      () async {
        final container = createContainer();

        var buildCount = 0;
        final dep = StateProvider((ref) => 0);
        final provider = Provider((ref) {
          buildCount++;
          return ref.watch(dep).state;
        });

        container.read(provider);

        expect(buildCount, 1);

        container.read(dep).state++;
        await container.pump();

        expect(buildCount, 1);
      },
    );
  });
}
