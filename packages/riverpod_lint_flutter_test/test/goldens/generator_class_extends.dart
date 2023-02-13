import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generator_class_extends.g.dart';

@riverpod
class MyNotifier extends _$MyNotifier {
  int build() => 0;
}

@riverpod
// expect_lint: generator_class_extends
class NoExtends {
  int build() => 0;
}

@riverpod
// expect_lint: generator_class_extends
class WrongExtends extends AsyncNotifier<int> {
  int build() => 0;
}

// Regression test for https://github.com/rrousselGit/riverpod/issues/2165
@riverpod
class _PrivateClass extends _$PrivateClass {
  @override
  String build() => 'Hello World!';
}
