final todosProvider = StateProvider<List<Todo>>((ref) => []);
final filterProvider = StateProvider<Filter>((ref) => Filter.all);

final filteredTodosProvider = Provider<List<Todo>>((ref) {
  final todos = ref.watch(todosProvider.state);
  switch (ref.watch(filterProvider)) {
    case Filter.none:
      return todos;
    case Filter.completed:
      return todos.where((todo) => todo.completed).toList();
    case Filter.uncompleted:
      return todos.where((todo) => !todo.completed).toList();
  }
});
