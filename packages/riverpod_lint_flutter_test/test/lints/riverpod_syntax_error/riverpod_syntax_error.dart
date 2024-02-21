import 'package:riverpod_annotation/riverpod_annotation.dart';

/// Fake Provider
typedef _$ExampleProvider1 = Object;

@riverpod
// expect_lint: riverpod_syntax_error
abstract class ExampleProvider1 extends _$ExampleProvider1 {
  int build() => 0;
}
