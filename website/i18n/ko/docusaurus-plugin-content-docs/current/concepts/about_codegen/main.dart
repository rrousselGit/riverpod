// ignore_for_file: use_key_in_widget_constructors, omit_local_variable_types, avoid_unused_constructor_parameters

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'main.g.dart';

class User {
  User.fromJson(Object obj);
}

class Http {
  Future<Object> get(String str) async => str;
}

final http = Http();

/* SNIPPET START */
@riverpod
Future<User> fetchUser(FetchUserRef ref, {required int userId}) async {
  final json = await http.get('api/user/$userId');
  return User.fromJson(json);
}
