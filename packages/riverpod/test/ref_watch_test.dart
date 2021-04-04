import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod/src/internals.dart';
import 'package:test/test.dart';

import 'utils.dart';

class Counter extends StateNotifier<int> {
  Counter([int initialValue = 0]) : super(initialValue);

  @override
  int get state => super.state;
  @override
  set state(int value) => super.state = value;

  void increment() => state++;
}

void main() {
  test(
      'Provider removing one of multiple listeners on a provider still listen to the provider',
      () {
    final stateProvider = StateProvider((ref) => 0, name: 'state');
    final notifier0 = Counter();
    final notifier1 = Counter(42);
    final provider0 = StateNotifierProvider<Counter, int>((_) {
      return notifier0;
    }, name: '0');
    final provider1 = StateNotifierProvider<Counter, int>((_) {
      return notifier1;
    }, name: '1');
    var buildCount = 0;
    final computed = Provider((ref) {
      buildCount++;

      final state = ref.watch(stateProvider).state;
      final value = state == 0 ? ref.watch(provider0) : ref.watch(provider1);

      return '${ref.watch(provider0)} $value';
    });
    final listener = Listener<String>();
    final container = ProviderContainer();

    container.read(provider0);
    container.read(provider1);
    final familyState0 = container.debugProviderElements.firstWhere((p) {
      return p.provider == provider0;
    });
    final familyState1 = container.debugProviderElements.firstWhere((p) {
      return p.provider == provider1;
    });

    computed.watchOwner(container, listener);

    expect(buildCount, 1);
    expect(familyState0.hasListeners, true);
    expect(familyState1.hasListeners, false);
    verify(listener('0 0')).called(1);
    verifyNoMoreInteractions(listener);

    notifier0.increment();

    expect(buildCount, 2);
    verify(listener('1 1')).called(1);
    verifyNoMoreInteractions(listener);

    notifier1.increment();

    expect(buildCount, 2);
    verifyNoMoreInteractions(listener);

    // changing the provider that computed is subscribed to
    container.read(stateProvider).state = 1;

    expect(buildCount, 3);
    verify(listener('1 43')).called(1);
    verifyNoMoreInteractions(listener);
    expect(familyState1.hasListeners, true);
    expect(familyState0.hasListeners, true);

    notifier1.increment();

    expect(buildCount, 4);
    verify(listener('1 44')).called(1);
    verifyNoMoreInteractions(listener);

    notifier0.increment();

    expect(buildCount, 5);
    verify(listener('2 44')).called(1);
    verifyNoMoreInteractions(listener);
  });

  test('Stops listening to a provider when recomputed but no longer using it',
      () {
    final stateProvider = StateProvider((ref) => 0, name: 'state');
    final notifier0 = Counter();
    final notifier1 = Counter(42);
    final provider0 = StateNotifierProvider<Counter, int>((_) {
      return notifier0;
    }, name: '0');
    final provider1 = StateNotifierProvider<Counter, int>((_) {
      return notifier1;
    }, name: '1');
    var buildCount = 0;
    final computed = Provider((ref) {
      buildCount++;
      final state = ref.watch(stateProvider).state;
      return state == 0 ? ref.watch(provider0) : ref.watch(provider1);
    });
    final listener = Listener<int>();
    final container = ProviderContainer();

    container.read(provider0);
    container.read(provider1);
    final familyState0 = container.debugProviderElements.firstWhere((p) {
      return p.provider == provider0;
    });
    final familyState1 = container.debugProviderElements.firstWhere((p) {
      return p.provider == provider1;
    });

    computed.watchOwner(container, listener);

    expect(buildCount, 1);
    expect(familyState0.hasListeners, true);
    expect(familyState1.hasListeners, false);
    verify(listener(0)).called(1);
    verifyNoMoreInteractions(listener);

    notifier0.increment();

    expect(buildCount, 2);
    verify(listener(1)).called(1);
    verifyNoMoreInteractions(listener);

    notifier1.increment();

    expect(buildCount, 2);
    verifyNoMoreInteractions(listener);

    // changing the provider that computed is subscribed to
    container.read(stateProvider).state = 1;

    expect(buildCount, 3);
    verify(listener(43)).called(1);
    verifyNoMoreInteractions(listener);
    expect(familyState1.hasListeners, true);
    expect(familyState0.hasListeners, false);

    notifier1.increment();

    expect(buildCount, 4);
    verify(listener(44)).called(1);
    verifyNoMoreInteractions(listener);

    notifier0.increment();

    expect(buildCount, 4);
    verifyNoMoreInteractions(listener);
  });

  test('Provider.family', () {
    final computed =
        Provider.family<String, AlwaysAliveProviderBase<Object?, int>>(
            (ref, provider) {
      return ref.watch(provider).toString();
    });
    final notifier = Counter();
    final provider = StateNotifierProvider<Counter, int>((_) {
      return notifier;
    });
    final container = ProviderContainer();
    final listener = Listener<String>();

    computed(provider).watchOwner(container, listener);

    verify(listener('0')).called(1);
    verifyNoMoreInteractions(listener);

    notifier.state = 42;

    verify(listener('42')).called(1);
    verifyNoMoreInteractions(listener);
  });

  test(
      'mutliple ref.watch, when one of them forces re-evaluate, all dependencies are still flushed',
      () {
    final container = ProviderContainer();
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

    final sub = tested.addLazyListener(
      container,
      mayHaveChanged: () {},
      onChange: listener,
    );

    verify(listener('0 0')).called(1);
    verifyNoMoreInteractions(listener);
    expect(callCount, 1);

    notifier.setState(1);
    sub.read();

    verify(listener('1 1')).called(1);
    verifyNoMoreInteractions(listener);
    expect(callCount, 2);
  });

  test(
      'computed on computed, the first aborts rebuild, the second should not be re-evaluated',
      () {
    final state = StateProvider((ref) => 0);
    var firstCallCount = 0;
    final first = Provider((ref) {
      firstCallCount++;
      ref.watch(state).state;
      return 0;
    });
    var secondCallCount = 0;
    final second = Provider((ref) {
      secondCallCount++;
      return ref.watch(first).toString();
    });
    final container = ProviderContainer();

    final controller = container.read(state);

    expect(container.read(second), '0');
    expect(firstCallCount, 1);
    expect(secondCallCount, 1);

    controller.state = 42;

    expect(container.read(second), '0');
    expect(firstCallCount, 2);
    expect(secondCallCount, 1);
  });

  test('Computeds are added to the overall list of providers', () {
    final container = ProviderContainer();
    final provider = Provider((_) => 42);
    final computed = Provider((ref) => ref.watch(provider) * 2);
    final provider2 = Provider((ref) => ref.watch(computed));
    final listener = Listener<int>();

    container.read(provider2);
    computed.watchOwner(container, listener);

    verify(listener(84)).called(1);
    verifyNoMoreInteractions(listener);

    expect(
      container.debugProviderElements.map((e) => e.provider),
      [provider, computed, provider2],
    );
  });

  test('Provider are not overrides', () {
    expect(Provider((_) {}), isNot(isA<Override>()));
  });

  test('disposing the Provider closes subscriptions', () {
    final notifier = Notifier(0);
    final provider = StateNotifierProvider<Notifier<int>, int>((_) {
      return notifier;
    });
    final computed = Provider((ref) => ref.watch(provider));
    final container = ProviderContainer();
    final mayHaveChanged = MockMarkMayHaveChanged();
    final listener = Listener<int>();

    computed.addLazyListener(
      container,
      mayHaveChanged: mayHaveChanged,
      onChange: listener,
    );

    verify(listener(0)).called(1);
    verifyNoMoreInteractions(mayHaveChanged);
    verifyNoMoreInteractions(listener);

    container.dispose();

    verifyNoMoreInteractions(mayHaveChanged);
    verifyNoMoreInteractions(listener);
  });

  test('can call ref.watch outside of the Provider', () async {
    final container = ProviderContainer();
    final notifier = Notifier(0);
    final provider = StateNotifierProvider<Notifier<int>, int>((_) {
      return notifier;
    });
    var callCount = 0;
    final computed = StreamProvider((ref) async* {
      callCount++;
      yield ref.watch(provider);
    });

    final sub = container.listen(computed);

    expect(callCount, 0);
    expect(sub.read(), const AsyncValue<int>.loading());
    await container.read(computed.stream).first;
    expect(sub.read(), const AsyncValue<int>.data(0));
    expect(callCount, 1);

    notifier.setState(42);

    expect(sub.read(), const AsyncValue<int>.loading());
    expect(callCount, 1);
    await container.read(computed.stream).first;
    expect(sub.read(), const AsyncValue<int>.data(42));
    expect(callCount, 2);
  });

  test('the value is cached between multiple listeners', () {
    final container = ProviderContainer();
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
    computed.watchOwner(container, (value) {
      first = value;
      firstListener(value);
    });

    late List<int> second;
    final secondListener = Listener<List<int>>();
    computed.watchOwner(container, (value) {
      second = value;
      secondListener(value);
    });

    expect(first, [0]);
    expect(callCount, 1);
    expect(identical(first, second), isTrue);
    verifyInOrder([
      firstListener([0]),
      secondListener([0]),
    ]);
    verifyNoMoreInteractions(firstListener);
    verifyNoMoreInteractions(secondListener);
  });

  test('Simple Provider flow', () {
    final container = ProviderContainer();
    final notifier = Notifier(0);
    final provider = StateNotifierProvider<Notifier<int>, int>((_) {
      return notifier;
    });
    final mayHaveChanged = MockMarkMayHaveChanged();
    final listener = Listener<bool>();
    var callCount = 0;
    final isPositiveComputed = Provider((ref) {
      callCount++;
      return !ref.watch(provider).isNegative;
    });

    final sub = isPositiveComputed.addLazyListener(
      container,
      mayHaveChanged: mayHaveChanged,
      onChange: listener,
    );

    expect(notifier.hasListeners, true);
    verifyOnly(listener, listener(true));
    expect(callCount, 1);
    verifyZeroInteractions(mayHaveChanged);

    notifier.setState(-1);

    verifyOnly(mayHaveChanged, mayHaveChanged());
    verifyNoMoreInteractions(listener);

    sub.read();

    expect(callCount, 2);
    verifyOnly(listener, listener(false));
    verifyNoMoreInteractions(mayHaveChanged);

    notifier.setState(-42);

    verifyOnly(mayHaveChanged, mayHaveChanged());
    verifyNoMoreInteractions(listener);

    sub.read();

    expect(callCount, 3);
    verifyNoMoreInteractions(mayHaveChanged);
    verifyNoMoreInteractions(listener);
  });
}

class Notifier<T> extends StateNotifier<T> {
  Notifier(T state) : super(state);

  // ignore: use_setters_to_change_properties
  void setState(T value) => state = value;
}

class Listener<T> extends Mock {
  void call(T value);
}

class OnDisposeMock extends Mock {
  void call();
}

class MockMarkMayHaveChanged extends Mock {
  void call();
}
