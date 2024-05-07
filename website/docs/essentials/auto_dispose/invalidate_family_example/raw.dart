// ignore_for_file: unused_local_variable

import 'package:flutter_riverpod/flutter_riverpod.dart';

late WidgetRef ref;

/* SNIPPET START */
final provider = Provider.autoDispose.family<String, String>((ref, name) {
  return 'Hello $name';
});

// ...

void onTap() {
  // {@template invalidateAll}
  // Invalidate all possible parameter combinations of this provider.
  // {@endtemplate}
  ref.invalidate(provider);
  // {@template invalidate}
  // Invalidate a specific combination only
  // {@endtemplate}
  ref.invalidate(provider('John'));
}
/* SNIPPET END */
