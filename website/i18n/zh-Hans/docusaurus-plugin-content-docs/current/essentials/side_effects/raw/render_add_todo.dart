import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'rest_add_todo.dart';
import 'todo_list_notifier.dart' show Todo;

void main() {
  runApp(
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: Example());
  }
}

/* SNIPPET START */
class Example extends ConsumerStatefulWidget {
  const Example({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ExampleState();
}

class _ExampleState extends ConsumerState<Example> {
  // 待处理的 addTodo 操作。如果没有待处理的，则为 null。
  Future<void>? _pendingAddTodo;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // 我们监听待处理的操作，以相应地更新 UI。
      future: _pendingAddTodo,
      builder: (context, snapshot) {
        // 计算是否存在错误状态。
        // 检查 connectionState 用于在重试操作时进行处理。
        final isErrored = snapshot.hasError &&
            snapshot.connectionState != ConnectionState.waiting;

        return Row(
          children: [
            ElevatedButton(
              style: ButtonStyle(
                // 如果出现错误，我们会将该按钮显示为红色
                backgroundColor: WidgetStatePropertyAll(
                  isErrored ? Colors.red : null,
                ),
              ),
              onPressed: () {
                // 我们将 addTodo 返回的 future 保存在变量中
                final future = ref
                    .read(todoListProvider.notifier)
                    .addTodo(Todo(description: 'This is a new todo'));

                // 我们将这个 future 存储在本地的状态中
                setState(() {
                  _pendingAddTodo = future;
                });
              },
              child: const Text('Add todo'),
            ),
            // 操作正在等待，让我们显示一个进度指示器
            if (snapshot.connectionState == ConnectionState.waiting) ...[
              const SizedBox(width: 8),
              const CircularProgressIndicator(),
            ]
          ],
        );
      },
    );
  }
} /* SNIPPET END */
