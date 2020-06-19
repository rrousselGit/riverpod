import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:uuid/uuid.dart';

var _uuid = Uuid();

@freezed
class Todo {
  Todo({
    this.description,
    this.completed = false,
    String id,
  }) : id = id ?? _uuid.v4();

  final String id;
  final String description;
  final bool completed;

  @override
  String toString() {
    return 'Todo(description: $description, completed: $completed)';
  }
}

class TodoList extends StateNotifier<List<Todo>> {
  TodoList()
      : super([
          Todo(description: 'hi'),
          Todo(description: 'hello'),
          Todo(description: 'bonjour'),
        ]);

  void add(String description) {
    state = [
      ...state,
      Todo(description: description),
    ];
  }

  void toggle(String id) {
    state = [
      for (final todo in state)
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

  void edit({@required String id, @required String description}) {
    state = [
      for (final todo in state)
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
    state = state.where((todo) => todo.id != target.id).toList();
  }
}
