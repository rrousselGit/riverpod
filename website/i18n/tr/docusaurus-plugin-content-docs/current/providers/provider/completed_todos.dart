import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'todo.dart';

/* SNIPPET START */

final completedTodosProvider = Provider<List<Todo>>((ref) {
  // Görevlerin (yapılacaklar) listesini `todosProvider`dan alıyoruz
  final todos = ref.watch(todosProvider);

  // Yalnızca tamamlanan "tümü"nü döndürürüz
  return todos.where((todo) => todo.isCompleted).toList();
});
