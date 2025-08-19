// ignore_for_file: avoid_dynamic_calls, inference_failure_on_function_invocation, avoid_print

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'codegen.g.dart';

class User {
  User();

  factory User.fromJson(_) => User();
}

/* SNIPPET START */
@riverpod
class UserNotifier extends _$UserNotifier {
  @override
  Future<User> build(
    // When using code-generation, Notifiers can define parameters on their
    // "build" method. Any number of parameter can be defined.
    String id,
  ) async {
    final dio = Dio();
    final response = await dio.get('https://api.example.com/users/$id');

    // The generated class will naturally have access to the parameters
    // passed to the "build" method in "this":
    print(this.id);

    return User.fromJson(response.data);
  }
}
