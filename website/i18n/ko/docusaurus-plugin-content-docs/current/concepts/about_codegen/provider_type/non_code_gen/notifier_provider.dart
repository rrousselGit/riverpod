import 'package:flutter_riverpod/flutter_riverpod.dart';

/* SNIPPET START */
final exampleProvider = NotifierProvider.autoDispose<ExampleNotifier, String>(
  ExampleNotifier.new,
);

class ExampleNotifier extends AutoDisposeNotifier<String> {
  @override
  String build() {
    return 'foo';
  }

  // 상태(State) 변경(Mutation)을 위한 메서드 추가
}
