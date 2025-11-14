import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notifier_extends.g.dart';

// ignore_for_file: wrong_number_of_type_arguments

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
class Generics<A extends num, B> extends _$Generics<A, B> {
  int build() => 0;
}

@riverpod
// ignore: riverpod_lint/notifier_extends
class NoGenerics<A extends num, B> extends _$NoGenerics {
  int build() => 0;
}

@riverpod
// ignore: riverpod_lint/notifier_extends
class MissingGenerics<A, B> extends _$MissingGenerics<A> {
  int build() => 0;
}

@riverpod
// ignore: riverpod_lint/notifier_extends
class WrongOrder<A, B> extends _$WrongOrder<B, A> {
  int build() => 0;
}
