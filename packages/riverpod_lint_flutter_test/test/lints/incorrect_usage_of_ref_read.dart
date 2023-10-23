import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'incorrect_usage_of_ref_read.g.dart';

final aProvider = Provider<int>((ref) => 0);

@riverpod
int b(BRef ref) => 0;

final nonCodeGenFunctionalProvider = Provider<int>((ref) {
  // expect_lint: incorrect_usage_of_ref_read
  ref.read(aProvider);
  return 0;
});

class NonCodeGenNotifier extends Notifier<int> {
  @override
  int build() {
    // expect_lint: incorrect_usage_of_ref_read
    ref.read(aProvider);
    return 0;
  }

  void method() {
    // using ref.read in methods is fine
    ref.read(aProvider);
  }
}

@riverpod
int codeGenFunctionalProvider(CodeGenFunctionalProviderRef ref) {
  // expect_lint: incorrect_usage_of_ref_read
  ref.read(bProvider);
  return 0;
}

@riverpod
class CodeGenNotifier extends _$CodeGenNotifier {
  @override
  int build() {
    // expect_lint: incorrect_usage_of_ref_read
    ref.read(bProvider);
    return 0;
  }

  void method() {
    // using ref.read in methods is fine
    ref.read(bProvider);
  }
}
