import 'package:flutter/widgets.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

/// A read-only description of a todo-item
@immutable
class Todo {
  const Todo({
    required this.description,
    required this.id,
    this.completed = false,
  });

  factory Todo.fromJson(Map<String, dynamic> data) {
    return Todo(
      id: data['id'] as String,
      description: data['description'] as String,
      completed: data['completed'] as bool,
    );
  }

  final String id;
  final String description;
  final bool completed;

  Map<String, Object?> toJson() => {
    'id': id,
    'description': description,
    'completed': completed,
  };

  @override
  String toString() {
    return 'Todo(description: $description, completed: $completed)';
  }
}

/// An object that controls a list of [Todo].

class RestorableTodoList extends RestorableValue<List<Todo>> {
  RestorableTodoList(this._defaultValue);

  final List<Todo> _defaultValue;

  @override
  List<Todo> createDefaultValue() => _defaultValue;

  @override
  void didUpdateValue(List<Todo>? oldValue) {
    notifyListeners();
  }

  @override
  List<Todo> fromPrimitives(Object? data) {
    return (data! as List).cast<Map>().map((e) => Todo.fromJson(e.cast<String, dynamic>())).toList();
  }

  @override
  Object? toPrimitives() {
    return value.map((e) => e.toJson()).toList();
  }

  void add(String description) {
    value = [
      ...value,
      Todo(
        id: _uuid.v4(),
        description: description,
      ),
    ];
  }

  void toggle(String id) {
    value = [
      for (final todo in value)
        if (todo.id == id)
          Todo(
            id: todo.id,
            completed: !todo.completed,
            description: todo.description,
          )
        else
          todo,
    ];
  }

  void edit({required String id, required String description}) {
    value = [
      for (final todo in value)
        if (todo.id == id)
          Todo(
            id: todo.id,
            completed: todo.completed,
            description: description,
          )
        else
          todo,
    ];
  }

  void remove(Todo target) {
    value = value.where((todo) => todo.id != target.id).toList();
  }
}
