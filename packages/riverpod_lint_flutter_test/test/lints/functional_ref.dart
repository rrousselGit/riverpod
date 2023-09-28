import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'functional_ref.g.dart';

@riverpod
// expect_lint: functional_ref
int refless() {
  return 0;
}

@riverpod
int nameless(
  // expect_lint: functional_ref
  ref,
) {
  return 0;
}

@riverpod
int incorrectlyTyped(
  // expect_lint: functional_ref
  int ref,
) {
  return 0;
}

@riverpod
external int scoped();
