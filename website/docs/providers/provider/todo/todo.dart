// ignore_for_file: avoid_positional_boolean_parameters

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

/* SNIPPET START */

class Todo {
  Todo(this.description, this.isCompleted);
  final bool isCompleted;
  final String description;
}

@riverpod
class Todos extends _$Todos {
  @override
  List<Todo> build() {
    return [];
  }

  void addTodo(Todo todo) {
    state = [...state, todo];
  }
}
