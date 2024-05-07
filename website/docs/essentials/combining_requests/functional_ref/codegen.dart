// ignore_for_file: unused_local_variable

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'codegen.g.dart';

@riverpod
int other(OtherRef ref) => 0;

/* SNIPPET START */
@riverpod
int example(ExampleRef ref) {
  // {@template provider}
  // "Ref" can be used here to read other providers
  // {@endtemplate}
  final otherValue = ref.watch(otherProvider);

  return 0;
}
/* SNIPPET END */
