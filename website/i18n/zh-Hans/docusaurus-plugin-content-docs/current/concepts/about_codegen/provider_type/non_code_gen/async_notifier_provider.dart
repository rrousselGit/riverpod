import 'package:flutter_riverpod/flutter_riverpod.dart';

/* SNIPPET START */
final exampleProvider =
    AsyncNotifierProvider.autoDispose<ExampleNotifier, String>(
  ExampleNotifier.new,
);

class ExampleNotifier extends AsyncNotifier<String> {
  @override
  Future<String> build() async {
    return Future.value('foo');
  }

  // 添加改变状态的方法
}
