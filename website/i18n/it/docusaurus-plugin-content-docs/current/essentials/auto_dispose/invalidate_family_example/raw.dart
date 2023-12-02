// ignore_for_file: unused_local_variable

import 'package:flutter_riverpod/flutter_riverpod.dart';

late WidgetRef ref;

/* SNIPPET START */
final provider = Provider.autoDispose.family<String, String>((ref, name) {
  return 'Hello $name';
});

// ...

void onTap() {
  // Invalida tutte le possibili combinazioni di paramatri di questo provider.
  ref.invalidate(provider);
  // Invalida una sola specifica combinazione
  ref.invalidate(provider('John'));
}
/* SNIPPET END */
