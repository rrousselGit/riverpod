import 'package:riverpod_annotation/riverpod_annotation.dart';

/* SNIPPET START */
@riverpod
String example(
  int param1, {
  String param2 = 'foo',
}) {
  return 'Hello $param1 & param2';
}
