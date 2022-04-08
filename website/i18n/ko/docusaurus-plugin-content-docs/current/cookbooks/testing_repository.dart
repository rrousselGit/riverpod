import 'package:hooks_riverpod/hooks_riverpod.dart';

class Todo {}

/* SNIPPET START */

class Repository {
  Future<List<Todo>> fetchTodos() async => [];
}

// 프로바이더안에 레포지토리의 인스턴스를 노출합니다.
final repositoryProvider = Provider((ref) => Repository());

/// Todo의 목록
/// 여기 [Repository]를 사용하여 서버로부터 값을 가져오고 있습니다.
final todoListProvider = FutureProvider((ref) async {
  // Repository 인스턴스를 생성합니다.
  final repository = ref.watch(repositoryProvider);

  // Todo 목록을 취득하고 UI에 노출시킵니다.
  return repository.fetchTodos();
});
