@TestFor.functional_ref
library;

// Only for the generated part: riverpod_generator does not support a
// prefixed riverpod_annotation yet. Remove once #4964 lands.
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart' as r;

import '../../test_annotation.dart';

part 'prefixed_functional_ref.g.dart';

// Regression test: a prefixed `Ref` is a valid ref type.
@r.riverpod
int prefixedRef(r.Ref ref) => 0;
