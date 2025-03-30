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
        // repositoryProvider의 행위를 오버라이드하여
        // Repository 대신 FakeRepository를 반환합니다.
        /* highlight-start */
        repositoryProvider.overrideWithValue(FakeRepository()),
        /* highlight-end */
        // 오버라이드된 repositoryProvider를 자동적으로 사용하기 때문에
        // `todoListProvider`를 override하지 않아도 됩니다.
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
