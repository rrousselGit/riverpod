import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/legacy.dart';

/* SNIPPET START */

// Состояние StateNotifier должно быть неизменяемым.
// Для реализации этого мы можем воспользоваться пакетами как Freezed
@immutable
class Todo {
  const Todo({
    required this.id,
    required this.description,
    required this.completed,
  });

  // В классе все поля должны быть `final`.
  final String id;
  final String description;
  final bool completed;

  // Т. к. Todo неизменяемый, создадим метод клонирования
  // с возможными изменениями
  Todo copyWith({String? id, String? description, bool? completed}) {
    return Todo(
      id: id ?? this.id,
      description: description ?? this.description,
      completed: completed ?? this.completed,
    );
  }
}

// StateNotifier, который будет передан в наш StateNotifierProvider.
// Этот класс не должен предоставлять никаких способов получения своего состояния,
// хранящегося в поле "state",
// т.е. никаких публичных геттеров/полей не должно быть!
// Публичные методы описывают то, как UI может изменять состояние.
class TodosNotifier extends StateNotifier<List<Todo>> {
  // Инициализируем список задач пустым списком
  TodosNotifier() : super([]);

  // Добавление задач
  void addTodo(Todo todo) {
    // Т. к. наше состояние неизменяемо, нельзя делать подобное: `state.add(todo)`.
    // Вместо этого мы должны создать новый список задач, который будет
    // содержать предыдущие задачи и новую.
    // Тут нам поможет spread оператор
    state = [...state, todo];
    // Не нужно вызывать "notifyListeners" или что-то подобное.
    // Вызов "state =" автоматически перестраивает UI, когда это необходимо.
  }

  // Удаление задач
  void removeTodo(String todoId) {
    // Не забываем, что наше состояние неизменяемо.
    // Так что мы создаем новый список, а не изменяем существующий.
    state = [
      for (final todo in state)
        if (todo.id != todoId) todo,
    ];
  }

  // Изменение статуса задачи: выполнена/не выполнена
  void toggle(String todoId) {
    state = [
      for (final todo in state)
        // Изменяем статус только той задачи,
        // у которой id равен todoId
        if (todo.id == todoId)
          // Еще раз вспомним, что наше состояние неизменяемо. Так что
          // нам необходимо создавать копию списка задач.
          // Воспользуемся методом `copyWith`, который мы реализовали ранее
          todo.copyWith(completed: !todo.completed)
        else
          // Другие задачи не изменяем
          todo,
    ];
  }
}

// Используем StateNotifierProvider для взаимодействия с TodosNotifier
final todosProvider = StateNotifierProvider<TodosNotifier, List<Todo>>((ref) {
  return TodosNotifier();
});
