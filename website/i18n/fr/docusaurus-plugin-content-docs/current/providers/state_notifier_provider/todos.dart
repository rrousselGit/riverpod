import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/* SNIPPET START */

// L'état de notre StateNotifier doit être immuable.
// On peut aussi utiliser des packages comme Freezed pour aider à la mise en œuvre.
@immutable
class Todo {
  const Todo({required this.id, required this.description, required this.completed});

  // Toutes les propriétés doivent être `finales` sur notre classe.
  final String id;
  final String description;
  final bool completed;

  // Puisque Todo est immuable, on implémente une méthode qui permet de cloner le Todo 
  // avec un contenu légèrement différent.
  Todo copyWith({String? id, String? description, bool? completed}) {
    return Todo(
      id: id ?? this.id,
      description: description ?? this.description,
      completed: completed ?? this.completed,
    );
  }
}

// La classe StateNotifier qui sera transmise à notre StateNotifierProvider. 
// Cette classe ne doit pas exposer d'état (state) en dehors de sa propriété "state", 
// ce qui signifie que pas de public getteurs/properietés!
// Les méthodes publiques de cette classe seront celles qui permettront à l'interface 
// utilisateur de modifier l'état (state).
class TodosNotifier extends StateNotifier<List<Todo>> {
  // On initialise la liste des todos à une liste vide.
  TodosNotifier(): super([]);

  // Permettre à l'interface utilisateur d'ajouter des todos.
  void addTodo(Todo todo) {
    // Comme notre état est immuable, nous n'avons pas le droit de faire `state.add(todo)`.
    // Au lieu de cela, on doit créer une nouvelle liste de tâches qui contient 
    // les éléments précédents et le nouveau.
    // L'utilisation de spread de Dart est utile ici !
    state = [...state, todo];
    // Il n'est pas nécessaire d'appeler "notifyListeners" ou quelque chose de similaire. 
    // L'appel à "state =" reconstruira automatiquement l'interface utilisateur si nécessaire.
  }

  // Autorisation de supprimer les todos
  void removeTodo(String todoId) {
    // Encore une fois, notre état est immuable. 
    // Donc on crée une nouvelle liste au lieu de changer la liste existante.
    state = [
      for (final todo in state)
        if (todo.id != todoId) todo,
    ];
  }

  // Marquez une tâche comme étant terminée
  void toggle(String todoId) {
    state = [
      for (final todo in state)
        // on marque seulement le todo correspondant comme terminé
        if (todo.id == todoId)
          // Encore une fois, puisque notre état est immuable, 
          // nous devons faire une copie du todo. Nous utilisons la méthode `copyWith` 
          // implémentée précédemment pour y parvenir.
          todo.copyWith(completed: !todo.completed)
        else
          // les autres todos ne sont pas modifiés
          todo,
    ];
  }
}

// Enfin, on utilise le StateNotifierProvider pour permettre à l'interface utilisateur 
// d'interagir avec notre classe TodosNotifier.
final todosProvider = StateNotifierProvider<TodosNotifier, List<Todo>>((ref) {
  return TodosNotifier();
});