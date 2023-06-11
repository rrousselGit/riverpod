import 'package:flutter_riverpod/flutter_riverpod.dart';

/* SNIPPET START */
final exampleProvider =
    NotifierProvider.autoDispose<ExampleNotifier, String>(() {
  return ExampleNotifier();
});

class ExampleNotifier extends AutoDisposeNotifier<String> {
  @override
  String build() {
    return 'Hello World';
  }

//Add other methods that can mutate the state.
}
