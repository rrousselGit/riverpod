import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'codegen.freezed.dart';
part 'codegen.g.dart';

class Http {
  Future<String> get(String str) async => str;
  Future<String> delete(String str) async => str;
  Future<String> post(String str, Map<String, dynamic> body) async => str;
  Future<String> patch(String str, Map<String, dynamic> body) async => str;
}

final http = Http();

/* SNIPPET START */

@freezed
class Todo with _$Todo {
  factory Todo({
    required String id,
    required String description,
    required bool completed,
  }) = _Todo;

  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);
}

// Ceci va générer un AsyncNotifier et un AsyncNotifierProvider.
// La classe AsyncNotifier qui sera transmise à notre AsyncNotifierProvider.
// Cette classe ne doit pas exposer d'état en dehors de sa propriété "state", ce qui signifie que
// pas de getters/properties publics !
// Les méthodes publiques de cette classe seront celles qui permettront à l'interface utilisateur de modifier l'état.
// Enfin, nous utilisons asyncTodosProvider(AsyncNotifierProvider) pour permettre à l'interface utilisateur
// d'interagir avec notre classe Todos.
@riverpod
class AsyncTodos extends _$AsyncTodos {
  Future<List<Todo>> _fetchTodo() async {
    final json = await http.get('api/todos');
    final todos = jsonDecode(json) as List<Map<String, dynamic>>;
    return todos.map(Todo.fromJson).toList();
  }

  @override
  FutureOr<List<Todo>> build() async {
    // Chargement de la liste de tâches initiale à partir du référentiel distant
    return _fetchTodo();
  }

  Future<void> addTodo(Todo todo) async {
    // Définit l'état à "loading"
    state = const AsyncValue.loading();
    // Ajout du nouveau todo et rechargement de la liste des todo depuis le référentiel distant
    state = await AsyncValue.guard(() async {
      await http.post('api/todos', todo.toJson());
      return _fetchTodo();
    });
  }

  // Autorisons la suppression des todos.
  Future<void> removeTodo(String todoId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await http.delete('api/todos/$todoId');
      return _fetchTodo();
    });
  }

  // Marquons une tâche comme étant terminée.
  Future<void> toggle(String todoId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await http.patch(
        'api/todos/$todoId',
        <String, dynamic>{'completed': true},
      );
      return _fetchTodo();
    });
  }
}
