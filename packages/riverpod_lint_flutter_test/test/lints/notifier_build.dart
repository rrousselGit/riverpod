import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

/// Fake Provider
typedef _$ExampleProvider1 = Object;

/// Fake Provider
typedef _$ExampleProvider = Notifier<int>;

@riverpod
// expect_lint: notifier_build
class ExampleProvider1 extends _$ExampleProvider1 {}

@riverpod
class ExampleProvider extends _$ExampleProvider {
  @override
  int build() => 0;
}
