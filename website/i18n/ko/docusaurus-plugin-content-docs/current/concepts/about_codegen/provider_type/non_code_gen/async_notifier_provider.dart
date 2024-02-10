import 'package:flutter_riverpod/flutter_riverpod.dart';

/* SNIPPET START */
final exampleProvider = AsyncNotifierProvider.autoDispose<ExampleNotifier, String>(
  ExampleNotifier.new,
);

class ExampleNotifier extends AutoDisposeAsyncNotifier<String> {
  @override
  Future<String> build() async {
    return Future.value('foo');
  }

  // 상태(State) 변경(Mutation)을 위한 메서드 추가
}
