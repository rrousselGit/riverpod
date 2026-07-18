// ignore_for_file: inference_failure_on_function_invocation

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class User {
  User();

  factory User.fromJson(_) => User();
}

/* SNIPPET START */
// Для notifier providers мы также используем ".family" и добавляем дополнительный
// generic-параметр.
// Главное отличие в том, что связанный Notifier должен определить конструктор
// и поле для получения этого параметра.
final userProvider = AsyncNotifierProvider.autoDispose
    .family<UserNotifier, User, String>(UserNotifier.new);

class UserNotifier extends AsyncNotifier<User> {
  // Сохраняем аргумент в поле, чтобы затем его использовать
  UserNotifier(this.id);
  final String id;

  @override
  Future<User> build() async {
    final dio = Dio();
    final response = await dio.get('https://api.example.com/users/$id');

    return User.fromJson(response.data);
  }
}
