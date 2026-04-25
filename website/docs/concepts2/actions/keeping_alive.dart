import 'package:riverpod/riverpod.dart';

Future<T> action<T>(Future<T> Function() cb) => cb();

class User {
  const User();
}

class Api {
  Future<User> fetchCurrentUser() async {
    return const User();
  }
}

final apiProvider = Provider((ref) => Api());

/* SNIPPET START */
final currentUserProvider = FutureProvider.autoDispose<User>((ref) {
  return ref.read(apiProvider).fetchCurrentUser();
});

Future<User> loadCurrentUser(ProviderContainer container) {
  return action(() async {
    return await container.read(currentUserProvider.future);
  });
}
/* SNIPPET END */
