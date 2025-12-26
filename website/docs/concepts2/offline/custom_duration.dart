// ignore_for_file: unnecessary_async

import 'package:flutter_riverpod/experimental/persist.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/experimental/json_persist.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'storage/codegen.dart';

part 'custom_duration.g.dart';
part 'custom_duration.freezed.dart';

@freezed
abstract class Todo with _$Todo {
  const factory Todo({
    required String id,
    required String title,
    required bool completed,
  }) = _Todo;

  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);
}

Future<List<Todo>> fetchTodosFromServer() async => [];

@riverpod
@JsonPersist()
class TodoList extends _$TodoList {
  /* SNIPPET START */
  @override
  Future<List<Todo>> build() async {
    persist(
      ref.watch(storageProvider.future),
      // We tell Riverpod to forever persist the state of this provider.
      // highlight-next-line
      options: const StorageOptions(
        // Instead of "unsafe_forever", you can alternatively specify a Duration.
        cacheTime: StorageCacheTime.unsafe_forever,
      ),
      // ...
    );

    return fetchTodosFromServer();
  }

  /* SNIPPET END */
}
