// ignore_for_file: unused_local_variable, avoid_multiple_declarations_per_line

import 'package:flutter_riverpod/flutter_riverpod.dart';

class User {
  late String firstName, lastName;
}

final userProvider = FutureProvider(
  (ref) => User()
    ..firstName = 'John'
    ..lastName = 'Doe',
);
/* SNIPPET START */
final provider = FutureProvider((ref) async {
  // {@template watch}
  // Wait for a user to be available, and listen to only the "firstName" property
  // {@endtemplate}
  final firstName = await ref.watch(
    userProvider.selectAsync((it) => it.firstName),
  );

  // {@template todo}
  // TODO use "firstName" to fetch something else
  // {@endtemplate}
});
/* SNIPPET END */
