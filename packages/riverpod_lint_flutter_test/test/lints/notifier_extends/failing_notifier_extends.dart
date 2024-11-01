import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

@riverpod
// expect_lint: notifier_extends
class NoExtends {
  int build() => 0;
}

@riverpod
// expect_lint: notifier_extends
class WrongExtends extends AsyncNotifier<int> {
  int build() => 0;
}
