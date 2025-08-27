import 'package:riverpod/experimental/mutation.dart';

const todo = (id: 0);

/* SNIPPET START */
final removeTodo = Mutation<void>();
final removeTodoWithId = removeTodo(todo.id);
