// GENERATED from website/docs/concepts2/mutations.mdx by scripts/snippets.sh.
// Do not modify by hand: edit the snippet instead.

import 'package:riverpod/experimental/mutation.dart';

class Todo {}

// A mutation to track the "add todo" operation.
// The generic type is optional and can be specified to enable the UI to interact
// with the result of the mutation.
final addTodo = Mutation<Todo>();
