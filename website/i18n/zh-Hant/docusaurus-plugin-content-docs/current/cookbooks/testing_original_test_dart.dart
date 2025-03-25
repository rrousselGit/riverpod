import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';

/* SNIPPET START */

// A Counter implemented and tested with Dart only (no dependency on Flutter)

// We declared a provider globally, and we will use it in two tests, to see
// if the state correctly resets to `0` between tests.

final counterProvider = StateProvider((ref) => 0);

// Using mockito to keep track of when a provider notify its listeners
class Listener extends Mock {
  void call(int? previous, int value);
}

void main() {
  test('defaults to 0 and notify listeners when value changes', () {
    // An object that will allow us to read providers
    // Do not share this between tests.
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final listener = Listener();

    // Observe a provider and spy the changes.
    container.listen<int>(
      counterProvider,
      listener.call,
      fireImmediately: true,
    );

    // the listener is called immediately with 0, the default value
    verify(listener(null, 0)).called(1);
    verifyNoMoreInteractions(listener);

    // We increment the value
    container.read(counterProvider.notifier).state++;

    // The listener was called again, but with 1 this time
    verify(listener(0, 1)).called(1);
    verifyNoMoreInteractions(listener);
  });

  test('the counter state is not shared between tests', () {
    // We use a different ProviderContainer to read our provider.
    // This ensure that no state is reused between tests
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final listener = Listener();

    container.listen<int>(
      counterProvider,
      listener.call,
      fireImmediately: true,
    );

    // The new test correctly uses the default value: 0
    verify(listener(null, 0)).called(1);
    verifyNoMoreInteractions(listener);
  });
}
