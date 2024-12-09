// ignore_for_file: unused_local_variable, avoid_print

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'codegen.g.dart';

@riverpod
int other(Ref ref) => 0;

/* SNIPPET START */
@riverpod
int example(Ref ref) {
  ref.listen(otherProvider, (previous, next) {
    print('Changed from: $previous, next: $next');
  });

  return 0;
}
