import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:riverpod/src/internals.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:test/test.dart';
import 'package:riverpod/riverpod.dart';

Matcher isProvider(ProviderBase provider) {
  final res = isA<ProviderStateBase>().having(
    (s) => s.provider,
    'provider',
    provider,
  );
  return res;
}

void main() {
  // TODO flushing inside mayHaveChanged calls onChanged only after all mayHaveChanged were executed
  test('throw if locally overriding a provider', () {
    final provider = Provider((_) => 42);
    final root = ProviderContainer(overrides: [
      provider.overrideAs(Provider((_) => 21)),
    ]);

    expect(root.read(provider), 21);

    expect(
      () => ProviderContainer(
        parent: root,
        overrides: [provider.overrideAs(Provider((_) => 84))],
      ),
      throwsUnsupportedError,
    );
  });
  test('throw if locally overriding a family', () {
    final provider = Provider.family<int, int>((_, id) => id * 2);
    final root = ProviderContainer(overrides: [
      provider.overrideAs((ref, id) => id),
    ]);

    expect(root.read(provider(21)), 21);

    expect(
      () => ProviderContainer(
        parent: root,
        overrides: [provider.overrideAs((ref, id) => id * 3)],
      ),
      throwsUnsupportedError,
    );
  });
  test('ref.read(provider) for providers with an immutable value', () {
    final ProviderBase<ProviderDependency<int>, int> provider = Provider((_) {
      return 42;
    });
    final container = ProviderContainer();

    expect(container.ref.read(provider), 42);
  });
  test('hasListeners', () {
    final container = ProviderContainer();
    final provider = Provider((_) => 42);

    expect(container.read(provider), 42);

    final state = container.debugProviderStates.single;

    expect(state.$hasListeners, false);

    final removeListener = provider.watchOwner(container, (value) {});

    expect(state.$hasListeners, true);

    removeListener();

    expect(state.$hasListeners, false);
  });
  test('test two families one overriden the other not', () {
    var callCount = 0;
    final family = ProviderFamily<String, int>((ref, value) {
      callCount++;
      return '$value';
    });
    var callCount2 = 0;
    final family2 = ProviderFamily<String, int>((ref, value) {
      callCount2++;
      return '$value 2';
    });
    final container = ProviderContainer(overrides: [
      family.overrideAs((ref, value) => 'override $value'),
    ]);

    expect(container.read(family(0)), 'override 0');

    expect(callCount2, 0);
    expect(container.read(family2(0)), '0 2');
    expect(callCount2, 1);

    expect(callCount, 0);
  });
  test('changing the override type at a given index throws', () {
    final provider = Provider((ref) => 0);
    final family = ProviderFamily<int, int>((ref, value) => 0);
    final container = ProviderContainer(overrides: [
      family.overrideAs((ref, value) => 0),
    ]);

    expect(
      () =>
          container.updateOverrides([provider.overrideAs(Provider((_) => 42))]),
      throwsUnsupportedError,
    );
  });
  test('last family override is applied', () {
    final family = ProviderFamily<int, int>((ref, value) => 0);
    final container = ProviderContainer(overrides: [
      family.overrideAs((ref, value) => 1),
    ]);

    expect(container.read(family(0)), 1);

    container.updateOverrides([
      family.overrideAs((ref, value) => 2),
    ]);

    expect(container.read(family(0)), 1);
    expect(container.read(family(1)), 2);
  });
  test('guard listeners', () {
    final notifier = Counter();
    final provider = StateNotifierProvider((_) => notifier);
    final container = ProviderContainer();
    final listener = ListenerMock();
    final listener2 = ListenerMock();

    final firstErrors = <Object>[];
    runZonedGuarded(
      () => provider.state.watchOwner(container, (value) {
        listener(value);
        // ignore: only_throw_errors
        throw value;
      }),
      (err, _) => firstErrors.add(err),
    );

    verify(listener(0)).called(1);
    verifyNoMoreInteractions(listener);
    expect(firstErrors, [0]);

    provider.state.watchOwner(container, listener2);

    verify(listener2(0)).called(1);
    verifyNoMoreInteractions(listener2);

    final secondErrors = <Object>[];
    runZonedGuarded(
      notifier.increment,
      (err, _) => secondErrors.add(err),
    );

    expect(secondErrors, [1]);
    expect(firstErrors, [0]);
    verifyInOrder([
      listener(1),
      listener2(1),
    ]);
    verifyNoMoreInteractions(listener);
    verifyNoMoreInteractions(listener2);
  });
  test('reading unflushed triggers flush', () {
    final notifier = Counter();
    final provider = StateNotifierProvider((_) => notifier);
    final container = ProviderContainer();
    final listener = ListenerMock();
    final listener2 = ListenerMock();
    var callCount = 0;
    final computed = Computed((watch) {
      callCount++;
      return watch(provider.state);
    });

    final sub = computed.addLazyListener(
      container,
      mayHaveChanged: () {},
      onChange: listener,
    );

    verify(listener(0)).called(1);
    verifyNoMoreInteractions(listener);
    expect(callCount, 1);

    notifier.increment();

    verifyNoMoreInteractions(listener);

    final sub2 = computed.addLazyListener(
      container,
      mayHaveChanged: () {},
      onChange: listener2,
    );

    expect(callCount, 2);
    verifyNoMoreInteractions(listener);
    verify(listener2(1)).called(1);
    verifyNoMoreInteractions(listener2);

    expect(sub.flush(), true);

    verify(listener(1)).called(1);
    verifyNoMoreInteractions(listener);
    expect(callCount, 2);

    expect(sub2.flush(), isFalse);
    verifyNoMoreInteractions(listener);
    verifyNoMoreInteractions(listener2);
  });
  test('flusing closed subscription is noop', () {
    final notifier = Counter();
    final provider = StateNotifierProvider((_) => notifier);
    final container = ProviderContainer();
    final listener = ListenerMock();
    final mayHaveChanged = MockMarkMayHaveChanged();

    final sub = provider.state.addLazyListener(
      container,
      mayHaveChanged: mayHaveChanged,
      onChange: listener,
    );

    verify(listener(0)).called(1);
    verifyNoMoreInteractions(listener);
    verifyNoMoreInteractions(mayHaveChanged);

    sub.close();
    notifier.increment();
    final didFlush = sub.flush();

    expect(didFlush, isFalse);

    verifyNoMoreInteractions(listener);
    verifyNoMoreInteractions(listener);
  });

  test('redepth is recursive', () {
    final container = ProviderContainer();
    final provider = Provider((ref) => ref, name: '1');
    final provider2 = Provider((ref) => ref, name: '2');
    final provider3 = Provider((ref) => ref, name: '3');
    final provider4 = Provider((ref) => ref, name: '4');

    expect(container.debugProviderStates, <Object>[]);

    container.read(provider);
    final ref2 = container.read(provider2);
    final ref3 = container.read(provider3);
    final ref4 = container.read(provider4);

    expect(
      container.debugProviderStates,
      unorderedMatches(<Object>[
        isProvider(provider4),
        isProvider(provider3),
        isProvider(provider2),
        isProvider(provider),
      ]),
    );

    ref4.dependOn(provider3);

    expect(
      container.debugProviderStates,
      containsAllInOrder(<Object>[
        isProvider(provider3),
        isProvider(provider4),
      ]),
    );

    ref3.dependOn(provider2);

    expect(
      container.debugProviderStates,
      containsAllInOrder(<Object>[
        isProvider(provider2),
        isProvider(provider3),
        isProvider(provider4),
      ]),
    );

    ref2.dependOn(provider);

    expect(container.debugProviderStates, <Object>[
      isProvider(provider),
      isProvider(provider2),
      isProvider(provider3),
      isProvider(provider4),
    ]);
  });
  test("can't call onDispose inside onDispose", () {
    final provider = Provider((ref) {
      ref.onDispose(() {
        ref.onDispose(() {});
      });
      return ref;
    });
    final container = ProviderContainer();

    container.read(provider);

    final errors = <Object>[];
    runZonedGuarded(container.dispose, (err, _) => errors.add(err));

    expect(errors, [isStateError]);
  });
  test("can't call read inside onDispose", () {
    final provider2 = Provider((ref) => 0);
    final provider = Provider((ref) {
      ref.onDispose(() {
        ref.dependOn(provider2);
      });
      return ref;
    });
    final container = ProviderContainer();

    container.read(provider);

    final errors = <Object>[];
    runZonedGuarded(container.dispose, (err, _) => errors.add(err));

    expect(errors, [isStateError]);
  });
  test('container.debugProviderValues', () {
    final unnamed = Provider((_) => 0);
    final counter = Counter();
    final named = StateNotifierProvider((_) {
      return counter;
    }, name: 'named');
    final container = ProviderContainer();

    expect(container.debugProviderValues, <ProviderBase, Object>{});

    expect(container.read(unnamed), 0);

    expect(container.debugProviderValues, {
      unnamed: 0,
    });

    expect(container.read(named), counter);

    expect(container.debugProviderValues, {
      unnamed: 0,
      named: counter,
    });

    expect(container.read(named.state), 0);

    expect(container.debugProviderValues, {
      unnamed: 0,
      named: counter,
      named.state: 0,
    });
  });

  test('container life-cycles are unusuable after dispose', () {
    final container = ProviderContainer()..dispose();

    expect(container.dispose, throwsStateError);
    expect(() => container.updateOverrides([]), throwsStateError);
    expect(() => container.ref, throwsStateError);
    expect(() => container.readProviderState(Provider((_) => 0)),
        throwsStateError);
  });

  test('cannot call markMayHaveChanged after dispose', () {
    final container = ProviderContainer();
    final provider = TestProvider((ref) {});
    ProviderStateBase providerBaseState;
    provider.onInitState.thenAnswer((state) {
      providerBaseState = state;
    });

    container.read(provider);

    expect(providerBaseState.dirty, false);
    providerBaseState.markMayHaveChanged();
    expect(providerBaseState.dirty, true);

    container.read(provider);

    expect(providerBaseState.dirty, false);

    container.dispose();

    expect(
      () => providerBaseState.markMayHaveChanged(),
      throwsStateError,
    );
  });
  test('container.ref uses the override', () {
    final provider = Provider((_) => 42);
    final container = ProviderContainer();
    final container2 = ProviderContainer(overrides: [
      provider.overrideAs(
        Provider((_) => 21),
      ),
    ]);

    final ref = container.ref;
    final ref2 = container2.ref;

    expect(ref, isNot(ref2));
    expect(container.ref, ref);
    expect(container2.ref, ref2);

    expect(ref.dependOn(provider).value, 42);
    expect(ref2.dependOn(provider).value, 21);

    container.updateOverrides([]);
    container2.updateOverrides([
      provider.overrideAs(
        Provider((_) => 21),
      ),
    ]);

    expect(container.ref, ref);
    expect(container2.ref, ref2);
    expect(ref.dependOn(provider).value, 42);
    expect(ref2.dependOn(provider).value, 21);
  });

  test('Owner.read', () {
    final provider = TestProvider((ref) => 0);
    final provider2 = TestProvider((ref) => 1);
    final container = ProviderContainer();

    final value1 = container.ref.dependOn(provider);
    final value2 = container.ref.dependOn(provider);
    final value21 = container.ref.dependOn(provider2);
    final value22 = container.ref.dependOn(provider2);

    expect(value1, value2);
    expect(value1.value, 0);
    expect(value21, value22);
    expect(value21, isNot(value1));
    expect(value21.value, 1);
  });
  test(
      "updating overrides / dispose don't compute provider states if not loaded yet",
      () {
    var callCount = 0;
    final provider = Provider((_) => callCount++);

    final container = ProviderContainer(
      overrides: [provider.overrideAs(provider)],
    );

    expect(callCount, 0);

    container.updateOverrides([
      provider.overrideAs(provider),
    ]);

    expect(callCount, 0);

    container.dispose();

    expect(callCount, 0);
  });
  test('circular dependencies', () {
    Provider<int Function()> provider;

    final provider1 = Provider((ref) {
      return ref.dependOn(provider).value() + 1;
    });
    final provider2 = Provider((ref) {
      return ref.dependOn(provider1).value + 1;
    });
    provider = Provider((ref) {
      return () => ref.dependOn(provider2).value + 1;
    });

    final container = ProviderContainer();
    expect(
      () => container.read(provider)(),
      throwsA(isA<CircularDependencyError>()),
    );
  });
  test('circular dependencies #2', () {
    final container = ProviderContainer();

    final provider = Provider((ref) => ref);
    final provider1 = Provider((ref) => ref);
    final provider2 = Provider((ref) => ref);

    container.read(provider1).dependOn(provider);
    container.read(provider2).dependOn(provider1);
    final ref = container.read(provider);

    expect(
      () => ref.dependOn(provider2),
      throwsA(isA<CircularDependencyError>()),
    );
  });
  test('dispose providers in dependency order (simple)', () {
    final container = ProviderContainer();
    final onDispose1 = OnDisposeMock();
    final onDispose2 = OnDisposeMock();
    final onDispose3 = OnDisposeMock();

    final provider1 = Provider((ref) {
      ref.onDispose(onDispose1);
      return 1;
    });

    final provider2 = Provider((ref) {
      final value = ref.dependOn(provider1).value;
      ref.onDispose(onDispose2);
      return value + 1;
    });

    final provider3 = Provider((ref) {
      final value = ref.dependOn(provider2).value;
      ref.onDispose(onDispose3);
      return value + 1;
    });

    expect(container.read(provider3), 3);

    container.dispose();

    verifyInOrder([
      onDispose3(),
      onDispose2(),
      onDispose1(),
    ]);
    verifyNoMoreInteractions(onDispose1);
    verifyNoMoreInteractions(onDispose2);
    verifyNoMoreInteractions(onDispose3);
  });

  test('dispose providers in dependency order (late binding)', () {
    final container = ProviderContainer();
    final onDispose1 = OnDisposeMock();
    final onDispose2 = OnDisposeMock();
    final onDispose3 = OnDisposeMock();

    final provider1 = Provider((ref) {
      ref.onDispose(onDispose1);
      return 1;
    });

    final provider2 = Provider((ref) {
      ref.onDispose(onDispose2);
      return () => ref.dependOn(provider1).value + 1;
    });

    final provider3 = Provider((ref) {
      ref.onDispose(onDispose3);
      return () => ref.dependOn(provider2).value() + 1;
    });

    expect(container.read(provider3)(), 3);

    container.dispose();

    verifyInOrder([
      onDispose3(),
      onDispose2(),
      onDispose1(),
    ]);
    verifyNoMoreInteractions(onDispose1);
    verifyNoMoreInteractions(onDispose2);
    verifyNoMoreInteractions(onDispose3);
  });
  test('update providers in dependency order', () {
    final provider = TestProvider((_) => 1);
    final provider1 = TestProvider((ref) {
      return () => ref.dependOn(provider).value + 1;
    });
    final provider2 = TestProvider((ref) {
      return () => ref.dependOn(provider1).value() + 1;
    });

    final container = ProviderContainer(overrides: [
      provider.overrideAs(provider),
      provider1.overrideAs(provider1),
      provider2.overrideAs(provider2),
    ]);

    expect(container.read(provider2)(), 3);

    verifyZeroInteractions(provider.onDidUpdateProvider);
    verifyZeroInteractions(provider1.onDidUpdateProvider);
    verifyZeroInteractions(provider2.onDidUpdateProvider);

    container.updateOverrides([
      provider.overrideAs(provider),
      provider1.overrideAs(provider1),
      provider2.overrideAs(provider2),
    ]);

    verifyInOrder([
      provider.onDidUpdateProvider(),
      provider1.onDidUpdateProvider(),
      provider2.onDidUpdateProvider(),
    ]);
    verifyNoMoreInteractions(provider.onDidUpdateProvider);
    verifyNoMoreInteractions(provider1.onDidUpdateProvider);
    verifyNoMoreInteractions(provider2.onDidUpdateProvider);
  });
  test(
      'container.read used on same provider multiple times returns same instance',
      () {
    final container = ProviderContainer();
    final provider = Provider((_) => 42);

    ProviderDependency<int> other;
    ProviderDependency<int> other2;

    final provider1 = Provider((ref) {
      other = ref.dependOn(provider);
      other2 = ref.dependOn(provider);
      return other.value;
    });

    expect(container.read(provider1), 42);
    expect(other, other2);

    container.dispose();
  });
  test('ProviderReference is unusable after dispose (read/onDispose)', () {
    final container = ProviderContainer();
    ProviderReference ref;
    final provider = Provider((s) {
      ref = s;
      return 42;
    });
    final other = Provider((_) => 42);

    expect(container.read(provider), 42);
    container.dispose();

    expect(ref.mounted, isFalse);
    expect(() => ref.onDispose(() {}), throwsStateError);
    expect(() => ref.dependOn(other), throwsStateError);
  });

  test('if a provider threw on creation, subsequent reads throws too', () {
    var callCount = 0;
    final error = Error();
    final provider = Provider((_) {
      callCount++;
      throw error;
    });
    final container = ProviderContainer();

    expect(() => container.read(provider), throwsA(error));
    expect(callCount, 1);
    expect(() => container.read(provider), throwsA(error));
    expect(callCount, 1);

    expect(() => container.ref.dependOn(provider), throwsA(error));
    expect(callCount, 1);
    expect(() => container.ref.dependOn(provider), throwsA(error));
    expect(callCount, 1);

    expect(() => provider.watchOwner(container, (value) {}), throwsA(error));
    expect(callCount, 1);
    expect(() => provider.watchOwner(container, (value) {}), throwsA(error));
    expect(callCount, 1);
  });
  test('if a provider threw on creation, markNeedsNotify throws StateError',
      () {
    var callCount = 0;
    final error = Error();
    SetStateProviderReference<int> reference;
    final provider = SetStateProvider<int>((ref) {
      reference = ref;
      callCount++;
      throw error;
    });
    final container = ProviderContainer();

    expect(() => container.read(provider), throwsA(error));
    expect(callCount, 1);

    expect(() => reference.state = 42, throwsStateError);
  });
  test('if a provider threw on creation, onDispose still works', () {
    var callCount = 0;
    final onDispose = OnDisposeMock();
    final error = Error();
    ProviderReference reference;
    final provider = Provider((ref) {
      reference = ref;
      callCount++;
      ref.onDispose(onDispose);
      throw error;
    });
    final container = ProviderContainer();

    expect(() => container.read(provider), throwsA(error));
    expect(callCount, 1);

    final onDispose2 = OnDisposeMock();
    reference.onDispose(onDispose2);

    verifyNoMoreInteractions(onDispose);
    verifyNoMoreInteractions(onDispose2);

    container.dispose();

    expect(callCount, 1);
    verifyInOrder([
      onDispose(),
      onDispose2(),
    ]);
    verifyNoMoreInteractions(onDispose);
    verifyNoMoreInteractions(onDispose2);
  });
  group('notify listeners', () {
    test('calls onChange at most once per flush', () {
      final counter = Counter();
      final provider = StateNotifierProvider<Counter>((_) => counter);
      final container = ProviderContainer();
      final mayHaveChanged = MockMarkMayHaveChanged();
      final listener = ListenerMock();

      final sub = provider.state.addLazyListener(
        container,
        mayHaveChanged: mayHaveChanged,
        onChange: listener,
      );

      verify(listener(0)).called(1);
      verifyNoMoreInteractions(mayHaveChanged);
      verifyNoMoreInteractions(listener);

      sub.flush();

      verifyNoMoreInteractions(mayHaveChanged);
      verifyNoMoreInteractions(listener);

      counter.increment();

      verify(mayHaveChanged()).called(1);
      verifyNoMoreInteractions(mayHaveChanged);
      verifyNoMoreInteractions(listener);

      counter.increment();

      verifyNoMoreInteractions(mayHaveChanged);
      verifyNoMoreInteractions(listener);

      sub.flush();

      verify(listener(2)).called(1);
      verifyNoMoreInteractions(mayHaveChanged);
      verifyNoMoreInteractions(listener);

      counter.increment();

      verify(mayHaveChanged()).called(1);
      verifyNoMoreInteractions(mayHaveChanged);
      verifyNoMoreInteractions(listener);
    });
    test('noop inside initState', () {
      final provider = TestProvider((ref) {});
      final container = ProviderContainer();
      TestProviderState state;
      when(provider.onInitState(any)).thenAnswer((i) {
        state = i.positionalArguments.first as TestProviderState;

        expect(state.dirty, true);
        state..markMayHaveChanged()..markMayHaveChanged();
      });
      final mayHaveChanged = MockMarkMayHaveChanged();
      final listener = ListenerMock();

      final sub = provider.addLazyListener(
        container,
        mayHaveChanged: mayHaveChanged,
        onChange: listener,
      );

      verify(listener(any)).called(1);
      verifyNoMoreInteractions(listener);
      verifyNoMoreInteractions(mayHaveChanged);
      expect(state.dirty, false);

      sub.flush();

      verifyNoMoreInteractions(listener);
      verifyNoMoreInteractions(mayHaveChanged);
      expect(state.dirty, false);
    });
    test('noop if no provider was "dirty"', () {
      final counter = Counter();
      final provider = StateNotifierProvider<Counter>((_) => counter);
      final container = ProviderContainer();
      final mayHaveChanged = MockMarkMayHaveChanged();
      final listener = ListenerMock();

      final sub = provider.state.addLazyListener(
        container,
        mayHaveChanged: mayHaveChanged,
        onChange: listener,
      );

      verify(listener(0)).called(1);
      verifyNoMoreInteractions(listener);

      sub.flush();
      verifyNoMoreInteractions(listener);

      counter..increment()..increment();

      verifyNoMoreInteractions(listener);

      sub.flush();

      verify(listener(2)).called(1);
      verifyNoMoreInteractions(listener);

      sub.flush();

      verifyNoMoreInteractions(listener);
    });
    test('update first update providers then dispatch notifications', () {
      final futureProvider = FutureProvider((_) async => 0);
      final container = ProviderContainer(overrides: [
        futureProvider.debugOverrideWithValue(const AsyncValue.loading()),
      ]);
      final listener = AsyncListenerMock();

      futureProvider.watchOwner(container, listener);

      verify(listener(const AsyncValue.loading())).called(1);
      verifyNoMoreInteractions(listener);

      container.updateOverrides([
        futureProvider.debugOverrideWithValue(const AsyncValue.data(42)),
      ]);

      verify(listener(const AsyncValue.data(42))).called(1);
      verifyNoMoreInteractions(listener);
    });
    test('on update`', () async {
      final container = ProviderContainer();
      final counter = Counter();
      final provider = StateNotifierProvider<Counter>((_) => counter);
      final mayHaveChanged = MockMarkMayHaveChanged();
      final listener = ListenerMock();

      final sub = provider.state.addLazyListener(
        container,
        mayHaveChanged: mayHaveChanged,
        onChange: listener,
      );

      verify(listener(0)).called(1);
      verifyNoMoreInteractions(listener);

      counter.increment();
      verifyNoMoreInteractions(listener);

      counter.increment();
      verifyNoMoreInteractions(listener);

      sub.flush();

      verify(listener(2)).called(1);
      verifyNoMoreInteractions(listener);
    });
    test('in dependency order', () async {
      final container = ProviderContainer();
      final counter = Counter();
      final counter2 = Counter();
      final counter3 = Counter();

      final provider = StateNotifierProvider<Counter>((_) => counter);
      final provider2 = StateNotifierProvider<Counter>((ref) {
        ref.dependOn(provider);
        return counter2;
      });
      final provider3 = StateNotifierProvider<Counter>((ref) {
        ref.dependOn(provider2);
        return counter3;
      });

      final mayHaveChanged = MockMarkMayHaveChanged();
      final listener = ListenerMock('first');
      final sub = provider.state.addLazyListener(
        container,
        mayHaveChanged: mayHaveChanged,
        onChange: listener,
      );

      final mayHaveChanged2 = MockMarkMayHaveChanged();
      final listener2 = ListenerMock('second');
      final sub2 = provider2.state.addLazyListener(
        container,
        mayHaveChanged: mayHaveChanged2,
        onChange: listener2,
      );

      final mayHaveChanged3 = MockMarkMayHaveChanged();
      final listener3 = ListenerMock('third');
      final sub3 = provider3.state.addLazyListener(
        container,
        mayHaveChanged: mayHaveChanged3,
        onChange: listener3,
      );

      verify(listener(0)).called(1);
      verifyNoMoreInteractions(listener);
      verify(listener2(0)).called(1);
      verifyNoMoreInteractions(listener2);
      verify(listener3(0)).called(1);
      verifyNoMoreInteractions(listener3);

      counter3.increment();
      counter2.increment();
      counter.increment();

      verifyInOrder([
        mayHaveChanged3(),
        mayHaveChanged2(),
        mayHaveChanged(),
      ]);

      sub3.flush();

      verify(listener3(1)).called(1);
      verifyNoMoreInteractions(listener);
      verifyNoMoreInteractions(listener2);
      verifyNoMoreInteractions(listener3);

      sub2.flush();
      verify(listener2(1)).called(1);
      verifyNoMoreInteractions(listener);
      verifyNoMoreInteractions(listener2);
      verifyNoMoreInteractions(listener3);

      sub.flush();
      verify(listener(1)).called(1);
      verifyNoMoreInteractions(listener);
      verifyNoMoreInteractions(listener2);
      verifyNoMoreInteractions(listener3);
    });
  });
}

