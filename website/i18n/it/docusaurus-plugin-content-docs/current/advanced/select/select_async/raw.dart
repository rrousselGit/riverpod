// ignore_for_file: unused_local_variable, avoid_multiple_declarations_per_line, omit_local_variable_types, prefer_final_locals, use_key_in_widget_constructors

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
  // Aspetta che un utente sia disponibile, ed ascolta solo la proprietà "firstName"
  final firstName = await ref.watch(
    userProvider.selectAsync((it) => it.firstName),
  );

  // TODO usa "firstName" per ottenere qualcos'altro
});
/* SNIPPET END */
