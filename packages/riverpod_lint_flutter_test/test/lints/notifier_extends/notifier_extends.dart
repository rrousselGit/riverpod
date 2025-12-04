@TestFor.notifier_extends
library;

// ignore_for_file: internal_lint/generic_name, wrong_number_of_type_arguments
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../test_annotation.dart';

part 'notifier_extends.g.dart';

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
class WrongOrder<FirstT, SecondT> extends _$WrongOrder<SecondT, FirstT> {
  int build() => 0;
}
