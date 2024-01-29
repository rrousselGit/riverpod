import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'codegen_keep_alive.g.dart';

/* SNIPPET START */
// 어노테이션에 "keepAlive"를 지정하여
// 자동 상태 소멸을 비활성화할 수 있습니다.
@Riverpod(keepAlive: true)
int example(ExampleRef ref) {
  return 0;
}
