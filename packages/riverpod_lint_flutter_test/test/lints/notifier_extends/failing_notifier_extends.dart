@TestFor.notifier_extends
library;

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../test_annotation.dart';

@riverpod
// ignore: riverpod_lint/notifier_extends
class NoExtends {
  int build() => 0;
}

@riverpod
// ignore: riverpod_lint/notifier_extends
class WrongExtends extends AsyncNotifier<int> {
  int build() => 0;
}
