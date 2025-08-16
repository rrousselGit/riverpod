// ignore_for_file: avoid_dynamic_calls

import 'package:flutter_riverpod/experimental/persist.dart';
import 'package:riverpod_annotation/experimental/json_persist.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../storage/codegen.dart';

part 'codegen.g.dart';

Future<List<Todo>> fetchTodosFromServer() async => [];

class Todo {
  Todo({required this.task});
  final String task;
}

/* SNIPPET START */
@riverpod
@JsonPersist()
class TodoList extends _$TodoList {
  @override
  Future<List<Todo>> build() async {
    persist(
      ref.watch(storageProvider.future),
      // We can optionally pass a "destroyKey". When a new version of the application
      // is release with a different destroyKey, the old persisted state will be
      // deleted, and a brand new state will be created.
      // highlight-next-line
      options: const StorageOptions(destroyKey: '1.0'),
    );

    return fetchTodosFromServer();
  }
}
