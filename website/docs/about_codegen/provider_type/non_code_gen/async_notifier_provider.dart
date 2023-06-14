import 'package:flutter_riverpod/flutter_riverpod.dart';

/* SNIPPET START */
final exampleProvider =
    AsyncNotifierProvider.autoDispose<ExampleNotifier, String>(() {
  return ExampleNotifier();
});

class ExampleNotifier extends AutoDisposeAsyncNotifier<String> {
  @override
  Future<String> build() async {
    return Future.value('Hello World');
  }

//Add methods to mutate the state
}
