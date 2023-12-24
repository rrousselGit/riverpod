// ignore_for_file: unused_local_variable

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'create_container.dart';
import 'full_widget_test.dart';
import 'provider_to_mock/raw.dart';

void main() {
  testWidgets('Some description', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: YourWidgetYouWantToTest()),
    );
    /* SNIPPET START */
    // Nei test unitari, riutilizzando la nostra precedente utilità "createContainer".
    final container = createContainer(
      // Possiamo specificare una lista di provider da emulare:
      overrides: [
        // In questo caso, stiamo imitando "exampleProvider".
        exampleProvider.overrideWith((ref) {
          // Questa funzione è la tipica funzione di inizializzazione di un provider.
          // Qui è dove normalmente chiamaresti "ref.watch" e restituiresti lo stato iniziale.

          // Sostituiamo il valore di default "Hello world" con un valore custom.
          // Infine, quando interagiremo con `exampleProvider`, ci ritornerà questo valore.
          return 'Hello from tests';
        }),
      ],
    );

    // Possiamo anche fare lo stesso nei test di widget usando ProviderScope:
    await tester.pumpWidget(
      ProviderScope(
        // I ProviderScope hanno lo stesso esatto parametro "overrides"
        overrides: [
          // Uguale a prima
          exampleProvider.overrideWith((ref) => 'Hello from tests'),
        ],
        child: const YourWidgetYouWantToTest(),
      ),
    );
    /* SNIPPET END */
  });
}
