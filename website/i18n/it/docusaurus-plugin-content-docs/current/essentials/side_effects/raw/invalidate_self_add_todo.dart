// ignore_for_file: avoid_print, prefer_final_locals, omit_local_variable_types

import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import 'todo_list_notifier.dart';

final todoListProvider = AsyncNotifierProvider.autoDispose<TodoList, List<Todo>>(
  TodoList.new,
);

class TodoList extends AutoDisposeAsyncNotifier<List<Todo>> {
  @override
  Future<List<Todo>> build() async => [/* ... */];

  /* SNIPPET START */
  Future<void> addTodo(Todo todo) async {
    // Non ci importa della risposta dell'API
    await http.post(
      Uri.https('your_api.com', '/todos'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(todo.toJson()),
    );

    // Una volta che la richiesta è terminata, possiamo marcare la cache locale come sporca.
    // Facendo ciò, il metodo "build" sul nostro notifier verrà chiamato asincronamente di nuovo,
    // notificando i suoi listener.
    ref.invalidateSelf();

    // (Opzionale) Possiamo quindi aspettare che il nuovo stato venga computato.
    // Questo assicura che "addTodo" non venga completato finchè il nuovo stato non è disponibile.
    await future;
  }
/* SNIPPET END */
}
