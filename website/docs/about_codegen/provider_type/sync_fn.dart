import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sync_fn.g.dart';

/* SNIPPET START */
@riverpod
String example(ExampleRef ref) {
  return 'foo';
}
