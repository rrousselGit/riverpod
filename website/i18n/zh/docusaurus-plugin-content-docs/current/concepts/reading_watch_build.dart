// ignore_for_file: omit_local_variable_types

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum FilterType {
  none,
  completed,
}

abstract class Todo {
  bool get isCompleted;
}

class TodoList extends StateNotifier<List<Todo>> {
  TodoList() : super([]);
}

/* SNIPPET START */

final counterProvider = StateProvider((ref) => 0);

// 把 StatelessWidget 改为 ConsumerWidget
class HomeView extends ConsumerWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  // 在 build 方法内添加一个 `ref` 参数
  Widget build(BuildContext context, WidgetRef ref) {
    // 并使用该 `ref` 监听 provider
    final counter = ref.watch(counterProvider);

    return Text('$counter');
  }
}
