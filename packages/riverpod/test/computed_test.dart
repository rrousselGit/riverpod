import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod/src/internals.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:test/test.dart';

void main() {
  // TODO auto dispose Computed when no longer used (or at least destroy the listeners)
  test(
      'Computed are stored on the deeper ProviderStateOwner and cannot be overriden (insert in parent owner first then child owner)',
      () {
    final root = ProviderStateOwner();
    final owner = ProviderStateOwner(parent: root);
    var callCount = 0;
    final computed = Computed((_) => callCount++);
    final rootListener = Listener<int>();
    final ownerListener = Listener<int>();

    computed.watchOwner(root, rootListener);

    expect(callCount, 1);
    verify(rootListener(0)).called(1);
    verifyNoMoreInteractions(rootListener);

    computed.watchOwner(owner, ownerListener);

    expect(callCount, 2);
    verify(ownerListener(1)).called(1);
    verifyNoMoreInteractions(ownerListener);

    computed.watchOwner(root, rootListener);

    expect(callCount, 2);
    verify(rootListener(0)).called(1);
    verifyNoMoreInteractions(rootListener);

    computed.watchOwner(owner, ownerListener);

    expect(callCount, 2);
    verify(ownerListener(1)).called(1);
    verifyNoMoreInteractions(ownerListener);
  });

  test('Computeds are added to the overall list of providers', () {
    final owner = ProviderStateOwner();
    final provider = Provider((_) => 42);
    final computed = Computed((read) => read(provider) * 2);
    final provider2 = Provider((ref) => ref.dependOn(computed));
    final listener = Listener<int>();

    provider2.readOwner(owner);
    computed.watchOwner(owner, listener);

    verify(listener(84)).called(1);
    verifyNoMoreInteractions(listener);

    expect(
      owner.debugProviderStateSortedByDepth.map((e) => e.provider),
      [provider, computed, provider2],
    );
  });
  test('Computed are not overrides', () {
    expect(Computed((_) {}), isNot(isA<ProviderOverride>()));
  });
  test('disposing the Computed closes subscriptions', () {
    final notifier = Notifier(0);
    final provider = StateNotifierProvider<Notifier<int>>((_) => notifier);
    final computed = Computed((read) => read(provider.state));
    final root = ProviderStateOwner();
    // no need to pass "overrides" as the computed should naturally go to the deepest owner
    final owner = ProviderStateOwner(parent: root);
    final mayHaveChanged = MockMarkMayHaveChanged();
    final listener = Listener<int>();

    final sub = computed.addLazyListener(
      owner,
      mayHaveChanged: mayHaveChanged,
      onChange: listener,
    );

    verify(listener(0)).called(1);
    verifyNoMoreInteractions(mayHaveChanged);
    verifyNoMoreInteractions(listener);

    owner.dispose();
    verifyNoMoreInteractions(mayHaveChanged);
    verifyNoMoreInteractions(listener);

    notifier.setState(42);

    verify(mayHaveChanged()).called(1);
    verifyNoMoreInteractions(listener);
    verifyNoMoreInteractions(mayHaveChanged);

    sub.flush();

    verifyNoMoreInteractions(mayHaveChanged);
    verifyNoMoreInteractions(listener);
  }, skip: true);
  test('cannot call read outside of the Computed', () {
    final owner = ProviderStateOwner();
    final notifier = Notifier(0);
    final provider = StateNotifierProvider<Notifier<int>>((_) => notifier);
    var callCount = 0;
    Reader reader;
    final computed = Computed((read) {
      callCount++;
      reader = read;
      return read(provider.state);
    });
    final mayHaveChanged = MockMarkMayHaveChanged();
    final listener = Listener<int>();

    final sub = computed.addLazyListener(
      owner,
      mayHaveChanged: mayHaveChanged,
      onChange: listener,
    );

    verify(listener(0)).called(1);
    verifyNoMoreInteractions(listener);
    verifyNoMoreInteractions(mayHaveChanged);
    expect(() => reader(provider), throwsA(isA<AssertionError>()));
    expect(callCount, 1);

    notifier.setState(42);

    verify(mayHaveChanged()).called(1);
    verifyNoMoreInteractions(mayHaveChanged);
    verifyNoMoreInteractions(listener);

    sub.flush();

    verify(listener(42)).called(1);
    verifyNoMoreInteractions(mayHaveChanged);
    verifyNoMoreInteractions(listener);
    expect(() => reader(provider), throwsA(isA<AssertionError>()));
    expect(callCount, 2);
  });
  group('deeply compares collections', () {
    test('list', () {
      final owner = ProviderStateOwner();
      final notifier = Notifier(0);
      final provider = StateNotifierProvider<Notifier<int>>((_) => notifier);
      final computed = Computed((read) {
        return [read(provider.state).isNegative];
      });
      final mayHaveChanged = MockMarkMayHaveChanged();
      final listener = Listener<List<bool>>();

      final sub = computed.addLazyListener(
        owner,
        mayHaveChanged: mayHaveChanged,
        onChange: listener,
      );

      verify(listener([false])).called(1);
      verifyNoMoreInteractions(listener);
      verifyNoMoreInteractions(mayHaveChanged);

      notifier.setState(42);

      verify(mayHaveChanged()).called(1);
      verifyNoMoreInteractions(listener);
      verifyNoMoreInteractions(mayHaveChanged);

      sub.flush();

      verifyNoMoreInteractions(mayHaveChanged);
      verifyNoMoreInteractions(listener);
    });
    test('set', () {
      final owner = ProviderStateOwner();
      final notifier = Notifier(0);
      final provider = StateNotifierProvider<Notifier<int>>((_) => notifier);
      final computed = Computed((read) {
        return {read(provider.state).isNegative};
      });
      final mayHaveChanged = MockMarkMayHaveChanged();
      final listener = Listener<Set<bool>>();

      final sub = computed.addLazyListener(
        owner,
        mayHaveChanged: mayHaveChanged,
        onChange: listener,
      );

      verify(listener({false})).called(1);
      verifyNoMoreInteractions(listener);
      verifyNoMoreInteractions(mayHaveChanged);

      notifier.setState(42);

      verify(mayHaveChanged()).called(1);
      verifyNoMoreInteractions(listener);
      verifyNoMoreInteractions(mayHaveChanged);

      sub.flush();

      verifyNoMoreInteractions(mayHaveChanged);
      verifyNoMoreInteractions(listener);
    });
    test('map', () {
      final owner = ProviderStateOwner();
      final notifier = Notifier(0);
      final provider = StateNotifierProvider<Notifier<int>>((_) => notifier);
      final computed = Computed((read) {
        return {'foo': read(provider.state).isNegative};
      });
      final mayHaveChanged = MockMarkMayHaveChanged();
      final listener = Listener<Map<String, bool>>();

      final sub = computed.addLazyListener(
        owner,
        mayHaveChanged: mayHaveChanged,
        onChange: listener,
      );

      verify(listener({'foo': false})).called(1);
      verifyNoMoreInteractions(listener);
      verifyNoMoreInteractions(mayHaveChanged);

      notifier.setState(42);

      verify(mayHaveChanged()).called(1);
      verifyNoMoreInteractions(listener);
      verifyNoMoreInteractions(mayHaveChanged);

      sub.flush();

      verifyNoMoreInteractions(mayHaveChanged);
      verifyNoMoreInteractions(listener);
    });
  });
  test('the value is cached between multiple listeners', () {
    final owner = ProviderStateOwner();
    final notifier = Notifier(0);
    final provider = StateNotifierProvider<Notifier<int>>((_) => notifier);
    var callCount = 0;
    final computed = Computed((read) {
      callCount++;
      return [read(provider.state)];
    });

    List<int> first;
    final firstListener = Listener<List<int>>();
    computed.watchOwner(owner, (value) {
      first = value;
      firstListener(value);
    });
    List<int> second;
    final secondListener = Listener<List<int>>();
    computed.watchOwner(owner, (value) {
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
  test('Computed is not a AlwaysAliveProvider', () {
    final computed = Computed((read) => 0);

    expect(computed, isNot(isA<AlwaysAliveProvider>()));
  });
  test('Simple Computed flow', () {
    final owner = ProviderStateOwner();
    final notifier = Notifier(0);
    final provider = StateNotifierProvider<Notifier<int>>((_) => notifier);
    final mayHaveChanged = MockMarkMayHaveChanged();
    final listener = Listener<bool>();
    var callCount = 0;
    final isPositiveComputed = Computed((read) {
      callCount++;
      return !read(provider.state).isNegative;
    });

    final sub = isPositiveComputed.addLazyListener(
      owner,
      mayHaveChanged: mayHaveChanged,
      onChange: listener,
    );

    expect(notifier.hasListeners, true);
    verify(listener(true)).called(1);
    expect(callCount, 1);
    verifyNoMoreInteractions(listener);
    verifyNoMoreInteractions(mayHaveChanged);

    notifier.setState(-1);

    verify(mayHaveChanged()).called(1);
    verifyNoMoreInteractions(mayHaveChanged);
    verifyNoMoreInteractions(listener);


    sub.flush();

    expect(callCount, 2);
    verify(listener(false)).called(1);
    verifyNoMoreInteractions(mayHaveChanged);
    verifyNoMoreInteractions(listener);

    notifier.setState(-42);

    verify(mayHaveChanged()).called(1);
    verifyNoMoreInteractions(mayHaveChanged);
    verifyNoMoreInteractions(listener);

    sub.flush();

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

class MockMarkMayHaveChanged extends Mock {
  void call();
}
