import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/* SNIPPET START */

// Lo stato del nostro StateNotifier dovrebbe essere immutabile.
// Potremmo usare anche packages come Freezed per aiutarci con l'implementazione.

@immutable
class Todo {
  const Todo({required this.id, required this.description, required this.completed});

  // Tutte le proprietà dovrebbero essere `final` nella nostra classe.
  final String id;
  final String description;
  final bool completed;

  // Dato che Todo è immutabile, implementiamo un metodo che ci permette di
  // clonare l'oggetto Todo con un contenuto leggermente diverso.

  Todo copyWith({String? id, String? description, bool? completed}) {
    return Todo(
      id: id ?? this.id,
      description: description ?? this.description,
      completed: completed ?? this.completed,
    );
  }
}

// La classe StateNotifier sarà passata al nostro StateNotifierProvider.
// Questa classe non dovrebbe esporre lo stato al di fuori della sua proprietà "state"
// il che significa nessuna proprietà o getter pubblico!

// I metodi pubblici di questa classe sono quelli che consentiranno alla UI di modificare lo stato.

class TodosNotifier extends StateNotifier<List<Todo>> {
  // Inizializzamo la lista dei todo con una lista vuota

  TodosNotifier() : super([]);

  // Consentiamo alla UI di aggiungere i todo
  void addTodo(Todo todo) {
    // Poichè il nostro stato è immutabile, non siamo autorizzati a fare `state.add(todo)`.
    // Dovremmo invece creare una nuova lista di todo contenente
    // gli elementi precedenti e il nuovo

    // Usare lo spread operator di Dart qui è d'aiuto!

    state = [...state, todo];
    // Non c'è bisogno di chiamare "notifiyListeners" o qualcosa di simile.
    // Chiamare "state =" ricostruirà automaticamente la UI quando necessario.
  }

  // Consentiamo di rimuovere i todo
  void removeTodo(String todoId) {
    // Di nuovo, il nostro stato è immutabile. Quindi facciamo una nuova lista
    // invece di modificare la lista esistente.

    state = [
      for (final todo in state)
        if (todo.id != todoId) todo,
    ];
  }

  // Contrassegniamo il todo come completato
  void toggle(String todoId) {
    state = [
      for (final todo in state)
        // contrassegniamo solo il todo corrispondente come completato
        if (todo.id == todoId)
          // Usiamo il metodo `copyWith` implementato prima per aiutarci nel
          // modificare lo stato

          todo.copyWith(completed: !todo.completed)
        else
          // gli altri todo non sono modificati
          todo,
    ];
  }
}

// Infine, usiamo StateNotifierProvider per consentire all'UI di interagire con
// la classe TodosNotifier
final todosProvider = StateNotifierProvider<TodosNotifier, List<Todo>>((ref) {
  return TodosNotifier();
});
