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
  TodoList(): super([]);
}

/* SNIPPET START */

final counterProvider = StateProvider((ref) => 0);

class HomeView extends ConsumerWidget {
  const HomeView({Key? key}): super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // use ref to listen to a provider
    final counter = ref.watch(counterProvider);

    return Text('$counter');
  }
}