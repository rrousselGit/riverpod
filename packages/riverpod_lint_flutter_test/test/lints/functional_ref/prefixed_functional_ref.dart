@TestFor.functional_ref
library;

import 'package:riverpod_annotation/riverpod_annotation.dart' as r;

import '../../test_annotation.dart';

// Regression test: a prefixed `Ref` is a valid ref type.
@r.riverpod
int prefixedRef(r.Ref ref) => 0;

@r.riverpod
int prefixedWrongType(
  // ignore: riverpod_lint/functional_ref
  r.AsyncValue<int> ref,
) {
  return 0;
}
