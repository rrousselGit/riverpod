import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/* SNIPPET START */

// Der Zustand unseres StateNotifier sollte unveränderlich sein.
// Wir könnten auch Pakete wie Freezed verwenden, um bei der Implementierung zu helfen.
@immutable
class Todo {
  const Todo(
      {required this.id, required this.description, required this.completed});

  // Alle variablen in unserer Klasse sollten `final` sein.
  final String id;
  final String description;
  final bool completed;

  // Da Todo unveränderlich ist, implementieren wir eine Methode, die das Klonen
  // des Todo mit leicht verändertem Inhalt ermöglicht.
  Todo copyWith({String? id, String? description, bool? completed}) {
    return Todo(
      id: id ?? this.id,
      description: description ?? this.description,
      completed: completed ?? this.completed,
    );
  }
}

// Die StateNotifier-Klasse, die an unseren StateNotifierProvider übergeben wird.
// Diese Klasse sollte keinen Zustand außerhalb ihrer "state"-Eigenschaft
// preisgeben, d.h. keine öffentlichen Getter/Eigenschaften!
// Die öffentlichen Methoden dieser Klasse ermöglichen es der Benutzeroberfläche, den Status zu ändern.
class TodosNotifier extends StateNotifier<List<Todo>> {
  // Wir initialisieren eine leere Liste von Todos.
  TodosNotifier() : super([]);

  // Erlauben wir der Benutzeroberfläche, ToDos hinzuzufügen.
  void addTodo(Todo todo) {
    // Since our state is immutable, we are not allowed to do `state.add(todo)`.
    // Instead, we should create a new list of todos which contains the previous
    //items and the new one.
    // Die Verwendung des Spread-Operators von Dart ist hier hilfreich!
    state = [...state, todo];
    // Es ist nicht nötig, "notifyListeners" oder etwas Ähnliches aufzurufen.
    // Der Aufruf von "state =" baut das UI bei Bedarf automatisch neu auf.
  }

  // Erlauben wir das Entfernen von ToDos
  void removeTodo(String todoId) {
    // Auch hier ist unser Zustand unveränderlich. Wir erstellen also eine neue
    // Liste, anstatt die bestehende Liste zu ändern.
    state = [
      for (final todo in state)
        if (todo.id != todoId) todo,
    ];
  }

  // Markiere ein Todo als abgeschlossen
  void toggle(String todoId) {
    state = [
      for (final todo in state)
        // Wir markieren nur die passenden Todos als abgschlossen
        if (todo.id == todoId)
          // Da unser Zustand unveränderlich ist, müssen wir erneut eine Kopie
          // des Todos erstellen. Dazu verwenden wir unsere zuvor implementierte
          // Methode `copyWith`.
          todo.copyWith(completed: !todo.completed)
        else
          // andere Todos werden nicht verändert
          todo,
    ];
  }
}

// Schließlich verwenden wir StateNotifierProvider, damit das UI
// mit unserer TodosNotifier-Klasse interagieren kann.
final todosProvider = StateNotifierProvider<TodosNotifier, List<Todo>>((ref) {
  return TodosNotifier();
});
