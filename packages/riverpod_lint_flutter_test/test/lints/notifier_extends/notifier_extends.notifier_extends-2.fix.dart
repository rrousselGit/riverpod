// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
// [notifier_extends?offset=1011,1023,1024,1031,1033,1039]
// ```
// @riverpod
// // ignore: riverpod_lint/notifier_extends
// - class WrongOrder<FirstT, SecondT> extends _$WrongOrder<SecondT, FirstT> {
// + class WrongOrder<FirstT, SecondT> extends _$WrongOrder<FirstT, SecondT> {
//   int build() => 0;
// }
// ```
@TestFor.notifier_extends
library;

// ignore_for_file: internal_lint/generic_name, wrong_number_of_type_arguments
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../test_annotation.dart';

part 'notifier_extends.notifier_extends-2.fix.g.dart';

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
class MissingGenerics<FirstT, SecondT> extends _$MissingGenerics<FirstT> {
  int build() => 0;
}

@riverpod
// ignore: riverpod_lint/notifier_extends
class WrongOrder<FirstT, SecondT> extends _$WrongOrder<FirstT, SecondT> {
  int build() => 0;
}
