import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'todo.dart';

/* SNIPPET START */

final completedTodosProvider = Provider<List<Todo>>((ref) {
  // আমরা todosProvider থেকে সব টুডু ধারণ করব
  final todos = ref.watch(todosProvider);

  // আর আমরা শুধু completed টুডু রিটার্ন করব
  return todos.where((todo) => todo.isCompleted).toList();
});
