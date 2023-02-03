// ignore_for_file: omit_local_variable_types, avoid_types_on_closure_parameters, avoid_print

import 'package:riverpod/riverpod.dart';
import '../counter/raw.dart';

/* SNIPPET START */

final anotherProvider = Provider((ref) {
  ref.listen<int>(counterProvider, (int? previousCount, int newCount) {
    print('The counter changed $newCount');
  });
  // ...
});
