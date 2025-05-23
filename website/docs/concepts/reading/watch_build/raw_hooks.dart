// ignore_for_file: omit_local_variable_types

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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

class HomeView extends HookConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // You can use hooks inside a HookConsumerWidget
    final greeting = useState('Hello');

    // use ref to listen to a provider
    final counter = ref.watch(counterProvider);

    return Text('${greeting.value} $counter');
  }
}
