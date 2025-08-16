// ignore_for_file: avoid_dynamic_calls

import 'package:flutter_riverpod/experimental/persist.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/experimental/json_persist.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'storage/codegen.dart';

part 'json_persist.g.dart';
part 'json_persist.freezed.dart';

Future<List<Todo>> fetchTodosFromServer() async => [];

/* SNIPPET START */
// Using freezed or json_serializable to generate from/toJson for your objects
@freezed
abstract class Todo with _$Todo {
  const factory Todo({required String task}) = _Todo;

  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);
}

@riverpod
// Specify @JsonPersist. This will provide a custom "persist" method for your notifier
@JsonPersist()
class TodoList extends _$TodoList {
  @override
  Future<List<Todo>> build() async {
    persist(
      // We pass in the previously created Storage.
      // Do not "await" this. Riverpod will handle it for you.
      ref.watch(storageProvider.future),
      // No need to specify key/encode/decode functions.
    );

    // Initialize the notifier as usual.
    return fetchTodosFromServer();
  }
}
