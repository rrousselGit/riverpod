import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'stateless_ref.g.dart';

@riverpod
// expect_lint: stateless_ref
int refless() {
  return 0;
}

@riverpod
int nameless(
  // expect_lint: stateless_ref
  ref,
) {
  return 0;
}

@riverpod
int incorrectlyTyped(
  // expect_lint: stateless_ref
  int ref,
) {
  return 0;
}

@riverpod
external int scoped();
