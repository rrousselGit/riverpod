// ignore_for_file: inference_failure_on_function_invocation

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class User {
  User();

  factory User.fromJson(_) => User();
}

/* SNIPPET START */
// При использовании без code-generation, providers могут использовать ".family".
// Это добавляет один generic-параметр, соответствующий типу параметра.
// Функция инициализации затем получает этот параметр.
final userProvider = FutureProvider.autoDispose.family<User, String>((
  ref,
  id,
) async {
  final dio = Dio();
  final response = await dio.get('https://api.example.com/users/$id');

  return User.fromJson(response.data);
});
