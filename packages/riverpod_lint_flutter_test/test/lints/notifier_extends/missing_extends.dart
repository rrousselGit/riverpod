@TestFor.notifier_extends
library;

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../test_annotation.dart';

// ignore: uri_has_not_been_generated, fixes will get their .g.dart
part 'incorrect_extends.g.dart';

@riverpod
// ignore: riverpod_lint/notifier_extends
class NoExtends {
  int build() => 0;
}
