import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeRepository {}

final repositoryProvider = Provider((ref) => FakeRepository());

abstract class Todo {
  String get id;
  String get label;
  bool get completed;
}

final todoListProvider = FutureProvider<List<Todo>>((ref) => []);

void main() {
/* SNIPPET START */

  test('override repositoryProvider', () async {
    final container = ProviderContainer(
      overrides: [
        // Überschreiben Sie das Verhalten von repositoryProvider, um
        // FakeRepository anstelle von Repository zurückzugeben.
        /* highlight-start */
        repositoryProvider.overrideWithValue(FakeRepository())
        /* highlight-end */
        // Wir müssen den `todoListProvider` nicht überschreiben, er wird
        // automatisch den überschriebenen repositoryProvider verwenden
      ],
    );

    // Das erste Lesen, wenn der Ladezustand
    expect(
      container.read(todoListProvider),
      const AsyncValue<List<Todo>>.loading(),
    );

    /// Wartet bis die Anfrage beendet ist
    await container.read(todoListProvider.future);

    // Zeigt die abgerufenen Daten an
    expect(container.read(todoListProvider).value, [
      isA<Todo>()
          .having((s) => s.id, 'id', '42')
          .having((s) => s.label, 'label', 'Hello world')
          .having((s) => s.completed, 'completed', false),
    ]);
  });

/* SNIPPET END */
}
