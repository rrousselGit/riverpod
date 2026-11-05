@TestFor.functional_ref
library;

import 'package:riverpod_annotation/riverpod_annotation.dart' as r;

import '../../test_annotation.dart';

@r.riverpod
int prefixedWrongType(
  // ignore: riverpod_lint/functional_ref
  r.AsyncValue<int> ref,
) {
  return 0;
}
