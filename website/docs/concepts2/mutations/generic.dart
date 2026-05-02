import 'package:riverpod/experimental/mutation.dart';
import 'package:riverpod/riverpod.dart';

class ApiResponse {}

class CreatedResponse<ValueT> implements ApiResponse {
  CreatedResponse(this.value);

  factory CreatedResponse.fromJson(
    Map<String, Object?> json,
    ValueT Function(Map<String, Object?>) fromJson,
  ) {
    return CreatedResponse(fromJson(json['data']! as Map<String, Object?>));
  }
  final ValueT value;
}

class Todo {
  Todo({required this.id, required this.title});

  factory Todo.fromJson(Map<String, Object?> json) {
    return Todo(id: json['id']! as int, title: json['title']! as String);
  }

  final int id;
  final String title;
}

final apiProvider = Provider((ref) {
  // dummy client.
  return (
    post: (String url, {Map<String, dynamic>? data}) {
      return (data: <String, dynamic>{});
    },
  );
});

/* SNIPPET START */
final create = Mutation<ApiResponse>();
final createTodo = create<CreatedResponse<Todo>>('create_todo');

Future<void> executeCreateTodo(MutationTarget ref) async {
  await createTodo.run(ref, (tsx) async {
    final client = tsx.get(apiProvider);
    final response = client.post('/todos', data: {'title': 'Eat a cookie'});
    return CreatedResponse<Todo>.fromJson(response.data, Todo.fromJson);
  });
}
