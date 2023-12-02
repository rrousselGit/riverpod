import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'codegen_keep_alive.g.dart';

/* SNIPPET START */
// Possiamo specificare "keepAlive" nell'annotazione per disabilitare
// la distruzione automatica dello stato
@Riverpod(keepAlive: true)
int example(ExampleRef ref) {
  return 0;
}
