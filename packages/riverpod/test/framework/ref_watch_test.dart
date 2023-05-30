import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:test/test.dart';

import '../utils.dart';

class Counter extends StateNotifier<int> {
  Counter([super.initialValue = 0]);

  @override
  int get state => super.state;
  @override
  set state(int value) => super.state = value;

  void increment() => state++;
}

void main() {
  test('can chain select', () {
    final container = createContainer();

    var buildCount = 0;
    final dep = StateProvider((ref) => 0);
    final provider = Provider((ref) {
      buildCount++;
      return ref.watch(
        dep.select((value) => value % 10).select((value) => value < 5),
      );
    });

    expect(buildCount, 0);
    expect(container.read(provider), true);
    expect(buildCount, 1);

    container.read(dep.notifier).state = 3;

    expect(container.read(provider), true);
    expect(buildCount, 1);

    container.read(dep.notifier).state = 7;

    expect(container.read(provider), false);
    expect(buildCount, 2);

    container.read(dep.notifier).state = 8;

    expect(container.read(provider), false);
    expect(buildCount, 2);

    container.read(dep.notifier).state = 18;

    expect(container.read(provider), false);
    expect(buildCount, 2);
  });

  test('can listen multiple providers at once', () async {
    final container = createContainer();
    final count = StateProvider((ref) => 0);
    final count2 = StateProvider((ref) => 0);

    final provider = Provider((ref) {
      final first = ref.watch(count);
      final second = ref.watch(count2);

      return '$first $second';
    });

    expect(container.read(provider), '0 0');

    container.read(count.notifier).state++;
    await container.pump();

    expect(container.read(provider), '1 0');

    container.read(count2.notifier).state++;
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
      return ref.watch(count).isEven;
    });

    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(container.read(provider), true);
    // reading twice to make sure the provider isn't rebuilt on every read
    expect(container.read(provider), true);
    expect(buildCount, 1);

    container.read(count.notifier).state++;
    await container.pump();

    expect(container.read(provider), false);
    // reading twice to make sure the provider isn't rebuilt on every read
    expect(container.read(provider), false);
    expect(buildCount, 2);
  });

  test('when selector throws, rebuild providers', () {}, skip: true);

  test('on provider that threw, exceptions bypass the selector', () {
    final container = createContainer();
    final dep = Provider<int>((ref) {
      throw UnimplementedError();
    });
    final provider = Provider<int>((ref) {
      return ref.watch(dep.select((value) => throw StateError('message')));
    });

    expect(
      () => container.read(provider),
      throwsUnimplementedError,
    );
  });

  test(
      'when rebuilding a provider after an uncaught exception, correctly updates dependents',
      () {
    final container = createContainer();
    final throws = StateProvider((ref) => true);
    final provider = Provider((ref) {
      if (ref.watch(throws)) {
        throw UnimplementedError();
      }
      return 0;
    });

    final dep = Provider((ref) {
      return ref.watch(provider);
    });

    expect(
      () => container.read(dep),
      throwsUnimplementedError,
    );

    container.read(throws.notifier).state = false;

    expect(container.read(dep), 0);
  });

  test(
      'when rebuilding a provider after an uncaught selected exception, correctly updates dependents',
      () {
    final container = createContainer();
    final throws = StateProvider((ref) => true);
    final provider = Provider((ref) {
      if (ref.watch(throws)) {
        throw UnimplementedError();
      }
      return 0;
    });

    final dep = Provider((ref) {
      return ref.watch(provider.select((value) => value));
    });

    expect(
      () => container.read(dep),
      throwsUnimplementedError,
    );

    container.read(throws.notifier).state = false;

    expect(container.read(dep), 0);
  });

  test('disposes providers synchronously when their dependency changes',
      () async {
    final onDispose = OnDisposeMock();
    final dep = StateProvider((ref) => 0);
    final dep2 = StateProvider((ref) => 0);
    final container = createContainer();
    final provider = Provider((ref) {
      ref.onDispose(onDispose.call);
      ref.watch(dep);
      ref.watch(dep2);
    });

    container.read(provider);

    container.read(dep.notifier).state++;

    verifyOnly(onDispose, onDispose());

    container.read(dep.notifier).state++;
    container.read(dep2.notifier).state++;

    verifyNoMoreInteractions(onDispose);
  });

  test('throw when trying to use ref.read inside selectors during initial call',
      () {
    final dep = Provider((ref) => 0, name: 'dep');
    final provider = Provider(
      name: 'provider',
      (ref) {
        ref.watch(dep.select((value) => ref.read(dep)));
      },
    );
    final container = createContainer();

    expect(
      () => container.read(provider),
      throwsA(isA<AssertionError>()),
    );
  });

  test(
      'throw when trying to use ref.watch inside selectors during initial call',
      () {
    final dep = Provider((ref) => 0);
    final provider = Provider((ref) {
      ref.watch(dep.select((value) => ref.watch(dep)));
    });
    final container = createContainer();

    expect(
      () => container.read(provider),
      throwsA(isA<AssertionError>()),
    );
  });

  test(
      'throw when trying to use ref.listen inside selectors during initial call',
      () {
    final dep = Provider((ref) => 0);
    final provider = Provider((ref) {
      ref.watch(
        dep.select((value) {
          ref.listen(dep, (prev, value) {});
          return 0;
        }),
      );
    });
    final container = createContainer();

    expect(
      () => container.read(provider),
      throwsA(isA<AssertionError>()),
    );
  });

  test(
      'when selecting a provider, element.visitChildren visits the selected provider',
      () {
    final container = createContainer();
    final selected = StateNotifierProvider<StateController<int>, int>((ref) {
      return StateController(0);
    });
    final provider = Provider((ref) {
      ref.watch(selected.select((value) => null));
    });

    final element = container.readProviderElement(provider);
    final selectedElement = container.readProviderElement(selected);

    final ancestors = <ProviderElementBase<Object?>>[];
    element.visitAncestors(ancestors.add);

    expect(ancestors, [selectedElement]);
  });

  test('can watch selectors', () {
    final container = createContainer();
    final provider = StateNotifierProvider<StateController<int>, int>(
      name: 'provider',
      (ref) => StateController(0),
    );
    final isEvenSelector = Selector<int, bool>(false, (c) => c.isEven);
    final isEvenListener = Listener<bool>();
    var buildCount = 0;

    final another = Provider<bool>(
      name: 'another',
      (ref) {
        buildCount++;
        return ref.watch(provider.select(isEvenSelector.call));
      },
    );

    container.listen(another, isEvenListener.call, fireImmediately: true);

    expect(buildCount, 1);
    verifyOnly(isEvenListener, isEvenListener(null, true));
    verifyOnly(isEvenSelector, isEvenSelector(0));

    container.read(provider.notifier).state = 2;

    expect(container.read(another), true);
    expect(buildCount, 1);
    verifyOnly(isEvenSelector, isEvenSelector(2));
    verifyNoMoreInteractions(isEvenListener);

    container.read(provider.notifier).state = 3;

    expect(container.read(another), false);
    expect(buildCount, 2);
    verify(isEvenSelector(3)).called(2);
    verifyOnly(isEvenListener, isEvenListener(true, false));
  });

  test(
      'Provider removing one of multiple listeners on a provider still listen to the provider',
      () async {
    final stateProvider = StateProvider((ref) => 0, name: 'state');
    final notifier0 = Counter();
    final provider0 = StateNotifierProvider<Counter, int>(
      (_) => notifier0,
      name: '0',
    );

    final notifier1 = Counter(42);
    final provider1 = StateNotifierProvider<Counter, int>(
      (_) => notifier1,
      name: '1',
    );

    var computedBuildCount = 0;
    final computed = Provider((ref) {
      computedBuildCount++;
      final state = ref.watch(stateProvider);
      final value = state == 0 ? ref.watch(provider0) : ref.watch(provider1);
      return '${ref.watch(provider0)} $value';
    });

    final computedListener = Listener<String>();
    final container = createContainer();

    container.read(provider0);
    container.read(provider1);
    final provider0Element = container.readProviderElement(provider0);
    final provider1Element = container.readProviderElement(provider1);

    container.listen(computed, computedListener.call, fireImmediately: true);

    verifyOnly(computedListener, computedListener(null, '0 0'));
    expect(computedBuildCount, 1);
    expect(provider0Element.hasListeners, true);
    expect(provider1Element.hasListeners, false);

    notifier0.increment();
    await container.pump();

    verifyOnly(computedListener, computedListener('0 0', '1 1'));
    expect(computedBuildCount, 2);

    notifier1.increment();
    await container.pump();

    expect(computedBuildCount, 2);
    verifyNoMoreInteractions(computedListener);

    // changing the provider that computed is subscribed to
    container.read(stateProvider.notifier).state = 1;
    await container.pump();

    verifyOnly(computedListener, computedListener('1 1', '1 43'));
    expect(computedBuildCount, 3);
    expect(provider1Element.hasListeners, true);
    expect(provider0Element.hasListeners, true);

    notifier1.increment();
    await container.pump();

    verifyOnly(computedListener, computedListener('1 43', '1 44'));
    expect(computedBuildCount, 4);

    notifier0.increment();
    await container.pump();

    verifyOnly(computedListener, computedListener('1 44', '2 44'));
    expect(computedBuildCount, 5);
  });

  test('Stops listening to a provider when recomputed but no longer using it',
      () async {
    final stateProvider = StateProvider((ref) => 0, name: 'state');
    final notifier0 = Counter();
    final provider0 = StateNotifierProvider<Counter, int>(
      (_) => notifier0,
      name: '0',
    );
    final notifier1 = Counter(42);
    final provider1 = StateNotifierProvider<Counter, int>(
      (_) => notifier1,
      name: '1',
    );

    var computedBuildCount = 0;
    final computed = Provider((ref) {
      computedBuildCount++;
      final state = ref.watch(stateProvider);
      return state == 0 ? ref.watch(provider0) : ref.watch(provider1);
    });

    final computedListener = Listener<int>();
    final container = createContainer();

    final provider0Element = container.readProviderElement(provider0);
    final provider1Element = container.readProviderElement(provider1);

    container.listen(computed, computedListener.call, fireImmediately: true);

    verifyOnly(computedListener, computedListener(null, 0));
    expect(computedBuildCount, 1);
    expect(provider0Element.hasListeners, true);
    expect(provider1Element.hasListeners, false);

    notifier0.increment();
    await container.pump();

    verifyOnly(computedListener, computedListener(0, 1));
    expect(computedBuildCount, 2);

    notifier1.increment();
    await container.pump();

    expect(computedBuildCount, 2);
    verifyNoMoreInteractions(computedListener);

    // changing the provider that computed is subscribed to
    container.read(stateProvider.notifier).state = 1;
    await container.pump();

    expect(computedBuildCount, 3);
    verifyOnly(computedListener, computedListener(1, 43));
    expect(provider1Element.hasListeners, true);
    expect(provider0Element.hasListeners, false);

    notifier1.increment();
    await container.pump();

    expect(computedBuildCount, 4);
    verifyOnly(computedListener, computedListener(43, 44));

    notifier0.increment();
    await container.pump();

    expect(computedBuildCount, 4);
    verifyNoMoreInteractions(computedListener);
  });

  test('Provider.family', () async {
    final computed =
        Provider.family<String, AlwaysAliveProviderBase<int>>((ref, provider) {
      return ref.watch(provider).toString();
    });
    final notifier = Counter();
    final provider = StateNotifierProvider<Counter, int>((_) {
      return notifier;
    });
    final container = createContainer();
    final listener = Listener<String>();

    container.listen(computed(provider), listener.call, fireImmediately: true);

    verifyOnly(listener, listener(null, '0'));

    notifier.state = 42;
    await container.pump();

    verifyOnly(listener, listener('0', '42'));
  });

  test(
      'multiple ref.watch, when one of them forces re-evaluate, all dependencies are still flushed',
      () async {
    final container = createContainer();
    final notifier = Notifier(0);
    final provider = StateNotifierProvider<Notifier<int>, int>((_) {
      return notifier;
    });
    var callCount = 0;
    final computed = Provider((ref) {
      callCount++;
      return ref.watch(provider);
    });

    final tested = Provider((ref) {
      final first = ref.watch(provider);
      final second = ref.watch(computed);
      return '$first $second';
    });
    final listener = Listener<String>();

    container.listen(tested, listener.call, fireImmediately: true);

    verifyOnly(listener, listener(null, '0 0'));
    expect(callCount, 1);

    notifier.setState(1);
    await container.pump();

    verifyOnly(listener, listener('0 0', '1 1'));
    expect(callCount, 2);
  });

  test(
      'computed on computed, the first aborts rebuild, the second should not be re-evaluated',
      () async {
    final state = StateProvider((ref) => 0);
    var firstCallCount = 0;
    final first = Provider((ref) {
      firstCallCount++;
      ref.watch(state);
      return 0;
    });
    var secondCallCount = 0;
    final second = Provider((ref) {
      secondCallCount++;
      return ref.watch(first).toString();
    });
    final container = createContainer();

    final controller = container.read(state.notifier);

    expect(container.read(second), '0');
    expect(firstCallCount, 1);
    expect(secondCallCount, 1);

    controller.state = 42;
    await container.pump();

    expect(container.read(second), '0');
    expect(firstCallCount, 2);
    expect(secondCallCount, 1);
  });

  test('can call ref.watch asynchronously', () async {
    final container = createContainer();
    final notifier = Notifier(0);
    final provider = StateNotifierProvider<Notifier<int>, int>(
      name: 'provider',
      (_) => notifier,
    );
    var callCount = 0;
    final computed = StreamProvider(
      name: 'computed',
      (ref) async* {
        callCount++;
        yield ref.watch(provider);
      },
    );

    final sub = container.listen(computed, (_, __) {});

    expect(callCount, 0);
    expect(sub.read(), const AsyncValue<int>.loading());

    await container.read(computed.future);

    expect(sub.read(), const AsyncValue<int>.data(0));
    expect(callCount, 1);

    notifier.setState(42);
    await container.pump();

    expect(
      sub.read(),
      const AsyncLoading<int>()
          .copyWithPrevious(const AsyncData(0), isRefresh: false),
    );
    expect(callCount, 1);

    await container.read(computed.future);

    expect(sub.read(), const AsyncValue<int>.data(42));
    expect(callCount, 2);
  });

  test('the value is cached between multiple listeners', () {
    final container = createContainer();
    final notifier = Notifier(0);
    final provider = StateNotifierProvider<Notifier<int>, int>((_) {
      return notifier;
    });
    var callCount = 0;
    final computed = Provider((ref) {
      callCount++;
      return [ref.watch(provider)];
    });

    late List<int> first;
    final firstListener = Listener<List<int>>();
    container.listen<List<int>>(
      computed,
      fireImmediately: true,
      (prev, value) {
        first = value;
        firstListener(prev, value);
      },
    );

    late List<int> second;
    final secondListener = Listener<List<int>>();
    container.listen<List<int>>(
      computed,
      fireImmediately: true,
      (prev, value) {
        second = value;
        secondListener(prev, value);
      },
    );

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

  test('Simple Provider flow', () async {
    final container = createContainer();
    final notifier = Notifier(0);
    final provider = StateNotifierProvider<Notifier<int>, int>((_) {
      return notifier;
    });
    final listener = Listener<bool>();
    var callCount = 0;
    final isPositiveComputed = Provider((ref) {
      callCount++;
      return !ref.watch(provider).isNegative;
    });

    container.listen(isPositiveComputed, listener.call, fireImmediately: true);

    expect(notifier.hasListeners, true);
    verifyOnly(listener, listener(null, true));
    expect(callCount, 1);

    notifier.setState(-1);
    await container.pump();

    expect(callCount, 2);
    verifyOnly(listener, listener(true, false));

    notifier.setState(-42);
    await container.pump();

    expect(callCount, 3);
    verifyNoMoreInteractions(listener);
  });
}

class Notifier<T> extends StateNotifier<T> {
  Notifier(super._state);

  // ignore: use_setters_to_change_properties
  void setState(T value) => state = value;
}
