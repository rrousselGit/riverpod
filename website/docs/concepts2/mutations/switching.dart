import 'package:riverpod/experimental/mutation.dart';

class Todo {}

void switching(MutationState<Todo> addTodoState) {
  /* SNIPPET START */
  switch (addTodoState) {
    case MutationPending():
    case MutationError():
    case MutationSuccess():
    case MutationIdle():
  }
  /* SNIPPET END */
}
