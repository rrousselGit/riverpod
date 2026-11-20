// GENERATED from website/docs/whats_new.mdx by scripts/snippets.sh.
// Do not modify by hand: edit the snippet instead.

import 'package:flutter_riverpod/experimental/mutation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:material_ui/material_ui.dart';
import 'package:riverpod_annotation/experimental/scope.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:test/test.dart';

// The snippets that define addTodoMutation, the scoped myFuture, and the
// widgets MyApp and MyWidget, for the ones that use them.
import 'add_todo_mutation.dart';
import 'my_future.dart';
import 'scoped_app.dart';

late Ref ref;

class TodoList extends Notifier<List<String>> {
  @override
  List<String> build() => [];
  Future<void> addTodo(String todo) async {}
}

final todoListProvider = NotifierProvider<TodoList, List<String>>(TodoList.new);

class SomeSpecificError implements Exception {}

class MyException implements Exception {}

class Argument {}

final myProvider = FutureProvider<int>((ref) async => 0);
final failingProvider = Provider<int>((ref) => throw SomeSpecificError());

// What the generator creates for the "multiply" and "myFuture" providers.
Provider<T> multiplyProvider<T extends num>(T a, T b) {
  return Provider<T>((ref) => (a * b) as T);
}

final myFutureProvider = FutureProvider<int>(
  (ref) => throw UnimplementedError(),
  dependencies: const [],
);

class AddTodoButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen to the status of the "addTodo" side-effect
    final addTodo = ref.watch(addTodoMutation);

    return switch (addTodo) {
      // No side-effect is in progress
      // Let's show a submit button
      MutationIdle() => ElevatedButton(
        // Trigger the side-effect on click
        onPressed: () {
          // TODO see explanation after the code snippet
        },
        child: const Text('Submit'),
      ),
      // The side-effect is in progress. We show a spinner
      MutationPending() => const CircularProgressIndicator(),
      // The side-effect failed. We show a retry button
      MutationError() => ElevatedButton(
        onPressed: () {
          // TODO see explanation after the code snippet
        },
        child: const Text('Retry'),
      ),
      // The side-effect was successful. We show a success message
      MutationSuccess() => const Text('Todo added!'),
    };
  }
}
