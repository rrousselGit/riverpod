import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class Repository {
  Future<List<Todo>> fetchTodos() async => [];
}

class Todo {
  Todo({
    required this.id,
    required this.label,
    required this.completed,
  });

  final String id;
  final String label;
  final bool completed;
}

// Храним экземпляр Repository в провайдере
final repositoryProvider = Provider((ref) => Repository());

/// Список задач. Мы просто получаем задачи с сервера,
/// используя [Repository].
final todoListProvider = FutureProvider((ref) async {
  // Получение экземпляра Repository
  final repository = ref.read(repositoryProvider);

  // Получение задач и передача их в UI.
  return repository.fetchTodos();
});

/// Mock реализация Repository, которая возвращает предопределенный список задач
class FakeRepository implements Repository {
  @override
  Future<List<Todo>> fetchTodos() async {
    return [
      Todo(id: '42', label: 'Hello world', completed: false),
    ];
  }
}

class TodoItem extends StatelessWidget {
  const TodoItem({super.key, required this.todo});
  final Todo todo;
  @override
  Widget build(BuildContext context) {
    return Text(todo.label);
  }
}

void main() {
  testWidgets('override repositoryProvider', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          repositoryProvider.overrideWithValue(FakeRepository()),
        ],
        // Наше приложение, которые читает значение todoListProvider
        // для отображение списка задач.
        // Вы можете вынести это в отдельный MyApp виджет
        child: MaterialApp(
          home: Scaffold(
            body: Consumer(
              builder: (context, ref, _) {
                final todos = ref.watch(todoListProvider);
                // Список задач загружается, либо случилась ошибка
                if (todos.asData == null) {
                  return const CircularProgressIndicator();
                }
                return ListView(
                  children: [
                    for (final todo in todos.asData!.value)
                      TodoItem(todo: todo),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );

    // Первый кадр - состояние загрузки
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Перерисовка. TodoListProvider уже должен получить задачи
    await tester.pump();

    // Загрузка закончилась
    expect(find.byType(CircularProgressIndicator), findsNothing);

    // Переотрисовка одного TodoItem с данными, пришедшими из FakeRepository
    expect(tester.widgetList(find.byType(TodoItem)), [
      isA<TodoItem>()
          .having((s) => s.todo.id, 'todo.id', '42')
          .having((s) => s.todo.label, 'todo.label', 'Hello world')
          .having((s) => s.todo.completed, 'todo.completed', false),
    ]);
  });
}
