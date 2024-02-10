import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sync_class.g.dart';

/* SNIPPET START */
@riverpod
class Example extends _$Example {
  @override
  String build() {
    return 'foo';
  }

  // 添加改变状态的方法
}
