import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
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
class Example extends HookConsumerWidget {
  const Example({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // pending중인 addTodo 작업입니다. 또는 pending중인 작업이 없으면 null입니다.
    final pendingAddTodo = useState<Future<void>?>(null);
    // pending인 작업을 수신하여 그에 따라 UI를 업데이트합니다.
    final snapshot = useFuture(pendingAddTodo.value);

    // 오류 상태가 있는지 여부를 계산합니다.
    // 연결 상태(connectionState) 확인은 작업이 다시 시도될 때 처리하기 위해 여기에 있습니다.
    final isErrored = snapshot.hasError &&
        snapshot.connectionState != ConnectionState.waiting;

    return Row(
      children: [
        ElevatedButton(
          style: ButtonStyle(
            // 오류가 있는 경우 버튼을 빨간색으로 표시합니다.
            backgroundColor: MaterialStateProperty.all(
              isErrored ? Colors.red : null,
            ),
          ),
          onPressed: () async {
            // addTodo가 반환한 future를 변수에 보관합니다.
            final future = ref
                .read(todoListProvider.notifier)
                .addTodo(Todo(description: 'This is a new todo'));

            // 해당 미래를 로컬 상태에 저장합니다.
            pendingAddTodo.value = future;
          },
          child: const Text('Add todo'),
        ),
        // 작업이 pending중이므로 진행률 표시기(progress indicator)를 표시하겠습니다.
        if (snapshot.connectionState == ConnectionState.waiting) ...[
          const SizedBox(width: 8),
          const CircularProgressIndicator(),
        ],
      ],
    );
  }
}
/* SNIPPET END */
