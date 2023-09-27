import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'avoid_passing_build_context_to_providers.g.dart';

@riverpod
int fn(
  FnRef ref,
  // expect_lint: avoid_passing_build_context_to_providers
  BuildContext context1, {
  // expect_lint: avoid_passing_build_context_to_providers
  required BuildContext context2,
}) =>
    0;

@riverpod
class MyNotifier extends _$MyNotifier {
  int build(
    // expect_lint: avoid_passing_build_context_to_providers
    BuildContext context1, {
    // expect_lint: avoid_passing_build_context_to_providers
    required BuildContext context2,
  }) =>
      0;

  void event(
    // expect_lint: avoid_passing_build_context_to_providers
    BuildContext context3, {
    // expect_lint: avoid_passing_build_context_to_providers
    required BuildContext context4,
  }) {}
}
