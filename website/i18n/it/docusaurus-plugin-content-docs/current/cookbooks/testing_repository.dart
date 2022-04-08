import 'package:hooks_riverpod/hooks_riverpod.dart';

class Todo {}

/* SNIPPET START */

class Repository {
  Future<List<Todo>> fetchTodos() async => [];
}

// Esponiamo la nostra istanza di Repository in un provider
final repositoryProvider = Provider((ref) => Repository());

/// La lista dei todo. Qua stiamo semplicemente richiedendo i todo dal server
/// usando [Repository] e non facendo altro.
final todoListProvider = FutureProvider((ref) async {
  // Ottiene l'istanza di Repository
  final repository = ref.watch(repositoryProvider);

  // Otteniamo i todo e li esponiamo alla UI.
  return repository.fetchTodos();
});
