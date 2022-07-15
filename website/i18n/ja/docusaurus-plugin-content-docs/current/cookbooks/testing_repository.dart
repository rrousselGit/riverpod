import 'package:hooks_riverpod/hooks_riverpod.dart';

class Todo {}

/* SNIPPET START */

class Repository {
  Future<List<Todo>> fetchTodos() async => [];
}

// Repository インスタンスを公開するプロバイダ
final repositoryProvider = Provider((ref) => Repository());

/// Todo リストを公開するプロバイダ
/// [Repository] を使用して値をサーバから取得
final todoListProvider = FutureProvider((ref) async {
  // Repository インスタンスを取得する
  final repository = ref.watch(repositoryProvider);

  // Todo リストを取得して、プロバイダを監視する UI 側に値を公開する
  return repository.fetchTodos();
});
