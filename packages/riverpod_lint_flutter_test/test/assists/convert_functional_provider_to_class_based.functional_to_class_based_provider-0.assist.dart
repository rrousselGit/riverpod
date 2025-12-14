// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
// [functional_to_class_based_provider?offset=250,243]
// ```
// /// Some comment
// @riverpod
// - int example(Ref ref) => 0;
// + class Example extends _$Example {
// +   @override
// +   int build() => 0;
// + }
//
// /// Some comment
// ```
@TestFor.functional_to_class_based_provider
library;

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../test_annotation.dart';

part 'convert_functional_provider_to_class_based.functional_to_class_based_provider-0.assist.g.dart';

/// Some comment
@riverpod
class Example extends _$Example {
  @override
  int build() => 0;
}

/// Some comment
@riverpod
int exampleFamily(Ref ref, {required int a, String b = '42'}) {
  // Hello world
  return 0;
}
