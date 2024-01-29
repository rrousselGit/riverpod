import 'package:flutter_riverpod/flutter_riverpod.dart';

/* SNIPPET START */
final exampleProvider = StreamNotifierProvider.autoDispose<ExampleNotifier, String>(() {
  return ExampleNotifier();
});

class ExampleNotifier extends AutoDisposeStreamNotifier<String> {
  @override
  Stream<String> build() async* {
    yield 'foo';
  }

  // 상태(State) 변경(Mutation)을 위한 메서드 추가
}
