import 'package:riverpod/experimental/mutation.dart';

class Todo {}

void switching(MutationState<Todo> addTodoState) {
  /* SNIPPET START */
  switch (addTodoState) {
    case MutationIdle():
    // Show a button to add a todo
    case MutationPending():
    // Show a loading indicator
    case MutationError():
    // Show an error message
    case MutationSuccess():
    // Show the created todo
  }
  /* SNIPPET END */
}
