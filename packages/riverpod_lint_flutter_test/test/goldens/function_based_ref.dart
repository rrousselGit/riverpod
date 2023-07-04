import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'function_based_ref.g.dart';

@riverpod
// expect_lint: function_based_ref
int refless() {
  return 0;
}

@riverpod
int nameless(
  // expect_lint: function_based_ref
  ref,
) {
  return 0;
}

@riverpod
int incorrectlyTyped(
  // expect_lint: function_based_ref
  int ref,
) {
  return 0;
}

@riverpod
external int scoped();
