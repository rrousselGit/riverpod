// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning, todo
// Offsets for "functional_ref":
// 10:   // ignore: riverpod_lint/functional_ref
// 11:   <>r<>.<>AsyncValue<><<>int<>> ref,
// 12: ) {
// ```
// int prefixedWrongType(
//   // ignore: riverpod_lint/functional_ref
// -   r.AsyncValue<int> ref,
// +   r.Ref  ref,
// ) {
//   return 0;
// ```
@TestFor.functional_ref
library;

import 'package:riverpod_annotation/riverpod_annotation.dart' as r;

import '../../test_annotation.dart';

@r.riverpod
int prefixedWrongType(
  // ignore: riverpod_lint/functional_ref
  r.Ref ref,
) {
  return 0;
}
