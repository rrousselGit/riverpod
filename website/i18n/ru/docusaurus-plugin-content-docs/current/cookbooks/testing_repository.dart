import 'package:hooks_riverpod/hooks_riverpod.dart';

class Todo {}

/* SNIPPET START */

class Repository {
  Future<List<Todo>> fetchTodos() async => [];
}

// Храним экземпляр Repository в провайдере
final repositoryProvider = Provider((ref) => Repository());

/// Список задач. Мы просто получаем задачи с сервера,
/// используя [Repository].
final todoListProvider = FutureProvider((ref) async {
  // Получение экземпляра Repository
  final repository = ref.watch(repositoryProvider);

  // Получение задач и передача их в UI.
  return repository.fetchTodos();
});
