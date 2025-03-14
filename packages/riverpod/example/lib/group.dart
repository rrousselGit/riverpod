import 'package:riverpod/experiments/group.dart';
import 'package:riverpod/experiments/providers.dart';

//////
//////
//////
//////
//////
//////
//////
//////
//////
//////
//////

final users = Group<String, User>((value) => value.id);

final class User {
  User({required this.id, required this.name});
  final String id;
  final String name;
}

final usersRepo = UsersRepo();

class UsersRepo with Group<String, User> {
  @override
  String keyFor(User value) => value.id;

  late final current = CurrentUserProvider();

  @override
  ProviderListenable2<User?> byId(String id) {
    return Provider2.sync<User?>(
      group: bind.value.optional,
      (ref) {
        super.byId(id).watch(ref);

        return null;
      },
    );
  }

  late final home = Provider2.sync<List<User>>(
    group: bind.list,
    (ref) => [],
  );
}

class CurrentUserProvider extends CustomProvider2<User?> {
  @override
  late final create = sync((ref) => null);

  late final $logout = mutation<void>();
  MutationCall<void> logout() => mutate($logout, (ref) async {
        ref.state = null;
      });

  late final $login = mutation<User>();
  MutationCall<void> loginWithEmailPassword(String email, String pass) =>
      mutate(
        $login,
        (ref) async {
          ref.state = User(id: 'id', name: 'name');
        },
      );
}
