// ignore_for_file: inference_failure_on_function_invocation, avoid_print

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
    // При использовании code-generation Notifier'ы могут принимать параметры
    // прямо в методе build. Можно определить любое количество параметров.
    String id,
  ) async {
    final dio = Dio();
    final response = await dio.get('https://api.example.com/users/$id');

    // Сгенерированный класс также получает доступ к параметрам build
    // через `this`:
    print(this.id);

    return User.fromJson(response.data);
  }
}
