import 'package:flutter_riverpod/flutter_riverpod.dart';

/* SNIPPET START */
final exampleProvider =
    StreamNotifierProvider.autoDispose<ExampleNotifier, String>(() {
  return ExampleNotifier();
});

class ExampleNotifier extends AutoDisposeStreamNotifier<String> {
  @override
  Stream<String> build() async* {
    yield 'Hello World';
  }

//Add other methods that can mutate the state.
}
