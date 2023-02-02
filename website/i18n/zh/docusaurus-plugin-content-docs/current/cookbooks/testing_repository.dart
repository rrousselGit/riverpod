import 'package:hooks_riverpod/hooks_riverpod.dart';

class Todo {}

/* SNIPPET START */

class Repository {
  Future<List<Todo>> fetchTodos() async => [];
}

// 我们在 provider 中提供 Repository 实例
final repositoryProvider = Provider((ref) => Repository());

/// 我们使用 [Repository] 从服务器获取任务列表（todoList）
final todoListProvider = FutureProvider((ref) async {
  // 获取 Repository 实例
  final repository = ref.watch(repositoryProvider);

  // 从服务器获取任务列表（todoList）并提供给 UI
  return repository.fetchTodos();
});
