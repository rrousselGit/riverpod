// ignore_for_file: unused_local_variable

import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod/riverpod.dart';

import 'create_container.dart';

final provider = FutureProvider((_) async => 42);

void main() {
  test('Some description', () async {
    // Crea un ProviderContainer per questo test.
    // NON condivedere i ProviderContainer tra i vari test.
    final container = createContainer();

    /* SNIPPET START */
    // TODO: usa il container per testare la tua applicazione.
    // Il valore atteso è asincrono, quindi dovremmo usare "expectLater"
    await expectLater(
      // Leggiamo "provider.future" invece di "provider".
      // Questo è possibile su provider asincroni e restituisce un future
      // che si risolverà con il valore del provider.
      container.read(provider.future),
      // Possiamo verificare che quel future si risolva con il valore atteso.
      // In alternativa possiamo usare "throwsA" per gli errori.
      completion('some value'),
    );
    /* SNIPPET END */
  });
}
