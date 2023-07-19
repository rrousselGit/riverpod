import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'async_fn_stream.g.dart';

/* SNIPPET START */
@riverpod
Stream<String> example(ExampleRef ref) async* {
  yield 'foo';
}
