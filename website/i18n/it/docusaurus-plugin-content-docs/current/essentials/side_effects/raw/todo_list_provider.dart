import 'package:flutter_riverpod/flutter_riverpod.dart';

/* SNIPPET START */
class Todo {
  Todo({
    required this.description,
    this.completed = false,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      description: json['description'] as String,
      completed: json['completed'] as bool,
    );
  }

  final String description;
  final bool completed;
}

final todoListProvider = FutureProvider.autoDispose<List<Todo>>((ref) async {
  // Simula una richiesta di rete. Normalmente il risultato dovrebbe venire da una API reale
  return [
    Todo(description: 'Learn Flutter', completed: true),
    Todo(description: 'Learn Riverpod'),
  ];
});
