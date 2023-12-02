// ignore_for_file: unused_local_variable

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'codegen.g.dart';

late WidgetRef ref;

/* SNIPPET START */
@riverpod
String label(LabelRef ref, String userName) {
  return 'Hello $userName';
}

// ...

void onTap() {
  // Invalida tutte le possibili combinazioni di paramatri di questo provider.
  ref.invalidate(labelProvider);
  // Invalida una sola specifica combinazione
  ref.invalidate(labelProvider('John'));
}
/* SNIPPET END */
