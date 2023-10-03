import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'incorrect_usage_of_ref_listen.g.dart';

final aProvider = Provider<int>((ref) => 0);

@riverpod
int b(BRef ref) => 0;

final nonCodeGenFunctionalProvider = Provider<int>((ref) {
  // using ref.listen in providers is fine
  ref.listen(aProvider, (previous, next) {});
  return 0;
});

class NonCodeGenNotifier extends Notifier<int> {
  @override
  int build() {
    // using ref.listen in build is fine
    ref.listen(aProvider, (previous, next) {});
    return 0;
  }

  void someMethod() {
    // expect_lint: incorrect_usage_of_ref_listen
    ref.listen(aProvider, (previous, next) {});
  }
}

@riverpod
int codeGenFunctionalProvider(CodeGenFunctionalProviderRef ref) {
  // using ref.listen in build is fine
  ref.listen(bProvider, (previous, next) {});
  return 0;
}

@riverpod
class CodeGenNotifier extends _$CodeGenNotifier {
  @override
  int build() {
    // using ref.listen in build is fine
    ref.listen(bProvider, (previous, next) {});
    return 0;
  }

  void someMethod() {
    // expect_lint: incorrect_usage_of_ref_listen
    ref.listen(bProvider, (previous, next) {});
  }
}
