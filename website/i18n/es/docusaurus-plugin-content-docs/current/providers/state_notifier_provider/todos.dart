import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/* SNIPPET START */

// El estado de nuestro StateNotifier debe ser inmutable.
// También podríamos usar paquetes como Freezed para ayudar con la implementación.
@immutable
class Todo {
  const Todo({required this.id, required this.description, required this.completed});

  // Todas las propiedades deben ser `final` en nuestra clase.
  final String id;
  final String description;
  final bool completed;

  // Como `Todo` es inmutable, implementamos un método que permite clonar el 
  // `Todo` con un contenido ligeramente diferente.
  Todo copyWith({String? id, String? description, bool? completed}) {
    return Todo(
      id: id ?? this.id,
      description: description ?? this.description,
      completed: completed ?? this.completed,
    );
  }
}

// La clase StateNotifier que se pasará a nuestro StateNotifierProvider.
// Esta clase no debe exponer el estado fuera de su propiedad "estado", lo que significa 
// ¡sin getters/propiedades públicas!
// Los métodos públicos en esta clase serán los que permitirán
// que la interfaz de usuario modifique el estado.
class TodosNotifier extends StateNotifier<List<Todo>> {
  // Inicializamos la lista de `todos` como una lista vacía
  TodosNotifier(): super([]);

  // Permitamos que la interfaz de usuario agregue todos.
  void addTodo(Todo todo) {
    // Ya que nuestro estado es inmutable, no podemos hacer `state.add(todo)`. 
    // En su lugar, debemos crear una nueva lista de todos que contenga la anterior
    // elementos y el nuevo.
    // ¡Usar el spread operator de Dart aquí es útil!
    state = [...state, todo];
    // No es necesario llamar a "notifyListeners" o algo similar. Llamando a "state ="
    // reconstruirá automáticamente la interfaz de usuario cuando sea necesario.
  }

  // Permitamos eliminar `todos`
  void removeTodo(String todoId) {
    // Nuevamente, nuestro estado es inmutable. Así que estamos haciendo 
    // una nueva lista en lugar de cambiar la lista existente.
    state = [
      for (final todo in state)
        if (todo.id != todoId) todo,
    ];
  }

  // Marcamos una `todo` como completada
  void toggle(String todoId) {
    state = [
      for (final todo in state)
        // Estamos marcando solo el `todo` coincidente como completada
        if (todo.id == todoId)
          // Una vez más, dado que nuestro estado es inmutable, necesitamos hacer una copia 
          // del `todo`. Estamos usando nuestro método `copyWith` implementado antes 
          // para ayudar con eso.
          todo.copyWith(completed: !todo.completed)
        else
          // otros `todos` no se modifican
          todo,
    ];
  }
}

// Finalmente, estamos usando StateNotifierProvider para permitir que la  
// interfaz de usuario interactúe con nuestra clase TodosNotifier.
final todosProvider = StateNotifierProvider<TodosNotifier, List<Todo>>((ref) {
  return TodosNotifier();
});
