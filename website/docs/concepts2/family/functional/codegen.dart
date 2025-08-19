// ignore_for_file: avoid_dynamic_calls, inference_failure_on_function_invocation

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
  // When using code-generation, providers can receive any number of parameters.
  // They can be both positional/named and required/optional.
  String id,
) async {
  final dio = Dio();
  final response = await dio.get('https://api.example.com/users/$id');

  return User.fromJson(response.data);
}
