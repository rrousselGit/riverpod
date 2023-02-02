import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/* SNIPPET START */

// StateNotifier 的状态必须是不可变的。
// 我们可使用 Dart 的 @immutable 注解或是 Freezed 包来帮助我们实施这一点。
@immutable
class Todo {
  const Todo({required this.id, required this.description, required this.completed});

  // 全部类内的属性必须是 `final` 的。
  final String id;
  final String description;
  final bool completed;

  // 既然 Todo 类是不可变的，我们就实施一个允许复制拥有稍微不一样内容的 Todo 的方法。
  Todo copyWith({String? id, String? description, bool? completed}) {
    return Todo(
      id: id ?? this.id,
      description: description ?? this.description,
      completed: completed ?? this.completed,
    );
  }
}

// 此类是我们将传递给 StateNotifierProvider 的 StateNotifier 类。
// 它不应该在其 “state” 属性之外提供状态，也就是无公共的 getter或属性。
// 此类的公共方法将允许界面使用去修改状态。
class TodosNotifier extends StateNotifier<List<Todo>> {
  // 我们将任务列表初始化为空列表
  TodosNotifier() : super([]);

  // 提供给界面使用的添加任务的方法
  void addTodo(Todo todo) {
    // 既然我们的状态是不可变的，我们就无法使用 `state.add(todo)` 这个方式去添加任务。
    // 反而，我们应该创建一个包含了之前的任务列表和新任务的新列表。
    // 在此使用 Dart 的展开操作符是非常有用的。
    state = [...state, todo];
    // 无需调用 "notifyListeners" 或类似的方法。调用 "state =" 将会在必要时自动重建界面。
  }

  // 提供给界面使用的删除任务的方法
  void removeTodo(String todoId) {
    // 同样的，我们的状态是不可变的。所以我们必须创建一个新的列表而不是修改现有的列表。
    state = [
      for (final todo in state)
        if (todo.id != todoId) todo,
    ];
  }

  // 提供给界面使用的标记任务完成的方法
  void toggle(String todoId) {
    state = [
      for (final todo in state)
        // 我们只标记匹配的任务为完成
        if (todo.id == todoId)
          // 我们的状态是不可变的，所以我们必须创建一个新的任务。我们可使用之前所实施的 `copyWith` 方法来帮助我们创建。
          todo.copyWith(completed: !todo.completed)
        else
          // 其它任务不会被修改
          todo,
    ];
  }
}

// 最后，我们使用 StateNotifierProvider 来允许界面与我们的 TodosNotifier 类交互。
final todosProvider = StateNotifierProvider<TodosNotifier, List<Todo>>((ref) {
  return TodosNotifier();
});
