import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:riverpod/experimental/persist.dart';
import 'package:riverpod_sqflite/riverpod_sqflite.dart';
import 'package:sqflite/sqflite.dart';

// A example showcasing JsonSqFliteStorage without code generation.
final storageProvider = FutureProvider<JsonSqFliteStorage>((ref) async {
  // Initialize SQFlite. We should share the Storage instance between providers.
  return JsonSqFliteStorage.open(join(await getDatabasesPath(), 'riverpod.db'));
});

/// A serializable Todo class.
class Todo {
  const Todo({
    required this.id,
    required this.description,
    required this.completed,
  });

  Todo.fromJson(Map<String, dynamic> json)
    : id = json['id'] as int,
      description = json['description'] as String,
      completed = json['completed'] as bool;

  final int id;
  final String description;
  final bool completed;

  Map<String, dynamic> toJson() {
    return {'id': id, 'description': description, 'completed': completed};
  }
}

final todosProvider = AsyncNotifierProvider<TodosNotifier, List<Todo>>(
  TodosNotifier.new,
);

class TodosNotifier extends AsyncNotifier<List<Todo>> {
  @override
  FutureOr<List<Todo>> build() async {
    // We call persist at the start of our `build` method.
    // This will:
    // - Read the DB and update the state with the persisted value the first
    //   time this method executes.
    // - Listen to changes on this provider and write those changes to the DB.
    // We "await" for persist to complete to make sure that the decoding is done
    // before we return the state.
    persist(
      // We pass our JsonSqFliteStorage instance. No need to "await" the Future.
      // Riverpod will take care of that.
      ref.watch(storageProvider.future),
      // A unique key for this state.
      // No other provider should use the same key.
      key: 'todos',
      // By default, state is cached offline only for 2 days.
      // In this example, we tell Riverpod to cache the state forever.
      options: const StorageOptions(cacheTime: StorageCacheTime.unsafe_forever),
      encode: jsonEncode,
      decode: (json) {
        final decoded = jsonDecode(json) as List;
        return decoded
            .map((e) => Todo.fromJson(e as Map<String, Object?>))
            .toList();
      },
    );

    // If a state is persisted, we return it. Otherwise we return an empty list.
    return state.value ?? [];
  }

  Future<void> add(Todo todo) async {
    // When modifying the state, no need for any extra logic to persist the change.
    // Riverpod will automatically cache the new state and write it to the DB.
    state = AsyncData([...await future, todo]);
  }
}
