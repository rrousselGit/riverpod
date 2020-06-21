import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:test/test.dart';

void main() {
  test('caches the provider per value', () {
    final provider = ProviderFamily<String, int>((ref, a) => '$a');
    final owner = ProviderStateOwner();

    expect(provider(42), provider(42));
    expect(provider(42).readOwner(owner), '42');

    expect(provider(21), provider(21));
    expect(provider(21).readOwner(owner), '21');
  });
  test('each provider updates their dependents independently', () {
    final controllers = {
      0: StreamController<String>(sync: true),
      1: StreamController<String>(sync: true),
    };
    final provider = StreamProviderFamily<String, int>((ref, a) {
      return controllers[a].stream;
    });
    final owner = ProviderStateOwner();
    final listener = Listener<AsyncValue<String>>();
    final listener2 = Listener<AsyncValue<String>>();

    provider(0).watchOwner(owner, listener);
    verify(listener(const AsyncValue.loading()));
    verifyNoMoreInteractions(listener);
    verifyNoMoreInteractions(listener2);

    provider(1).watchOwner(owner, listener2);
    verify(listener2(const AsyncValue.loading()));
    verifyNoMoreInteractions(listener);
    verifyNoMoreInteractions(listener2);

    controllers[0].add('42');

    verify(listener(const AsyncValue.data('42')));
    verifyNoMoreInteractions(listener);
    verifyNoMoreInteractions(listener2);

    controllers[1].add('21');

    verify(listener2(const AsyncValue.data('21')));
    verifyNoMoreInteractions(listener);
    verifyNoMoreInteractions(listener2);
  });
  test('Pass family and parameter properties', () {
    final provider =
        StateNotifierProviderFamily<Counter, int>((_, a) => Counter());
    expect(
      provider(0),
      isA<StateNotifierProvider<Counter>>()
          .having((p) => p.family, 'family', provider)
          .having((p) => p.parameter, 'parameter', 0),
    );
    expect(
      provider(1),
      isA<StateNotifierProvider<Counter>>()
          .having((p) => p.family, 'family', provider)
          .having((p) => p.parameter, 'parameter', 1),
    );
  });

  test('StateProvider', () async {
    final provider = StateProviderFamily<String, int>((ref, a) {
      return '$a';
    });
    final owner = ProviderStateOwner();

    expect(
      provider(0).readOwner(owner),
      isA<StateController>().having((s) => s.state, 'state', '0'),
    );
    expect(
      provider(1).readOwner(owner),
      isA<StateController>().having((s) => s.state, 'state', '1'),
    );
  });

  group('overrides', () {
    test('family override', () {
      final provider = ProviderFamily<String, int>((ref, a) => '$a');
      final root = ProviderStateOwner();
      final owner = ProviderStateOwner(parent: root, overrides: [
        // Provider overrides always takes over family overrides
        provider(84).overrideAs(Provider((_) => 'Bonjour 84')),
        provider.overrideAs((ref, a) => 'Hello $a'),
        provider(21).overrideAs(Provider((_) => 'Hi 21')),
      ]);

      expect(provider(42).readOwner(root), '42');
      expect(provider(42).readOwner(owner), 'Hello 42');

      expect(provider(21).readOwner(root), '21');
      expect(provider(21).readOwner(owner), 'Hi 21');

      expect(provider(84).readOwner(root), '84');
      expect(provider(84).readOwner(owner), 'Bonjour 84');
    });

    test('StateNotifier family override', () {
      final notifier = Counter();
      final notifier2 = Counter(42);
      final provider =
          StateNotifierProviderFamily<Counter, int>((ref, a) => notifier);
      final root = ProviderStateOwner();
      final owner = ProviderStateOwner(parent: root, overrides: [
        provider.overrideAs((ref, a) => notifier2),
      ]);

      // populate in the root first
      expect(provider(0).state.readOwner(root), 0);
      expect(provider(0).readOwner(root), notifier);

      // access in the child owner
      // try to read provider.state before provider and see if it points to the override
      expect(provider(0).state.readOwner(owner), 42);
      expect(provider(0).readOwner(owner), notifier2);
    });
    test('StreamProvider', () async {
      final provider = StreamProviderFamily<String, int>((ref, a) {
        return Stream.value('$a');
      });
      final owner = ProviderStateOwner(overrides: [
        provider.overrideAs((ref, a) => Stream.value('override $a')),
      ]);

      expect(provider(0).readOwner(owner), const AsyncValue<String>.loading());

      await Future<void>.value();

      expect(
        provider(0).readOwner(owner),
        const AsyncValue<String>.data('override 0'),
      );
    });
    test('FutureProvider', () async {
      final provider = FutureProviderFamily<String, int>((ref, a) {
        return Future.value('$a');
      });
      final owner = ProviderStateOwner(overrides: [
        provider.overrideAs((ref, a) => Future.value('override $a')),
      ]);

      expect(provider(0).readOwner(owner), const AsyncValue<String>.loading());

      await Future<void>.value();

      expect(
        provider(0).readOwner(owner),
        const AsyncValue<String>.data('override 0'),
      );
    });
    test('StateProvider', () async {
      final provider = StateProviderFamily<String, int>((ref, a) {
        return '$a';
      });
      final owner = ProviderStateOwner(overrides: [
        provider.overrideAs((ref, a) => 'override $a'),
      ]);

      expect(
        provider(0).readOwner(owner),
        isA<StateController>().having((s) => s.state, 'state', 'override 0'),
      );
      expect(
        provider(1).readOwner(owner),
        isA<StateController>().having((s) => s.state, 'state', 'override 1'),
      );
    });
    test('Computed', () {
      final computed =
          ComputedFamily<String, SetStateProvider<int>>((read, provider) {
        return read(provider).toString();
      });
      final notifier = Counter();
      final provider = StateNotifierProvider((_) => notifier);
      final owner = ProviderStateOwner();
      final listener = Listener<String>();

      computed(provider.state).watchOwner(owner, listener);

      verify(listener('0')).called(1);
      verifyNoMoreInteractions(listener);

      notifier.state = 42;

      verify(listener('42')).called(1);
      verifyNoMoreInteractions(listener);
    });
  });
}

class Listener<T> extends Mock {
  void call(T value);
}

class Counter extends StateNotifier<int> {
  Counter([int initialValue = 0]) : super(initialValue);

  @override
  int get state => super.state;
  @override
  set state(int value) => super.state = value;
}
