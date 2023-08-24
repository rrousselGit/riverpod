import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notifier_build.g.dart';

@riverpod
// expect_lint: notifier_build
class ExampleProvider1 {}

@riverpod
class ExampleProvider extends _$ExampleProvider {
  @override
  int build() => 0;
}
