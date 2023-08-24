// ignore_for_file: avoid_print

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'async_notifier.g.dart';

class Todo {}

/* SNIPPET START */
@riverpod
class AsyncTodosNotifier extends _$AsyncTodosNotifier {
  @override
  FutureOr<List<Todo>> build() {
    // mock of a network request
    return Future.delayed(const Duration(seconds: 1), () => []);
  }

  // ...
}
