// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
// Offsets for "notifier_build":
// 16: // ignore: riverpod_lint/notifier_build
// 17: class <>ExampleProvider1 extends _$ExampleProvider1 {}
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
//
// @riverpod
// ```
@TestFor.notifier_build
library;

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../test_annotation.dart';

/// Fake Provider
typedef _$ExampleProvider1 = Object;

/// Fake Provider
typedef _$ExampleProvider = Notifier<int>;

@riverpod
// ignore: riverpod_lint/notifier_build
class ExampleProvider1 extends _$ExampleProvider1 {
  @override
  dynamic build() {
    // TODO: implement build
    throw UnimplementedError();
  }
}

@riverpod
class ExampleProvider extends _$ExampleProvider {
  @override
  int build() => 0;
}
