import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'async_stateful_stream.g.dart';

/* SNIPPET START */
@riverpod
class Example extends _$Example {
  @override
  Stream<String> build() async* {
    yield 'Hello World';
  }

//Add other methods that can mutate the state.
}
