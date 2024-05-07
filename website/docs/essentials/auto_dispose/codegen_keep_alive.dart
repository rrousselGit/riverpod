import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'codegen_keep_alive.g.dart';

/* SNIPPET START */
// {@template keepAlive}
// We can specify "keepAlive" in the annotation to disable
// the automatic state destruction
// {@endtemplate}
@Riverpod(keepAlive: true)
int example(ExampleRef ref) {
  return 0;
}
