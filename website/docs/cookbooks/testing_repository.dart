import 'package:hooks_riverpod/hooks_riverpod.dart';

class Todo {}

/* SNIPPET START */

class Repository {
  Future<List<Todo>> fetchTodos() async => [];
}

// Wir veröffentlichen unser Repository in einem Provider
final repositoryProvider = Provider((ref) => Repository());

/// Die Liste der Todos. Hier holen wir sie einfach mit dem
/// [Repository] vom Server ab und tun nichts weiter.
final todoListProvider = FutureProvider((ref) async {
  // Erhält die Repository Instanz
  final repository = ref.watch(repositoryProvider);

  // Holt sich die ToDos und stellen sie der Benutzeroberfläche zur Verfügung.
  return repository.fetchTodos();
});
