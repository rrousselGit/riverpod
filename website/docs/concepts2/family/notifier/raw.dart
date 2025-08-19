// ignore_for_file: avoid_dynamic_calls, inference_failure_on_function_invocation

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class User {
  User();

  factory User.fromJson(_) => User();
}

/* SNIPPET START */
// With notifiers providers, we also use ".family" and receive and extra
// generic argument.
// The main difference is that the associated Notifier needs to define
// a constructor+field to accept the argument.
final userProvider = AsyncNotifierProvider.autoDispose.family<UserNotifier, User, String>(
  UserNotifier.new,
);

class UserNotifier extends AsyncNotifier<User> {
  // We store the argument in a field, so that we can use it
  UserNotifier(this.id);
  final String id;

  @override
  Future<User> build() async {
    final dio = Dio();
    final response = await dio.get('https://api.example.com/users/$id');

    return User.fromJson(response.data);
  }
}
