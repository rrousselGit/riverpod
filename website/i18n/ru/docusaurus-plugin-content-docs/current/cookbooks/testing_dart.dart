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
      // Переопределяем поведение repositoryProvider, чтобы он
      // возвращал FakeRepository вместо Repository.
      /* highlight-start */
      repositoryProvider.overrideWithValue(FakeRepository()),
      /* highlight-end */
      // Нам не нужно переопределять `todoListProvider`.
      // Он автоматически будет использовать
      // переопределенный repositoryProvider
    ],
  );

  // Первое получение значения
  // Проверка: является ли состояние состоянием загрузки
  expect(
    container.read(todoListProvider),
    const AsyncValue<List<Todo>>.loading(),
  );

  // Ждем окончания запроса
  await container.read(todoListProvider.future);

  // Читаем полученные данные
  expect(container.read(todoListProvider).value, [
    isA<Todo>()
        .having((s) => s.id, 'id', '42')
        .having((s) => s.label, 'label', 'Hello world')
        .having((s) => s.completed, 'completed', false),
  ]);
});

/* SNIPPET END */
}
