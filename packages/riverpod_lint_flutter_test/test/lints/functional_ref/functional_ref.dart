@TestFor.functional_ref
library;

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../test_annotation.dart';

part 'functional_ref.g.dart';

@riverpod
int nameless(
  // ignore: riverpod_lint/functional_ref
  ref,
) {
  return 0;
}

@riverpod
int generics<FirstT extends num, SecondT>(Ref ref) => 0;

@riverpod
int valid(Ref ref) => 0;
