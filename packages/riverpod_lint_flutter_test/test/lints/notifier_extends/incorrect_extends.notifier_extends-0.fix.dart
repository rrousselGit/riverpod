// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
// [notifier_extends?offset=319]
// ```
// @riverpod
// // ignore: riverpod_lint/notifier_extends
// - class WrongExtends extends Object {
// + class WrongExtends extends _$WrongExtends {
//   int build() => 0;
// }
// ```
@TestFor.notifier_extends
library;

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../test_annotation.dart';

// ignore: uri_has_not_been_generated, fixes will get their .g.dart
part 'incorrect_extends.notifier_extends-0.fix.g.dart';

@riverpod
// ignore: riverpod_lint/notifier_extends
class WrongExtends extends _$WrongExtends {
  int build() => 0;
}
