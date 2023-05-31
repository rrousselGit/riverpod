import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';

/* SNIPPET START */

// Un contatore implementato e testato solo con Dart (nessuna dipendenza da Flutter)

// Abbiamo dichiarato un provider globalmente e lo useremo in due test
// per vedere se lo stato si resetta correttamente a `0` tra i test.

final counterProvider = StateProvider((ref) => 0);

// Usiamo 'mockito' per tener traccia di quando un provider notifica i suoi listener
class Listener extends Mock {
  void call(int? previous, int value);
}

void main() {
  test('defaults to 0 and notify listeners when value changes', () {
    // Un oggetto che ci permetterà di leggere i provider
    // Non viene condiviso tra i test.
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final listener = Listener();

    // Osserva un provider e ne spia i cambiamenti
    container.listen<int>(
      counterProvider,
      listener.call,
      fireImmediately: true,
    );

    // Il listener è chiamato immediatamente con 0, il valore di default
    verify(listener(null, 0)).called(1);
    verifyNoMoreInteractions(listener);

    // Incrementiamo il valore
    container.read(counterProvider.notifier).state++;

    // Il listener è chiamato di nuovo ma questa volta con valore 1
    verify(listener(0, 1)).called(1);
    verifyNoMoreInteractions(listener);
  });

  test('the counter state is not shared between tests', () {
    // Usiamo un ProviderContainer diverso per leggere il nostro provider.
    // Ciò assicura che nessun stato sia riusato tra i test
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final listener = Listener();

    container.listen<int>(
      counterProvider,
      listener.call,
      fireImmediately: true,
    );

    // Il nuovo test usa correttamente il valore di default 0
    verify(listener(null, 0)).called(1);
    verifyNoMoreInteractions(listener);
  });
}
