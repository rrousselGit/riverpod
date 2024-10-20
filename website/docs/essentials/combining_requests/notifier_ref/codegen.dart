// ignore_for_file: unused_local_variable

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'codegen.g.dart';

@riverpod
int other(Ref ref) => 0;

/* SNIPPET START */
@riverpod
class Example extends _$Example {
  @override
  int build() {
    // {@template watch}
    // "Ref" can be used here to read other providers
    // {@endtemplate}
    final otherValue = ref.watch(otherProvider);

    return 0;
  }
}
/* SNIPPET END */
