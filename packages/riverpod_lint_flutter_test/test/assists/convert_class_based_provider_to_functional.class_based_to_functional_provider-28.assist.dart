// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
// Offsets for "class_based_to_functional_provider":
// 27: @riverpod
// 28: <>class <>Generic<><<>FirstT<>, /* comment */ <>SecondT<>>
// 29:     extends _$Generic<FirstT, SecondT> {
// 28: class Generic<FirstT, /* comment */ SecondT>
// 29:     <>extends <>_$Generic<><<>FirstT<>, <>SecondT<>> <>{
// 30:   @override
// 31:   int build() => 0;
// 32: <>}
// ```
//
// @riverpod
// - class Generic<FirstT, /* comment */ SecondT>
// -     extends _$Generic<FirstT, SecondT> {
// -   @override
// -   int build() => 0;
// - }
// + int generic<FirstT, /* comment */ SecondT>(Ref ref) => 0;
// ```
@TestFor.class_based_to_functional_provider
library;

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../test_annotation.dart';

part 'convert_class_based_provider_to_functional.class_based_to_functional_provider-28.assist.g.dart';

/// Some comment
@riverpod
class Example extends _$Example {
  @override
  int build() => 0;
}

/// Some comment
@riverpod
class ExampleFamily extends _$ExampleFamily {
  @override
  int build({required int a, String b = '42'}) {
    // Hello world
    return 0;
  }
}

@riverpod
int generic<FirstT, /* comment */ SecondT>(Ref ref) => 0;
