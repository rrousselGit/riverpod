// ignore_for_file: avoid_print

import 'package:riverpod_annotation/riverpod_annotation.dart';

class Todo {}

/* SNIPPET START */
class AsyncTodosNotifier extends AsyncNotifier<List<Todo>> {
  @override
  FutureOr<List<Todo>> build() {
    // mock of a network request
    return Future.delayed(const Duration(seconds: 1), () => []);
  }

  // ...
}

final asyncTodosNotifier = AsyncNotifierProvider<AsyncTodosNotifier, List<Todo>>(
  AsyncTodosNotifier.new,
);
