import 'package:hooks_riverpod/hooks_riverpod.dart';

class Todo {}

/* SNIPPET START */

class Repository {
  Future<List<Todo>> fetchTodos() async => [];
}

// We expose our instance of Repository in a provider
final repositoryProvider = Provider((ref) => Repository());

/// The list of todos. Here, we are simply fetching them from the server using
/// [Repository] and doing nothing else.
final todoListProvider = FutureProvider((ref) async {
  // Obtains the Repository instance
  final repository = ref.watch(repositoryProvider);

  // Fetch the todos and expose them to the UI.
  return repository.fetchTodos();
});
