// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning, todo
// Offsets for "notifier_build":
// 12: // ignore: riverpod_lint/notifier_build
// 13: class <>ExampleProvider1 extends _$ExampleProvider1 {}
// ```
// @riverpod
// // ignore: riverpod_lint/notifier_build
// - class ExampleProvider1 extends _$ExampleProvider1 {}
// + class ExampleProvider1 extends _$ExampleProvider1 {
// +   @override
// +   dynamic build() {
// +     // TODO: implement build
// +     throw UnimplementedError();
// +   }
// + }
// ```
@TestFor.notifier_build
library;

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../test_annotation.dart';

/// Fake Provider
typedef _$ExampleProvider1 = Object;

@riverpod
// ignore: riverpod_lint/notifier_build
class ExampleProvider1 extends _$ExampleProvider1 {
  @override
  dynamic build() {
    // TODO: implement build
    throw UnimplementedError();
  }
}
