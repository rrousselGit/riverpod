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

// Wir veröffentlichen unser Repository in einem Provider
final repositoryProvider = Provider((ref) => Repository());

/// Die Liste der Todos. Hier holen wir sie einfach mit dem
/// [Repository] vom Server ab und tun nichts weiter.
final todoListProvider = FutureProvider((ref) async {
  // Erhält die Repository Instanz
  final repository = ref.read(repositoryProvider);

  // Holen Sie die ToDos ab und stellen Sie sie der Benutzeroberfläche zur Verfügung.
  return repository.fetchTodos();
});

/// Eine mocked Implementierung von Repository, die eine vordefinierte Liste
/// von ToDos zurückgibt
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
        overrides: [repositoryProvider.overrideWithValue(FakeRepository())],
        // Unsere Anwendung, die von todoListProvider lesen wird, um die Todo-Liste anzuzeigen.
        // Sie können dies in ein MyApp-Widget extrahieren
        child: MaterialApp(
          home: Scaffold(
            body: Consumer(builder: (context, ref, _) {
              final todos = ref.watch(todoListProvider);
              // Die ToDo-Liste wird gerade geladen oder ist fehlerhaft
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

    // Der erste Frame ist ein Ladezustand.
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Neu gerendert. TodoListProvider sollte jetzt die ToDo's abgerufen haben
    await tester.pump();

    // Nicht mehr laden
    expect(find.byType(CircularProgressIndicator), findsNothing);

    // Ein TodoItem mit den von FakeRepository zurückgegebenen Daten gerendert
    expect(tester.widgetList(find.byType(TodoItem)), [
      isA<TodoItem>()
          .having((s) => s.todo.id, 'todo.id', '42')
          .having((s) => s.todo.label, 'todo.label', 'Hello world')
          .having((s) => s.todo.completed, 'todo.completed', false),
    ]);
  });
}
