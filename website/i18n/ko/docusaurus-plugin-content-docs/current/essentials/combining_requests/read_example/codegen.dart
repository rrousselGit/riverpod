// ignore_for_file: unused_local_variable
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'codegen.g.dart';

@riverpod
int other(OtherRef ref) => 0;

/* SNIPPET START */
@riverpod
class MyNotifier extends _$MyNotifier {
  @override
  int build() {
    // Bad! 여기서는 reactive가 아니므로 'read'를 사용하지 마세요.
    ref.read(otherProvider);

    return 0;
  }

  void increment() {
    ref.read(otherProvider); // 여기서 'read'를 사용해도 괜찮습니다.
  }
}
