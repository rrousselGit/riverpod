import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'async_class_stream.g.dart';

/* SNIPPET START */
@riverpod
class Example extends _$Example {
  @override
  Stream<String> build() async* {
    yield 'foo';
  }

  // 添加改变状态的方法
}
