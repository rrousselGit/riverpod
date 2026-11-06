// ignore_for_file: inference_failure_on_function_invocation

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'codegen.g.dart';

class User {
  User({this.name});
  factory User.fromJson(_) => User();

  final String? name;
}

/* SNIPPET START */
@riverpod
Future<User> user(
  Ref ref,
  // При использовании code-generation providers могут принимать любое количество параметров.
  // Они могут быть как позиционными/именованными, так и обязательными/необязательными.
  String id,
) async {
  final dio = Dio();
  final response = await dio.get('https://api.example.com/users/$id');

  return User.fromJson(response.data);
}
