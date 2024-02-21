// ignore_for_file: omit_local_variable_types, avoid_types_on_closure_parameters, avoid_print

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'codegen.g.dart';

@riverpod
int counter(CounterRef ref) => 0;

/* SNIPPET START */

@riverpod
void another(AnotherRef ref) {
  ref.listen<int>(counterProvider, (int? previousCount, int newCount) {
    print('The counter changed $newCount');
  });
  // ...
}
