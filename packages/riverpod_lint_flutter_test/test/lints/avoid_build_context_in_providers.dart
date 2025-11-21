// ignore_for_file: unused_element

import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'avoid_build_context_in_providers.g.dart';

@riverpod
int fn(
  Ref ref,
  // ignore: riverpod_lint/avoid_build_context_in_providers
  BuildContext context1, {
  // ignore: riverpod_lint/avoid_build_context_in_providers
  required BuildContext context2,
}) => 0;

@riverpod
class MyNotifier extends _$MyNotifier {
  int build(
    // ignore: riverpod_lint/avoid_build_context_in_providers
    BuildContext context1, {
    // ignore: riverpod_lint/avoid_build_context_in_providers
    required BuildContext context2,
  }) => 0;

  void event(
    // ignore: riverpod_lint/avoid_build_context_in_providers
    BuildContext context3, {
    // ignore: riverpod_lint/avoid_build_context_in_providers
    required BuildContext context4,
  }) {}
}

@riverpod
class Regression2959 extends _$Regression2959 {
  @override
  void build() {}

  bool get _valid => false;
}
