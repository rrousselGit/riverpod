// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
// Offsets for "notifier_extends":
// 12: // ignore: riverpod_lint/notifier_extends
// 13: class <>NoExtends {
// 14:   int build() => 0;
// ```
// @riverpod
// // ignore: riverpod_lint/notifier_extends
// - class NoExtends {
// + class NoExtends extends _$NoExtends {
//   int build() => 0;
// }
// ```
@TestFor.notifier_extends
library;

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../test_annotation.dart';

// ignore: uri_has_not_been_generated, fixes will get their .g.dart
part 'incorrect_extends.g.dart';

@riverpod
// ignore: riverpod_lint/notifier_extends
class NoExtends extends _$NoExtends {
  int build() => 0;
}
