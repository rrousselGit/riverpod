import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generator.g.dart';

@riverpod
int simple(SimpleRef ref) => 42;

void fn() {}

/// Hello world
@riverpod
int simpleClass(SimpleClassRef ref) {
  // This is fun
  return 0;
}
