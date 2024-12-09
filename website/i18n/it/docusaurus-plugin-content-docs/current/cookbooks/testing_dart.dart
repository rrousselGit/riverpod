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
        // Sovrascrive il comportamento di repositoryProvider per restituire
        // FakeRepository al posto di Repository.
        /* highlight-start */
        repositoryProvider.overrideWithValue(FakeRepository()),
        /* highlight-end */
        // Non dobbiamo sovrascrivere `todoListProvider`,
        // utilizzerà automaticamente il repositoryProvider sovrascritto
      ],
    );

    // The first read if the loading state
    expect(
      container.read(todoListProvider),
      const AsyncValue<List<Todo>>.loading(),
    );

    /// Wait for the request to finish
    await container.read(todoListProvider.future);

    // Exposes the data fetched
    expect(container.read(todoListProvider).value, [
      isA<Todo>()
          .having((s) => s.id, 'id', '42')
          .having((s) => s.label, 'label', 'Hello world')
          .having((s) => s.completed, 'completed', false),
    ]);
  });

/* SNIPPET END */
}
