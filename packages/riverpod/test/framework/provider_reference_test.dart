import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

import '../utils.dart';

void main() {
  group('ProviderRefBase', () {
    group('refresh', () {
      test('refreshes a provider and return the new state', () {
        var value = 0;
        final state = Provider((ref) => value);
        late ProviderRefBase ref;
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
        verifyOnly(isEvenListener, isEvenListener(false));

        container.read(provider.notifier).state = 4;

        verifyOnly(isEvenSelector, isEvenSelector(4));
        verifyOnly(isEvenListener, isEvenListener(true));

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
        verifyOnly(isEvenListener, isEvenListener(true));
        verifyOnly(isEvenSelector, isEvenSelector(0));

        container.read(provider.notifier).state = 2;

        verifyOnly(isEvenSelector, isEvenSelector(2));
        verifyNoMoreInteractions(isEvenListener);

        container.read(provider.notifier).state = 3;

        verifyOnly(isEvenSelector, isEvenSelector(3));
        verifyOnly(isEvenListener, isEvenListener(false));

        await container.pump();

        expect(buildCount, 1);
      });
    });

    group('.watch', () {
      test('can listen multiple providers at once', () async {
        final container = createContainer();
        final count = StateProvider((ref) => 0);
        final count2 = StateProvider((ref) => 0);

        final provider = Provider((ref) {
          final first = ref.watch(count).state;
          final second = ref.watch(count2).state;

          return '$first $second';
        });

        expect(container.read(provider), '0 0');

        container.read(count).state++;
        await container.pump();

        expect(container.read(provider), '1 0');

        container.read(count2).state++;
        await container.pump();

        expect(container.read(provider), '1 1');
      });

      test(
          'listens to the parameter and rebuild the state whenever this provider changed',
          () async {
        final count = StateProvider((ref) => 0);
        var buildCount = 0;
        final provider = Provider((ref) {
          buildCount++;
          return ref.watch(count).state.isEven;
        });

        final container = ProviderContainer();
        addTearDown(container.dispose);

        expect(container.read(provider), true);
        // reading twice to make sure the provider isn't rebuilt on every read
        expect(container.read(provider), true);
        expect(buildCount, 1);

        container.read(count).state++;
        await container.pump();

        expect(container.read(provider), false);
        // reading twice to make sure the provider isn't rebuilt on every read
        expect(container.read(provider), false);
        expect(buildCount, 2);
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

        container.read(count).state++;
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

        container.read(count).state++;
        container.read(count2).state++;

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

        container.read(count).state++;
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
      test('is true during onDispose', () {}, skip: true);
      test('is false in between rebuilds', () {}, skip: true);
    });

    test('ref.listen on outdated provider causes it to rebuild', () {},
        skip: true);
  });
}
