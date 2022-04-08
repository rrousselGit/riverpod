import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

import '../utils.dart';

void main() {
  group('Ref', () {
    test(
      'cannot call ref.watch/ref.read/ref.listen/ref.onDispose after a dependency changed',
      () {
        late Ref ref;
        final container = createContainer();
        final dep = StateProvider((ref) => 0);
        final provider = Provider((r) {
          r.watch(dep);
          ref = r;
        });

        container.read(provider);

        container.read(dep.state).state++;

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

    group('refresh', () {
      test('refreshes a provider and return the new state', () {
        var value = 0;
        final state = Provider((ref) => value);
        late Ref ref;
        final provider = Provider((r) {
          ref = r;
        });
        final container = createContainer();

        container.read(provider);

        expect(container.read(state), 0);

        value = 42;
        expect(ref.refresh(state), 42);
        expect(container.read(state), 42);
      });
    });

    test('ref.read should keep providers alive', () {}, skip: true);

    group('listen', () {
      test('ref.listen on outdated provider causes it to rebuild', () {
        final dep = StateProvider((ref) => 0);
        var buildCount = 0;
        final provider = Provider((ref) {
          buildCount++;
          return ref.watch(dep.state).state;
        });
        final listener = Listener<int>();
        final another = Provider((ref) {
          ref.listen<int>(provider, listener, fireImmediately: true);
        });
        final container = createContainer();

        expect(container.read(provider), 0);
        expect(buildCount, 1);

        container.read(dep.state).state = 42;

        expect(buildCount, 1);

        container.read(another);

        expect(buildCount, 2);
        verifyOnly(listener, listener(null, 42));
      });

      test('can downcast the value', () async {
        final listener = Listener<num>();
        final dep = StateProvider((ref) => 0);
        final provider = Provider((ref) {
          ref.listen<StateController<num>>(
            dep.state,
            (prev, value) => listener(prev?.state, value.state),
          );
        });

        final container = createContainer();
        container.read(provider);

        verifyZeroInteractions(listener);

        container.read(dep.state).state++;
        await container.pump();

        verifyOnly(listener, listener(1, 1));
      });

      test('can listen selectors', () async {
        final container = createContainer();
        final provider =
            StateNotifierProvider<StateController<int>, int>((ref) {
          return StateController(0);
        });
        final isEvenSelector = Selector<int, bool>(false, (c) => c.isEven);
        final isEvenListener = Listener<bool>();
        var buildCount = 0;

        final another = Provider<int>((ref) {
          buildCount++;
          ref.listen<bool>(provider.select(isEvenSelector), isEvenListener);
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
        final container = createContainer();
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
            provider.select(isEvenSelector),
            isEvenListener,
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
    });

    group('.onDispose', () {
      test(
          'calls all the listeners in order when the ProviderContainer is disposed',
          () {
        final onDispose = OnDisposeMock();
        final onDispose2 = OnDisposeMock();
        final provider = Provider((ref) {
          ref.onDispose(onDispose);
          ref.onDispose(onDispose2);
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
          ref.onDispose(onDispose);
          ref.onDispose(onDispose2);
        });

        final container = ProviderContainer();
        addTearDown(container.dispose);

        container.read(provider); // register the onDispose hooks

        verifyZeroInteractions(onDispose);
        verifyZeroInteractions(onDispose2);

        container.read(count.state).state++;
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
          ref.onDispose(onDispose);
        });

        final container = ProviderContainer();
        addTearDown(container.dispose);

        container.read(provider); // register the onDispose hooks

        verifyZeroInteractions(onDispose);

        container.read(count.state).state++;
        container.read(count2.state).state++;

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
          ref.onDispose(onDispose);
        });

        final container = ProviderContainer();
        addTearDown(container.dispose);

        container.read(provider); // register the onDispose hooks
        expect(buildCount, 1);

        verifyZeroInteractions(onDispose);

        container.read(count.state).state++;
        // no pump() because that would rebuild the provider, which means it would
        // need to be disposed once again.

        verifyOnly(onDispose, onDispose());

        container.dispose();

        expect(buildCount, 1);
        verifyNoMoreInteractions(onDispose);
      });

      test(
          'once a provider was disposed, cannot add more listeners until it is rebuilt',
          () {});
    });

    group('mounted', () {
      test('is false during onDispose caused by ref.watch', () {
        final container = createContainer();
        bool? mounted;
        late ProviderElementBase element;
        final dep = StateProvider((ref) => 0);
        final provider = Provider((ref) {
          ref.watch(dep);
          element = ref as ProviderElementBase;
          ref.onDispose(() => mounted = element.mounted);
        });

        container.read(provider);
        expect(mounted, null);

        container.read(dep.state).state++;

        expect(mounted, false);
      });

      test('is false during onDispose caused by container dispose', () {
        final container = createContainer();
        bool? mounted;
        late ProviderElementBase element;
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
        final container = createContainer();
        final dep = StateProvider((ref) => 0);
        late ProviderElementBase element;
        final provider = Provider((ref) {
          ref.watch(dep);
          element = ref as ProviderElementBase;
        });

        container.read(provider);
        expect(element.mounted, true);

        container.read(dep.state).state++;

        expect(element.mounted, false);
      });
    });
  });
}
