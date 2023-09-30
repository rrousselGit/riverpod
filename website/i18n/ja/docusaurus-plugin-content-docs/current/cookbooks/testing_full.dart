
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

// Repository インスタンスを公開するプロバイダ
final repositoryProvider = Provider((ref) => Repository());

/// Todo リストを公開するプロバイダ
/// [Repository] を使用して値をサーバから取得
final todoListProvider = FutureProvider((ref) async {
  // Repository インスタンスを取得する
  final repository = ref.read(repositoryProvider);

  // Todo リストを取得して、プロバイダを監視する UI 側に値を公開する
  return repository.fetchTodos();
});

/// あらかじめ定義した Todo リストを返す Repository のフェイク実装
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
          repositoryProvider.overrideWithValue(FakeRepository())
        ],
        // todoListProvider の値を監視して Todo リストを表示するアプリ
        // 以下を抽出して MyApp ウィジェットとしても可
        child: MaterialApp(
          home: Scaffold(
            body: Consumer(builder: (context, ref, _) {
              final todos = ref.watch(todoListProvider);
              // Todo リストのステートが loading か error の場合
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

    // 最初のフレームのステートが loading になっているか確認
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // 再描画。このあたりで TodoListProvider は 値の取得が終わっているはず
    await tester.pump();

    // loading 以外のステートになっているか確認
    expect(find.byType(CircularProgressIndicator), findsNothing);

    // FakeRepository が公開した値から TodoItem が一つ描画されているか確認
    expect(tester.widgetList(find.byType(TodoItem)), [
      isA<TodoItem>()
          .having((s) => s.todo.id, 'todo.id', '42')
          .having((s) => s.todo.label, 'todo.label', 'Hello world')
          .having((s) => s.todo.completed, 'todo.completed', false),
    ]);
  });
}