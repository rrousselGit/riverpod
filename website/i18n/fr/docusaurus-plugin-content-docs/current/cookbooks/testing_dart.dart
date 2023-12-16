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
      // Surcharge le comportement de repositoryProvider pour qu'il renvoie 
      // FakeRepository au lieu de Repository.
      /* highlight-start */
      repositoryProvider.overrideWithValue(FakeRepository())
      /* highlight-end */
      // Il n'est pas nécessaire de surcharger `todoListProvider`, 
      // il utilisera automatiquement le repositoryProvider surchargé.
    ],
  );

  // La première lecture si l'état est en cours de chargement
  expect(
    container.read(todoListProvider),
    const AsyncValue<List<Todo>>.loading(),
  );

  /// Attendre la fin de la demande (la requete)
  await container.read(todoListProvider.future);

  // Expose les données recherchées
  expect(container.read(todoListProvider).value, [
    isA<Todo>()
        .having((s) => s.id, 'id', '42')
        .having((s) => s.label, 'label', 'Hello world')
        .having((s) => s.completed, 'completed', false),
  ]);
});

/* SNIPPET END */
}
