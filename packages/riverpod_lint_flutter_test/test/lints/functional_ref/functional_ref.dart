import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'functional_ref.g.dart';

@riverpod
int nameless(
  // expect_lint: functional_ref
  ref,
) {
  return 0;
}

@riverpod
int generics<A extends num, B>(GenericsRef<A, B> ref) => 0;

@riverpod
// expect_lint: functional_ref
int noGenerics<A extends num, B>(NoGenericsRef ref) => 0;

@riverpod
// expect_lint: functional_ref
int missingGenerics<A, B>(MissingGenericsRef ref) => 0;

@riverpod
// expect_lint: functional_ref
int wrongOrder<B, A>(WrongOrderRef ref) => 0;
