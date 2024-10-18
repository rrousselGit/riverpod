import 'package:riverpod/riverpod.dart';
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

// Regression test for https://github.com/rrousselGit/riverpod/issues/2689
@riverpod
// expect_lint: functional_ref
int noRefButArgs({int a = 42}) {
  return 0;
}

@riverpod
int valid(Ref ref) => 0;
