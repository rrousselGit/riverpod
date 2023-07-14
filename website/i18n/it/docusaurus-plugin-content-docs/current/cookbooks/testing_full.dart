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

// Esponiamo la nostra istanza di Repository in un provider
final repositoryProvider = Provider((ref) => Repository());

/// La lista dei todo. Qua stiamo semplicemente richiedendo i todo dal server
/// usando [Repository] e non facendo altro.
final todoListProvider = FutureProvider((ref) async {
  // Ottiene l'istanza di Repository
  final repository = ref.read(repositoryProvider);

  // Otteniamo i todo e li esponiamo alla UI.
  return repository.fetchTodos();
});

/// Un'implementazione simulata di Repository che restituisce una pre-definita
/// lista di todo.
class FakeRepository implements Repository {
  @override
  Future<List<Todo>> fetchTodos() async {
    return [
      Todo(id: '42', label: 'Hello world', completed: false),
    ];
  }
}

class TodoItem extends StatelessWidget {
  const TodoItem({Key? key, required this.todo}) : super(key: key);
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
        // La nostra applicazione che leggerà da todoListProvider per mostrare la lista dei todo
        // Puoi estrarre questo in un widget MyApp
        child: MaterialApp(
          home: Scaffold(
            body: Consumer(builder: (context, ref, _) {
              final todos = ref.watch(todoListProvider);
              // La lista dei todo è in caricamento o in errore
              if (todos.asData == null) {
                return const CircularProgressIndicator();
              }
              return ListView(
                children: [for (final todo in todos.asData!.value) TodoItem(todo: todo)],
              );
            }),
          ),
        ),
      ),
    );

    // Il primo frame è uno stato di caricamento (loading).
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Ri-renderizza. TodoListProvider dovrebbe aver finito di ottenere i todo in questo momento
    await tester.pump();

    // Fase di loading finita
    expect(find.byType(CircularProgressIndicator), findsNothing);

    // Renderizzato un TodoItem con il dato restituito da FakeRepository
    expect(tester.widgetList(find.byType(TodoItem)), [
      isA<TodoItem>()
          .having((s) => s.todo.id, 'todo.id', '42')
          .having((s) => s.todo.label, 'todo.label', 'Hello world')
          .having((s) => s.todo.completed, 'todo.completed', false),
    ]);
  });
}
