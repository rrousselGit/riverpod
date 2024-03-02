import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'codegen.freezed.dart';
part 'codegen.g.dart';

/* SNIPPET START */

@freezed
class Todo with _$Todo {
  factory Todo({
    required String id,
    required String description,
    required bool completed,
  }) = _Todo;
}

// Ceci va générer un Notifier et un NotifierProvider.
// La classe de Notifier qui sera transmise à notre NotifierProvider.
// Cette classe ne doit pas exposer d'état en dehors de sa propriété "state", ce qui signifie que
// pas de getters/properties publics !
// Les méthodes publiques de cette classe seront celles qui permettront à l'interface utilisateur de modifier l'état.
// Enfin, nous utilisons todosProvider(NotifierProvider) pour permettre à l'interface utilisateur
// d'interagir avec notre classe Todos.
@riverpod
class Todos extends _$Todos {
  @override
  List<Todo> build() {
    return [];
  }

  // Permettons à l'interface utilisateur d'ajouter des todos.
  void addTodo(Todo todo) {
    // Comme notre état est immuable, nous ne pouvons pas faire `state.add(todo)`.
    // A la place, nous devons créer une nouvelle liste de todos qui contient
    // les éléments précédents et le nouveau.
    // L'utilisation de l'opérateur spread de Dart est utile ici !
    state = [...state, todo];
    // Il n'est pas nécessaire d'appeler "notifyListeners" ou quelque chose de similaire. L'appel de "state ="
    // reconstruira automatiquement l'interface utilisateur si nécessaire.
  }

  // Autorisons la suppression des todos.
  void removeTodo(String todoId) {
    // Encore une fois, notre état est immuable. Donc nous créons une nouvelle liste au lieu de
    // changer la liste existante.
    state = [
      for (final todo in state)
        if (todo.id != todoId) todo,
    ];
  }

  // Marquons une tâche comme étant terminée.
  void toggle(String todoId) {
    state = [
      for (final todo in state)
        // nous marquons seulement le todo correspondant comme terminé
        if (todo.id == todoId)
          // Une fois de plus, puisque notre état est immuable, nous devons faire une copie
          // du todo. Nous utilisons la méthode `copyWith` implémentée précédemment
          // pour nous aider à le faire.
          todo.copyWith(completed: !todo.completed)
        else
          // les autres todos ne sont pas modifiés
          todo,
    ];
  }
}
