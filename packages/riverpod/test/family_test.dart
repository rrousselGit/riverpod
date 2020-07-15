import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:test/test.dart';

void main() {
  test('caches the provider per value', () {
    final provider = Provider.family<String, int>((ref, a) => '$a');
    final container = ProviderContainer();

    expect(provider(42), provider(42));
    expect(container.read(provider(42)), '42');

    expect(provider(21), provider(21));
    expect(container.read(provider(21)), '21');
  });
  test('each provider updates their dependents independently', () {
    final controllers = {
      0: StreamController<String>(sync: true),
      1: StreamController<String>(sync: true),
    };
    final provider = StreamProvider.family<String, int>((ref, a) {
      return controllers[a].stream;
    });
    final container = ProviderContainer();
    final listener = Listener<AsyncValue<String>>();
    final listener2 = Listener<AsyncValue<String>>();

    provider(0).watchOwner(container, listener);
    verify(listener(const AsyncValue.loading()));
    verifyNoMoreInteractions(listener);
    verifyNoMoreInteractions(listener2);

    provider(1).watchOwner(container, listener2);
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
        StateNotifierProvider.family<Counter, int>((_, a) => Counter());
    expect(
      provider(0),
      isA<StateNotifierProvider<Counter>>()
          .having((p) => p.parameter, 'parameter', 0),
    );
    expect(
      provider(1),
      isA<StateNotifierProvider<Counter>>()
          .having((p) => p.parameter, 'parameter', 1),
    );
  });

  test('family override', () {
    final provider = Provider.family<String, int>((ref, a) => '$a');
    final container = ProviderContainer(overrides: [
      // Provider overrides always takes over family overrides
      provider(84).overrideAs(Provider((_) => 'Bonjour 84')),
      provider.overrideAs((ref, a) => 'Hello $a'),
      provider(21).overrideAs(Provider((_) => 'Hi 21')),
    ]);

    expect(container.read(provider(42)), 'Hello 42');

    expect(container.read(provider(21)), 'Hi 21');

    expect(container.read(provider(84)), 'Bonjour 84');
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
