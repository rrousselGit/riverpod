// ignore_for_file: omit_local_variable_types, avoid_types_on_closure_parameters, avoid_print

import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../counter/codegen.dart';

part 'codegen.g.dart';

/* SNIPPET START */

@riverpod
void another(Ref ref) {
  ref.listen<int>(counterProvider, (int? previousCount, int newCount) {
    print('The counter changed $newCount');
  });
  // ...
}
