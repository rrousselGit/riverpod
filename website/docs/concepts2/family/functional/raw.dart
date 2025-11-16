// ignore_for_file: inference_failure_on_function_invocation

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class User {
  User();

  factory User.fromJson(_) => User();
}

/* SNIPPET START */
// When not using code-generation, providers can use ".family".
// This adds one generic parameter corresponding to the type of the parameter.
// The initialization function then receives the parameter.
final userProvider = FutureProvider.autoDispose.family<User, String>((ref, id) async {
  final dio = Dio();
  final response = await dio.get('https://api.example.com/users/$id');

  return User.fromJson(response.data);
});
