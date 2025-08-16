// ignore_for_file: avoid_dynamic_calls

import 'package:flutter_riverpod/experimental/persist.dart';
import 'package:riverpod_annotation/experimental/json_persist.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'destroy_key/codegen.dart';
import 'storage/codegen.dart';

part 'custom_duration.g.dart';

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
