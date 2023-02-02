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

// 我们在 provider 中提供 Repository 实例
final repositoryProvider = Provider((ref) => Repository());

/// 我们使用 [Repository] 从服务器获取任务列表（todoList）
final todoListProvider = FutureProvider((ref) async {
  // 获取 Repository 实例
  final repository = ref.read(repositoryProvider);

  // 从服务器获取任务列表（todoList）并提供给 UI
  return repository.fetchTodos();
});

/// 一个返回预定义任务列表（todoList）的 Repository 模拟实施
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
        // 我们的应用程序... 它将从 todoListProvider 中读取以显示任务列表。
        // 你可以将它提取到一个 MyApp 组件中
        child: MaterialApp(
          home: Scaffold(
            body: Consumer(builder: (context, ref, _) {
              final todos = ref.watch(todoListProvider);
              // 任务列表状态为加载中或错误
              if (todos.asData == null) {
                return const CircularProgressIndicator();
              }
              return ListView(
                children: [for (final todo in todos.asData!.value) TodoItem(todo: todo)],
              );
            }),
          ),
        ),
      ),
    );

    // 第一个帧是加载状态
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // 重新渲染。TodoListProvider 现在应该已经完成了获取任务列表的操作
    await tester.pump();

    // 加载完成
    expect(find.byType(CircularProgressIndicator), findsNothing);

    // 渲染一个数据由 FakeRepository 返回的 TodoItem
    expect(tester.widgetList(find.byType(TodoItem)), [
      isA<TodoItem>()
          .having((s) => s.todo.id, 'todo.id', '42')
          .having((s) => s.todo.label, 'todo.label', 'Hello world')
          .having((s) => s.todo.completed, 'todo.completed', false),
    ]);
  });
}
