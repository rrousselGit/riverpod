// ignore_for_file: unused_local_variable

import 'package:flutter_riverpod/flutter_riverpod.dart';

late WidgetRef ref;

/* SNIPPET START */
final provider = Provider.autoDispose.family<String, String>((ref, name) {
  return 'Hello $name';
});

// ...

void onTap() {
  // Invalidate all possible parameter combinations of this provider.
  ref.invalidate(provider);
  // Invalidate a specific combination only
  ref.invalidate(provider('John'));
}
/* SNIPPET END */
