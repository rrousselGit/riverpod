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

@riverpod
int generics<A extends num, B>(GenericsRef<A, B> ref) => 0;

@riverpod
// expect_lint: stateless_ref
int noGenerics<A extends num, B>(NoGenericsRef ref) => 0;

@riverpod
// expect_lint: stateless_ref
int missingGenerics<A, B>(MissingGenericsRef ref) => 0;

@riverpod
// expect_lint: stateless_ref
int wrongOrder<B, A>(WrongOrderRef ref) => 0;
