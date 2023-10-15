import 'package:riverpod_annotation/riverpod_annotation.dart';

@riverpod
// expect_lint: functional_ref
int refless() {
  return 0;
}

@riverpod
int incorrectlyTyped(
  // expect_lint: functional_ref
  int ref,
) {
  return 0;
}

// Regression test for https://github.com/rrousselGit/riverpod/issues/2689
@riverpod
// expect_lint: functional_ref
int noRefButArgs({int a = 42}) {
  return 0;
}
