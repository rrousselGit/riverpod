// ignore_for_file: avoid_dynamic_calls

import 'package:flutter_riverpod/experimental/persist.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/experimental/json_persist.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'storage/codegen.dart';

part 'wait_persist.g.dart';

Future<List<Todo>> fetchTodosFromServer() async => [];

class Todo {
  Todo({required this.task});
  final String task;
}

@riverpod
@JsonPersist()
class TodoList extends _$TodoList {
  /* SNIPPET START */
  @override
  Future<List<Todo>> build() async {
    // Wait for decoding to complete
    await persist(
      ref.watch(storageProvider.future),
      // ...
    ).future;

    // If any state has been decoded, initialize the provider with it.
    // Otherwise provide a default value.
    return state.value ?? <Todo>[];
  }
  /* SNIPPET END */
}
