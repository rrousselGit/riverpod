// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
// Offsets for "class_based_to_functional_provider":
// 18: @riverpod
// 19: <>class <>ExampleFamily <>extends <>_$ExampleFamily <>{
// 20:   @override
//
// 24:   }
// 25: <>}
// ```
// /// Some comment
// @riverpod
// - class ExampleFamily extends _$ExampleFamily {
// -   @override
// -   int build({required int a, String b = '42'}) {
// -     // Hello world
// -     return 0;
// -   }
// + int exampleFamily(Ref ref, {required int a, String b = '42'}) {
// +     // Hello world
// +     return 0;
// +   }
//
// @riverpod
// ```
@TestFor.class_based_to_functional_provider
library;

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../test_annotation.dart';

part 'convert_class_based_provider_to_functional.class_based_to_functional_provider-1.assist.g.dart';

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

@riverpod
class Generic<FirstT, /* comment */ SecondT>
    extends _$Generic<FirstT, SecondT> {
  @override
  int build() => 0;
}
