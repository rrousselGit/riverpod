import 'package:hooks_riverpod/hooks_riverpod.dart';

class Todo {}

/* SNIPPET START */

class Repository {
  Future<List<Todo>> fetchTodos() async => [];
}

// Nous exposons notre instance de référentiel dans un provider
final repositoryProvider = Provider((ref) => Repository());

/// La liste des todos. Ici, nous les récupérons simplement sur le serveur en utilisant 
/// [Repository] et ne faisons rien d'autre.
final todoListProvider = FutureProvider((ref) async {
  // Obtenir une l'instance Repository
  final repository = ref.watch(repositoryProvider);

  // Récupérer les todos et les exposer à l'interface utilisateur.
  return repository.fetchTodos();
});
