import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'codegen_keep_alive.g.dart';

/* SNIPPET START */
// We can specify "keepAlive" in the annotation to disable
// the automatic state destruction
@Riverpod(keepAlive: true)
int example(ExampleRef ref) {
  return 0;
}
