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
int generics<A extends num, B>(Ref ref) => 0;

@riverpod
int valid(Ref ref) => 0;
