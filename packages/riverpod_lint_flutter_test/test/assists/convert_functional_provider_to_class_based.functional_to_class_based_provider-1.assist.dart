// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
// [functional_to_class_based_provider?offset=311,298]
// ```
// /// Some comment
// @riverpod
// - int exampleFamily(Ref ref, {required int a, String b = '42'}) {
// -   // Hello world
// -   return 0;
// + class ExampleFamily extends _$ExampleFamily {
// +   @override
// +   int build({required int a, String b = '42'}) {
// +   // Hello world
// +   return 0;
// + }
// }
// ```
@TestFor.functional_to_class_based_provider
library;

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../test_annotation.dart';

part 'convert_functional_provider_to_class_based.functional_to_class_based_provider-1.assist.g.dart';

/// Some comment
@riverpod
int example(Ref ref) => 0;

/// Some comment
@riverpod
class ExampleFamily extends _$ExampleFamily {
  @override
  int build({required int a, String b = '42'}) {
    // Hello world
    return 0;
  }
}
