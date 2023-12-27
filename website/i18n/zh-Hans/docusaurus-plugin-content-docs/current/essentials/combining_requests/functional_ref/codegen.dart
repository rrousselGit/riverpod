// ignore_for_file: unused_local_variable

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'codegen.g.dart';

@riverpod
int other(OtherRef ref) => 0;

/* SNIPPET START */
@riverpod
int example(ExampleRef ref) {
  // "Ref" 可以在这里用来阅读其他提供者程序
  final otherValue = ref.watch(otherProvider);

  return 0;
}
/* SNIPPET END */
