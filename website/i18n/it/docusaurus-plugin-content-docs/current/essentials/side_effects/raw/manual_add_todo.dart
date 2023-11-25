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

    // Possiamo quindi aggiornare manualmente la cache locale. Per fare ciò, avremo bisogno
    // di ottenere lo stato precedente.
    // Attenzione: lo stato precedente potrebbe essere anche in stato di loading o di errore.
    // Un modo elegante di gestirlo sarebbe leggere `this.future` invece
    // di `this.state`, il che consentirebbe di attendere lo stato di loading e
    // generare un errore se lo stato è in uno stato di errore.
    final previousState = await future;

    // Possiamo quindi aggiornare lo stato, creando un nuovo oggetto di stato.
    // Ciò notificherà i suoi listener.
    state = AsyncData([...previousState, todo]);
  }
/* SNIPPET END */
}
