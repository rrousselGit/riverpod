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
  // Invalidate all possible parameter combinations of this provider.
  ref.invalidate(labelProvider);
  // Invalidate a specific combination only
  ref.invalidate(labelProvider('John'));
}
/* SNIPPET END */
