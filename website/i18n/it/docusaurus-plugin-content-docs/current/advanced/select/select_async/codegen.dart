// ignore_for_file: unused_local_variable, avoid_multiple_declarations_per_line, omit_local_variable_types, prefer_final_locals, use_key_in_widget_constructors, body_might_complete_normally_nullable

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'codegen.g.dart';

class User {
  late String firstName, lastName;
}

final userProvider = FutureProvider(
  (ref) => User()
    ..firstName = 'John'
    ..lastName = 'Doe',
);
/* SNIPPET START */
@riverpod
Object? example(ExampleRef ref) async {
  // Aspetta che un utente sia disponibile, ed ascolta solo la proprietà "firstName"
  final firstName = await ref.watch(
    userProvider.selectAsync((it) => it.firstName),
  );

  // TODO usa "firstName" per ottenere qualcos'altro
}
/* SNIPPET END */
