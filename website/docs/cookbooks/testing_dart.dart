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
      // Override the behavior of repositoryProvider to return
      // FakeRepository instead of Repository.
      /* highlight-start */
      repositoryProvider.overrideWithValue(FakeRepository())
      /* highlight-end */
      // We do not have to override `todoListProvider`, it will automatically
      // use the overridden repositoryProvider
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
