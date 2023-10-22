import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/* SNIPPET START */

// 最好使用不可变状态。
// 我们还可以使用像 freezed 这样的package来帮助实现不可变。
@immutable
class Todo {
  const Todo({
    required this.id,
    required this.description,
    required this.completed,
  });

  // 在我们的类中所有的属性都应该是 `final` 的。
  final String id;
  final String description;
  final bool completed;

  // 由于Todo是不可变的，我们实现了一种方法允许克隆内容略有不同的Todo。
  Todo copyWith({String? id, String? description, bool? completed}) {
    return Todo(
      id: id ?? this.id,
      description: description ?? this.description,
      completed: completed ?? this.completed,
    );
  }
}

// Notifier类将会被传递给我们的NotifierProvider。
// 这个类不应该在其“state”属性之外暴露状态，也就是说没有公共的获取属性的方法！
// 这个类上的公共方法将允许UI修改它的状态。
class TodosNotifier extends Notifier<List<Todo>> {
  // 我们将待办清单的列表初始化
  @override
  List<Todo> build() {
    return [];
  }

  // 让我们添加UI添加待办清单
  void addTodo(Todo todo) {
    // 由于状态是不可变的，因此不允许执行 `state.add(todo)`。
    // 相反，我们应该创建一个包含以前的项目和新的项目的待办清单列表。
    // 在这里使用Dart的扩展运算符很有用！
    state = [...state, todo];
    // 不需要调用“notifyListeners”或其他类似的方法。
    // 直接 “state =” 就能自动在需要时重新构建UI。
  }

  // 让我们允许删除待办清单
  void removeTodo(String todoId) {
    // 同样我们的状态是不可变的。
    // 所以我们创建了一个新的列表，而不是改变现存的列表。
    state = [
      for (final todo in state)
        if (todo.id != todoId) todo,
    ];
  }

  // 让我们把待办清单标记为已完成
  void toggle(String todoId) {
    state = [
      for (final todo in state)
        // 我们只标记完成的待办清单
        if (todo.id == todoId)
          // 再一次因为我们的状态是不可变的，所以我们需要创建待办清单的副本，
          // 我们使用之前实现的copyWith方法来实现。
          todo.copyWith(completed: !todo.completed)
        else
          // 其他未修改的待办清单
          todo,
    ];
  }
}

// 最后，我们使用NotifierProvider来允许UI与我们的TodosNotifier类交互。
final todosProvider = NotifierProvider<TodosNotifier, List<Todo>>(() {
  return TodosNotifier();
});
