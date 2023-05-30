import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';

/* SNIPPET START */

// Ein Zähler implementiert und getestet nur mit Dart (keine Abhängigkeit zu Flutter)

// Wir haben einen Provider global deklariert und werden ihn in zwei Tests
// verwenden, um zu sehen, ob der Zustand zwischen den Tests korrekt auf `0`
// zurückgesetzt wird.

final counterProvider = StateProvider((ref) => 0);

// Verwendung von mockito, um zu verfolgen, wann ein Provider seine Zuhörer benachrichtigt
class Listener extends Mock {
  void call(int? previous, int value);
}

void main() {
  test('defaults to 0 and notify listeners when value changes', () {
    // Ein Objekt, das uns erlauben wird Provider auszulesen
    // Teile das nicht zwischen den Tests
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final listener = Listener();

    // Beobachten Sie einen Provider und erspähen Sie die Veränderungen.
    container.listen<int>(
      counterProvider,
      listener.call,
      fireImmediately: true,
    );

    // Der listener wurde sofort mit 0 aufgerufen, der Standardwert
    verify(listener(null, 0)).called(1);
    verifyNoMoreInteractions(listener);

    // We increment the value
    container.read(counterProvider.notifier).state++;

    // Der listener wurde wieder aufgerufen, aber mit der 1 dieses mal
    verify(listener(0, 1)).called(1);
    verifyNoMoreInteractions(listener);
  });

  test('the counter state is not shared between tests', () {
    // Wir verwenden einen anderen ProviderContainer, um unseren Provider zu lesen.
    // Dadurch wird sichergestellt, dass kein Zustand zwischen den Tests wiederverwendet wird.
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final listener = Listener();

    container.listen<int>(
      counterProvider,
      listener.call,
      fireImmediately: true,
    );

    // Der neue Test verwendet den Standardwert: 0 richtig
    verify(listener(null, 0)).called(1);
    verifyNoMoreInteractions(listener);
  });
}
