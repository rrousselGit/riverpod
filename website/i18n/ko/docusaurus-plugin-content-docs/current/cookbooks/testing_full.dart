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

// Repository를 사용하는 프로바이더 인스턴스
final repositoryProvider = Provider((ref) => Repository());

/// 할일(Todo) 목록
/// [Repository]를 사용하여 서버로부터 값을 취득하는 FutureProvider 인스턴스
final todoListProvider = FutureProvider((ref) async {
  // Repository 인스턴스를 취득합니다.
  final repository = ref.read(repositoryProvider);

  // Todo 목록을 가져오고 이를 UI에 노출시킵니다.
  return repository.fetchTodos();
});

/// 레포지토리의 Mock 구현: 사전 정의된 할일 목록을 반환하는 역할
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
        // todoListProvider로부터 상태 값을 읽어 todo 목록을 표시하는 앱
        // MyApp 위젯으로도 가능.
        child: MaterialApp(
          home: Scaffold(
            body: Consumer(builder: (context, ref, _) {
              final todos = ref.watch(todoListProvider);
              // 할일 목록이 로딩 중이거나 에러가 발생했을 때의 대응
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

    // 처음 프레임 상태가 로딩중임을 확인.
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // 재 렌더링을 수행
    // (TodoListProvider가 할일 목록을 가져오기를 끝냈을 것이라 예상)
    await tester.pump();

    // CircularProgressIndicator을 찾아 loading 상태인지 확인 .
    expect(find.byType(CircularProgressIndicator), findsNothing);

    // FakeRepository가 반환한 값이 1개의 TodoItem으로 렌더링되었는지 확인.
    expect(tester.widgetList(find.byType(TodoItem)), [
      isA<TodoItem>()
          .having((s) => s.todo.id, 'todo.id', '42')
          .having((s) => s.todo.label, 'todo.label', 'Hello world')
          .having((s) => s.todo.completed, 'todo.completed', false),
    ]);
  });
}
