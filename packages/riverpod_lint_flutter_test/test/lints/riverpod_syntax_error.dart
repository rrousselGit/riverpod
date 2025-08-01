import 'package:riverpod_annotation/riverpod_annotation.dart';

/// Fake Provider
typedef _$ExampleProvider1 = Object;

// expect_lint: riverpod_syntax_error
@riverpod
abstract class ExampleProvider1 extends _$ExampleProvider1 {
  int build() => 0;
}
