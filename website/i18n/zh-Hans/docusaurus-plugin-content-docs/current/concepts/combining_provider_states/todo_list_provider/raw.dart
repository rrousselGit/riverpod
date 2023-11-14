// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Todo {
  const Todo({
    required this.id,
    required this.description,
    required this.completed,
  });

  // All properties should be `final` on our class.
  final String id;
  final String description;
  final bool completed;

  // Since Todo is immutable, we implement a method that allows cloning the
  // Todo with slightly different content.
  Todo copyWith({String? id, String? description, bool? completed}) {
    return Todo(
      id: id ?? this.id,
      description: description ?? this.description,
      completed: completed ?? this.completed,
    );
  }
}

/* SNIPPET START */

class TodoList extends Notifier<List<Todo>> {
  @override
  List<Todo> build() {
    return [];
  }
}

final todoListProvider = NotifierProvider<TodoList, List<Todo>>(TodoList.new);
