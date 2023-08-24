// ignore_for_file: avoid_print

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'from_change_notifier.g.dart';

class Todo {
  const Todo(this.id);
  final int id;
}

/* SNIPPET START */
@riverpod
class MyNotifier extends _$MyNotifier {
  @override
  FutureOr<List<Todo>> build() {
    // request mock
    return Future.delayed(const Duration(seconds: 1), () => <Todo>[]);
  }

  Future<void> addTodo(int id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() {
      // request mock
      return Future.delayed(const Duration(seconds: 1), () => [Todo(id)]);
    });
  }
}
