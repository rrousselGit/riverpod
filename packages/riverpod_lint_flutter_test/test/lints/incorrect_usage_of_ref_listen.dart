// ignore_for_file: unused_field

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'incorrect_usage_of_ref_listen.g.dart';

final aProvider = Provider<int>((ref) => 0);

@riverpod
int b(BRef ref) => 0;

final nonCodeGenFunctionalProvider = Provider<int>((ref) {
  // using ref.listen in function providers is fine
  ref.listen(aProvider, (previous, next) {});
  return 0;
});

class NonCodeGenNotifier extends Notifier<int> {
  ProviderSubscription<int>? _subA;
  ProviderSubscription<int>? _subB;
  ProviderSubscription<int>? _subC;

  @override
  int build() {
    // using ref.listen in build is fine
    ref.listen(aProvider, (previous, next) {});
    return 0;
  }

  void method() {
    // using ref.listen in methods and properly closing the returned subscription
    // is fine
    _subA?.close();
    _subA = ref.listen(aProvider, (previous, next) {});

    // using ref.listen in methods without closing the returned subscription
    // properly triggers the lint
    // expect_lint: incorrect_usage_of_ref_listen
    _subB = ref.listen(aProvider, (previous, next) {});
    _subB?.close();

    // expect_lint: incorrect_usage_of_ref_listen
    _subC = ref.listen(aProvider, (previous, next) {});

    // expect_lint: incorrect_usage_of_ref_listen
    ref.listen(aProvider, (previous, next) {});
  }
}

@riverpod
int codeGenFunctionalProvider(CodeGenFunctionalProviderRef ref) {
  // using ref.listen in functional providers is fine
  ref.listen(bProvider, (previous, next) {});
  return 0;
}

@riverpod
class CodeGenNotifier extends _$CodeGenNotifier {
  ProviderSubscription<int>? _subA;
  ProviderSubscription<int>? _subB;
  ProviderSubscription<int>? _subC;

  @override
  int build() {
    // using ref.listen in build is fine
    ref.listen(bProvider, (previous, next) {});
    return 0;
  }

  void method() {
    // using ref.listen in methods and properly closing the returned subscription
    // is fine
    _subA?.close();
    _subA = ref.listen(bProvider, (previous, next) {});

    // using ref.listen in methods without closing the returned subscription
    // properly triggers the lint
    // expect_lint: incorrect_usage_of_ref_listen
    _subB = ref.listen(bProvider, (previous, next) {});
    _subB?.close();

    // expect_lint: incorrect_usage_of_ref_listen
    _subC = ref.listen(bProvider, (previous, next) {});

    // expect_lint: incorrect_usage_of_ref_listen
    ref.listen(bProvider, (previous, next) {});
  }
}
