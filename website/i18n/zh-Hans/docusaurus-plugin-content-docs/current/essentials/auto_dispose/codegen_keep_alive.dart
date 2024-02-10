import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'codegen_keep_alive.g.dart';

/* SNIPPET START */
// 我们可以在注解中指定 "keepAlive" 来禁用状态自动处置功能
@Riverpod(keepAlive: true)
int example(ExampleRef ref) {
  return 0;
}
