import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'family_fn.g.dart';

/* SNIPPET START */
@riverpod
String example(
  Ref ref,
  int param1, {
  String param2 = 'foo',
}) {
  return 'Hello $param1 & $param2';
}
