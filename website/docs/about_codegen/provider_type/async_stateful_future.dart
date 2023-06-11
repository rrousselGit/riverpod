import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'async_stateful_future.g.dart';

/* SNIPPET START */
@riverpod
class Example extends _$Example {
  @override
  Future<String> build() async {
    return Future.value('Hello World');
  }

//Add other methods that can mutate the state.
}