class AsyncListenerMock extends Mock {
  void call(AsyncValue<int> value);
}

class ListenerMock extends Mock {
  ListenerMock([this.debugLabel]);
  final String debugLabel;

  void call(int value);

  @override
  String toString() {
    if (debugLabel != null) {
      return debugLabel;
    }
    return super.toString();
  }
}

class Counter extends StateNotifier<int> {
  Counter([int initialValue = 0]) : super(initialValue);

  void increment() => state++;
}

class OnDisposeMock extends Mock {
  void call();
}

class MockMarkMayHaveChanged extends Mock {
  void call();
}

class MockDidUpdateProvider extends Mock {
  void call();
}

class MockInitState<T> extends Mock {
  void call(TestProviderState<T> state);

  void thenAnswer(void Function(TestProviderState<T> state) cb) {
    when(this(any)).thenAnswer((realInvocation) {
      Function.apply(
        cb,
        realInvocation.positionalArguments,
        realInvocation.namedArguments,
      );
    });
  }
}

class MockOnValueDispose<T> extends Mock {
  void call(TestProviderValue<T> value);
}

class TestProviderValue<T> extends ProviderDependencyBase {
  TestProviderValue(this.value);

  final T value;
}

class TestProvider<T> extends AlwaysAliveProviderBase<TestProviderValue<T>, T> {
  TestProvider(this.create, {String name}) : super(name);

  final T Function(ProviderReference ref) create;
  final MockInitState<T> onInitState = MockInitState();
  final MockDidUpdateProvider onDidUpdateProvider = MockDidUpdateProvider();

  @override
  TestProviderState<T> createState() {
    return TestProviderState<T>();
  }
}

class TestProviderState<T>
    extends ProviderStateBase<TestProviderValue<T>, T, TestProvider<T>> {
  @override
  T state;

  @override
  void initState() {
    provider.onInitState(this);
    state = provider.create(ProviderReference(this));
  }

  @override
  void didUpdateProvider(TestProvider<T> oldProvider) {
    super.didUpdateProvider(oldProvider);
    provider.onDidUpdateProvider?.call();
  }

  @override
  TestProviderValue<T> createProviderDependency() {
    return TestProviderValue<T>(state);
  }
}
