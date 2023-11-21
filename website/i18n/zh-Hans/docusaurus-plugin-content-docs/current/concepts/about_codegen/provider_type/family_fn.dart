import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'family_fn.g.dart';

/* SNIPPET START */
@riverpod
String example(
  ExampleRef ref,
  int param1, {
  String param2 = 'foo',
}) {
  return 'Hello $param1 & param2';
}
