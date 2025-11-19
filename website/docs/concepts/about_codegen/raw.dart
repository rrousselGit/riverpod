// ignore_for_file: avoid_unused_constructor_parameters

import 'package:flutter_riverpod/flutter_riverpod.dart';

class User {
  User.fromJson(Object obj);
}

class Http {
  Future<Object> get(String str) async => str;
}

final http = Http();

/* SNIPPET START */
final fetchUserProvider = FutureProvider.autoDispose.family<User, int>((
  ref,
  userId,
) async {
  final json = await http.get('api/user/$userId');
  return User.fromJson(json);
});
