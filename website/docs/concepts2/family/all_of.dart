// ignore_for_file: prefer_foreach

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
  for (final provider in userProvider.allOf(ref)) {
    ref.invalidate(provider);
  }
  /* SNIPPET END */
}
