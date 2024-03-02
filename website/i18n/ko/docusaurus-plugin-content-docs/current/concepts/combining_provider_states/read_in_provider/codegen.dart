import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'codegen.g.dart';

@riverpod
MyValue another(AnotherRef ref) => MyValue();

class MyValue {}

/* SNIPPET START */

@riverpod
MyValue my(MyRef ref) {
  // Bad practice to call `read` here
  final value = ref.read(anotherProvider);
  return value;
}
