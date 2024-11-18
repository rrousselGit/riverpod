import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'codegen.g.dart';

@riverpod
MyValue another(Ref ref) => MyValue();

class MyValue {}

/* SNIPPET START */

@riverpod
MyValue my(Ref ref) {
  // Bad practice to call `read` here
  final value = ref.read(anotherProvider);
  return value;
}
