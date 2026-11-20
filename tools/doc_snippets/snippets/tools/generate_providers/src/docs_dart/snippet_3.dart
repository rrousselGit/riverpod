// GENERATED from tools/generate_providers/src/docs.dart by scripts/snippets.sh.
// Do not modify by hand: edit the snippet instead.

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

final dio = Dio();
final httpClient = Dio();

class User {
  User(this.name);

  final String name;
}

class UserRepository {
  Future<User> fetch(int userId) async => User('John');
}

final userRepositoryProvider = Provider((ref) => UserRepository());

class Configurations {
  Configurations(this.host);

  final String host;
}

class Repository {
  Repository({required this.host});

  final String host;
}

class Message {
  Message.fromJson(Map<String, Object?> json);
}

class ComplexParameter {}

class Value {
  Value(this.param);

  final ComplexParameter param;
}

final userFamily = FutureProvider.family<User, int>((ref, userId) async {
  final userRepository = ref.read(userRepositoryProvider);
  return await userRepository.fetch(userId);
});

// ...

Widget build(BuildContext context, WidgetRef ref) {
  final userId = 42; // Read the user ID from somewhere

  // Read and potentially fetch the user with id `userId`.
  // When `userId` changes, this will automatically update the UI
  // Similarly, if two widgets tries to read `userFamily` with the same `userId`
  // then the user will be fetched only once.
  final user = ref.watch(userFamily(userId));

  return user.when(
    data: (user) => Text(user.name),
    loading: () => const CircularProgressIndicator(),
    error: (err, stack) => const Text('error'),
  );
}
