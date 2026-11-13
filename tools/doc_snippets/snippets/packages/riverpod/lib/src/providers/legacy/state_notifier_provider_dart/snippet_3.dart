// GENERATED from packages/riverpod/lib/src/providers/legacy/state_notifier_provider.dart by scripts/snippets.sh.
// Do not modify by hand: edit the snippet instead.

import 'package:riverpod/riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:material_ui/material_ui.dart';

class Todo {
  Todo({required this.id, required this.description, this.completed = false});

  final String id;
  final String description;
  final bool completed;

  Todo copyWith({bool? completed}) => Todo(
    id: id,
    description: description,
    completed: completed ?? this.completed,
  );
}

class Counter extends StateNotifier<int> {
  Counter() : super(0);

  void increment() => state++;
}

late WidgetRef ref;
final stateNotifierProvider = StateNotifierProvider<Counter, int>(
  (ref) => Counter(),
);

class TodosNotifier extends StateNotifier<List<Todo>> {
  TodosNotifier() : super([]);

  void add(Todo todo) {
    state = [...state, todo];
  }

  void remove(String todoId) {
    state = [
      for (final todo in state)
        if (todo.id != todoId) todo,
    ];
  }

  void toggle(String todoId) {
    state = [
      for (final todo in state)
        if (todo.id == todoId) todo.copyWith(completed: !todo.completed),
    ];
  }
}

final todosProvider = StateNotifierProvider<TodosNotifier, List<Todo>>(
  (ref) => TodosNotifier(),
);

Widget build(BuildContext context, WidgetRef ref) {
  // rebuild the widget when the todo list changes
  List<Todo> todos = ref.watch(todosProvider);

  return ListView(
    children: [
      for (final todo in todos)
        CheckboxListTile(
          value: todo.completed,
          // When tapping on the todo, change its completed status
          onChanged: (value) =>
              ref.read(todosProvider.notifier).toggle(todo.id),
          title: Text(todo.description),
        ),
    ],
  );
}
