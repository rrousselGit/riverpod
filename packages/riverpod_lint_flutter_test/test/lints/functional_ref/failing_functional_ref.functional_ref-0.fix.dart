// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
// [functional_ref?offset=190,197]
// ```
// @riverpod
// // ignore: riverpod_lint/functional_ref
// - int refless() {
// + int refless(Ref ref) {
//   return 0;
// }
// ```
@TestFor.functional_ref
library;

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../test_annotation.dart';

@riverpod
// ignore: riverpod_lint/functional_ref
int refless(Ref ref) {
  return 0;
}

@riverpod
int incorrectlyTyped(
  // ignore: riverpod_lint/functional_ref
  int ref,
) {
  return 0;
}

// Regression test for https://github.com/rrousselGit/riverpod/issues/2689
@riverpod
// ignore: riverpod_lint/functional_ref
int noRefButArgs({int a = 42}) {
  return 0;
}

@riverpod
int valid(Ref ref) => 0;
