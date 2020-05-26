import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod/src/internals.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:test/test.dart';

void main() {
  // TODO auto dispose Computed when no longer used (or at least destroy the listeners)
  test('dispose Computed when all Computed listeners are removed', () {
    final notifier = Notifier(0);
    final provider = StateNotifierProvider<Notifier<int>, int>((_) => notifier);
    final computed = Computed((read) => read(provider.value));
    final root = ProviderStateOwner();
    final owner = ProviderStateOwner(parent: root, overrides: [computed]);
    final listener = Listener<int>();

    computed.watchOwner(owner, listener);

    verify(listener(0)).called(1);
    verifyNoMoreInteractions(listener);

    owner.dispose();
    verifyNoMoreInteractions(listener);

    notifier.setState(42);
    root.update();

    verifyNoMoreInteractions(listener);
  });
  test('cannot call read outside of the Computed', () {
    final owner = ProviderStateOwner();
    final notifier = Notifier(0);
    final provider = StateNotifierProvider<Notifier<int>, int>((_) => notifier);
    var callCount = 0;
    Reader reader;
    final computed = Computed((read) {
      callCount++;
      reader = read;
      return read(provider.value);
    });
    final listener = Listener<int>();

    computed.watchOwner(owner, listener);

    verify(listener(0)).called(1);
    verifyNoMoreInteractions(listener);
    expect(() => reader(provider), throwsA(isA<AssertionError>()));
    expect(callCount, 1);

    notifier.setState(42);
    verifyNoMoreInteractions(listener);

    owner.update();

    verify(listener(42)).called(1);
    verifyNoMoreInteractions(listener);
    expect(() => reader(provider), throwsA(isA<AssertionError>()));
    expect(callCount, 2);
  });
  group('deeply compares collections', () {
    test('list', () {
      final owner = ProviderStateOwner();
      final notifier = Notifier(0);
      final provider =
          StateNotifierProvider<Notifier<int>, int>((_) => notifier);
      final computed = Computed((read) {
        return [read(provider.value).isNegative];
      });
      final listener = Listener<List<bool>>();

      computed.watchOwner(owner, listener);

      verify(listener([false])).called(1);
      verifyNoMoreInteractions(listener);

      notifier.setState(42);
      owner.update();

      verifyNoMoreInteractions(listener);
    });
    test('set', () {
      final owner = ProviderStateOwner();
      final notifier = Notifier(0);
      final provider =
          StateNotifierProvider<Notifier<int>, int>((_) => notifier);
      final computed = Computed((read) {
        return {read(provider.value).isNegative};
      });
      final listener = Listener<Set<bool>>();

      computed.watchOwner(owner, listener);

      verify(listener({false})).called(1);
      verifyNoMoreInteractions(listener);

      notifier.setState(42);
      owner.update();

      verifyNoMoreInteractions(listener);
    });
    test('map', () {
      final owner = ProviderStateOwner();
      final notifier = Notifier(0);
      final provider =
          StateNotifierProvider<Notifier<int>, int>((_) => notifier);
      final computed = Computed((read) {
        return {'foo': read(provider.value).isNegative};
      });
      final listener = Listener<Map<String, bool>>();

      computed.watchOwner(owner, listener);

      verify(listener({'foo': false})).called(1);
      verifyNoMoreInteractions(listener);

      notifier.setState(42);
      owner.update();

      verifyNoMoreInteractions(listener);
    });
  });
  test('the value is cached between multiple listeners', () {
    final owner = ProviderStateOwner();
    final notifier = Notifier(0);
    final provider = StateNotifierProvider<Notifier<int>, int>((_) => notifier);
    var callCount = 0;
    final computed = Computed((read) {
      callCount++;
      return [read(provider.value)];
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

    owner.update();

    expect(callCount, 1);
    verifyNoMoreInteractions(firstListener);
    verifyNoMoreInteractions(secondListener);
  });
  test('Simple Computed flow', () {
    final owner = ProviderStateOwner();
    final notifier = Notifier(0);
    final provider = StateNotifierProvider<Notifier<int>, int>((_) => notifier);
    final listener = Listener<bool>();
    var callCount = 0;
    final isPositiveComputed = Computed((read) {
      callCount++;
      return !read(provider.value).isNegative;
    });

    expect(isPositiveComputed, isNot(isA<AlwaysAliveProvider>()));
    verifyNoMoreInteractions(listener);
    expect(callCount, 0);

    isPositiveComputed.watchOwner(owner, listener);
    expect(notifier.hasListeners, true);
    verify(listener(true)).called(1);
    expect(callCount, 1);
    verifyNoMoreInteractions(listener);

    notifier.setState(-1);
    verifyNoMoreInteractions(listener);

    owner.update();

    expect(callCount, 2);
    verify(listener(false)).called(1);
    verifyNoMoreInteractions(listener);

    notifier.setState(-42);
    verifyNoMoreInteractions(listener);

    owner.update();

    expect(callCount, 3);
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
