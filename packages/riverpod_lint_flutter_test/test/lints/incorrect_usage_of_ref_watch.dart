import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'incorrect_usage_of_ref_watch.g.dart';

final aProvider = Provider<int>((ref) => 0);

@riverpod
int b(BRef ref) => 0;

final nonCodeGenFunctionalProvider = Provider<int>((ref) {
  // using ref.watch in providers is fine
  ref.watch(aProvider);
  return 0;
});

class NonCodeGenNotifier extends Notifier<int> {
  @override
  int build() {
    // using ref.watch in build is fine
    ref.watch(aProvider);
    return 0;
  }

  void someMethod() {
    // expect_lint: incorrect_usage_of_ref_watch
    ref.watch(aProvider);
  }
}

@riverpod
int codeGenFunctionalProvider(CodeGenFunctionalProviderRef ref) {
  // using ref.watch in build is fine
  ref.watch(bProvider);
  return 0;
}

@riverpod
class CodeGenNotifier extends _$CodeGenNotifier {
  @override
  int build() {
    // using ref.watch in build is fine
    ref.watch(bProvider);
    return 0;
  }

  void someMethod() {
    // expect_lint: incorrect_usage_of_ref_watch
    ref.watch(bProvider);
  }
}
