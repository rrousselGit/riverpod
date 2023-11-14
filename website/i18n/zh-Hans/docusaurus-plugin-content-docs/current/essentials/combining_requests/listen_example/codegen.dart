// ignore_for_file: unused_local_variable, avoid_print

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'codegen.g.dart';

final otherProvider = Provider<int>((ref) => 0);

/* SNIPPET START */
@riverpod
int example(ExampleRef ref) {
  ref.listen(otherProvider, (previous, next) {
    print('Changed from: $previous, next: $next');
  });

  return 0;
}
