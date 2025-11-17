// ignore_for_file: unused_local_variable, avoid_multiple_declarations_per_line, body_might_complete_normally_nullable

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'codegen.g.dart';

class User {
  late String firstName, lastName;
}

@riverpod
FutureOr<User> user(Ref ref) {
  return User()
    ..firstName = 'John'
    ..lastName = 'Doe';
}

/* SNIPPET START */
@riverpod
Object? example(Ref ref) async {
  // {@template watch}
  // Wait for a user to be available, and listen to only the "firstName" property
  // {@endtemplate}
  final firstName = await ref.watch(
    userProvider.selectAsync((it) => it.firstName),
  );

  // {@template todo}
  // TODO use "firstName" to fetch something else
  // {@endtemplate}
}
/* SNIPPET END */
