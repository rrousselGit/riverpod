// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
// Offsets for "notifier_extends":
// 36: // ignore: riverpod_lint/notifier_extends
// 37: class MissingGenerics<FirstT, SecondT> extends <>_$MissingGenerics<><<>FirstT<>> {
// 38:   int build() => 0;
// ```
// @riverpod
// // ignore: riverpod_lint/notifier_extends
// - class MissingGenerics<FirstT, SecondT> extends _$MissingGenerics<FirstT> {
// + class MissingGenerics<FirstT, SecondT> extends _$MissingGenerics<FirstT, SecondT> {
//   int build() => 0;
// }
// ```
@TestFor.notifier_extends
library;

// ignore_for_file: internal_lint/generic_name, wrong_number_of_type_arguments
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../test_annotation.dart';

part 'notifier_extends.notifier_extends-1.fix.g.dart';

@riverpod
class MyNotifier extends _$MyNotifier {
  int build() => 0;
}

// Regression test for https://github.com/rrousselGit/riverpod/issues/2165
@riverpod
class _PrivateClass extends _$PrivateClass {
  @override
  String build() => 'Hello World!';
}

@riverpod
class Generics<FirstT extends num, SecondT>
    extends _$Generics<FirstT, SecondT> {
  int build() => 0;
}

@riverpod
// ignore: riverpod_lint/notifier_extends
class NoGenerics<FirstT extends num, SecondT> extends _$NoGenerics {
  int build() => 0;
}

@riverpod
// ignore: riverpod_lint/notifier_extends
class MissingGenerics<FirstT, SecondT>
    extends _$MissingGenerics<FirstT, SecondT> {
  int build() => 0;
}

@riverpod
// ignore: riverpod_lint/notifier_extends
class WrongOrder<FirstT, SecondT> extends _$WrongOrder<SecondT, FirstT> {
  int build() => 0;
}
