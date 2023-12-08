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

// Nous exposons notre instance de référentiel dans un provider
final repositoryProvider = Provider((ref) => Repository());

/// La liste des todos. Ici, nous les récupérons simplement sur
/// le serveur en utilisant [Repository] et ne faisons rien d'autre.
final todoListProvider = FutureProvider((ref) async {
  // Obtention de l'instance Repository
  final repository = ref.read(repositoryProvider);

  // Récupérer les todos et les exposer à l'interface utilisateur.
  return repository.fetchTodos();
});

/// Une implémentation simulée de Repository qui renvoie une liste prédéfinie de todos.
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
        // Notre application, qui lira le todoListProvider pour afficher la liste des todos à faire.
        // Vous pouvez l'extraire dans un widget MyApp
        child: MaterialApp(
          home: Scaffold(
            body: Consumer(builder: (context, ref, _) {
              final todos = ref.watch(todoListProvider);
              // La liste des todos est en cours de chargement ou en erreur
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

    // Le premier frame est un état de chargement.
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Re-render. TodoListProvider devrait avoir fini de récupérer les todos maintenant
    await tester.pump();

    // Plus de chargement
    expect(find.byType(CircularProgressIndicator), findsNothing);

    // Rendu d'un TodoItem avec les données renvoyées par FakeRepository
    expect(tester.widgetList(find.byType(TodoItem)), [
      isA<TodoItem>()
          .having((s) => s.todo.id, 'todo.id', '42')
          .having((s) => s.todo.label, 'todo.label', 'Hello world')
          .having((s) => s.todo.completed, 'todo.completed', false),
    ]);
  });
}
