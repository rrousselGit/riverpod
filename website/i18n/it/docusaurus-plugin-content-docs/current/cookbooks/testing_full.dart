
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

// We expose our instance of Repository in a provider
final repositoryProvider = Provider((ref) => Repository());

/// The list of todos. Here, we are simply fetching them from the server using
/// [Repository] and doing nothing else.
final todoListProvider = FutureProvider((ref) async {
  // Obtains the Repository instance
  final repository = ref.read(repositoryProvider);

  // Fetch the todos and expose them to the UI.
  return repository.fetchTodos();
});

/// A mocked implementation of Repository that returns a pre-defined list of todos
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
          repositoryProvider.overrideWithValue(FakeRepository())
        ],
        // Our application, which will read from todoListProvider to display the todo-list.
        // You may extract this into a MyApp widget
        child: MaterialApp(
          home: Scaffold(
            body: Consumer(builder: (context, ref, _) {
              final todos = ref.watch(todoListProvider);
              // The list of todos is loading or in error
              if (todos.asData == null) {
                return const CircularProgressIndicator();
              }
              return ListView(
                children: [
                  for (final todo in todos.asData!.value) TodoItem(todo: todo)
                ],
              );
            }),
          ),
        ),
      ),
    );

    // The first frame is a loading state.
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Re-render. TodoListProvider should have finished fetching the todos by now
    await tester.pump();

    // No longer loading
    expect(find.byType(CircularProgressIndicator), findsNothing);

    // Rendered one TodoItem with the data returned by FakeRepository
    expect(tester.widgetList(find.byType(TodoItem)), [
      isA<TodoItem>()
          .having((s) => s.todo.id, 'todo.id', '42')
          .having((s) => s.todo.label, 'todo.label', 'Hello world')
          .having((s) => s.todo.completed, 'todo.completed', false),
    ]);
  });
}