// ignore_for_file: unused_local_variable

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'codegen.g.dart';

@riverpod
int other(OtherRef ref) => 0;

/* SNIPPET START */
@riverpod
int example(ExampleRef ref) {
  // "Ref" può essere usato qui per leggere altri provider
  final otherValue = ref.watch(otherProvider);

  return 0;
}
/* SNIPPET END */
