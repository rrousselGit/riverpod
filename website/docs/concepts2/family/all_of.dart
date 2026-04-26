import 'package:riverpod/riverpod.dart';

final userProvider = Provider.family<User, String>((ref, id) {
  return User(id: id);
});

class User {
  User({required this.id});

  final String id;
}

void refreshVisibleUsers(Ref ref) {
  /* SNIPPET START */
  for (final reference in ref.container.allProviders(family: userProvider)) {
    ref.invalidate(reference.provider);
  }
  /* SNIPPET END */
}
