// ignore_for_file: unused_local_variable

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'codegen.g.dart';

@riverpod
int other(OtherRef ref) => 0;

/* SNIPPET START */
@riverpod
int example(ExampleRef ref) {
  // 다른 provider를 읽으려면 여기에서 "Ref"를 사용할 수 있습니다.
  final otherValue = ref.watch(otherProvider);

  return 0;
}
/* SNIPPET END */
