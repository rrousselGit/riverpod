// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'incorrect_usage_of_ref_method.g.dart';

final aProvider = Provider<int>((ref) => 0);

@riverpod
int b(BRef ref) => 0;

final nonCodeGenFunctionalProvider = Provider<int>((ref) {
  // using ref.watch in providers is fine
  ref.watch(aProvider);
  // expect_lint: incorrect_usage_of_ref_method
  ref.read(aProvider);
  // using ref.listen in providers is fine
  ref.listen(aProvider, (previous, next) {});
  return 0;
});

class NonCodeGenNotifier extends Notifier<int> {
  // expect_lint: incorrect_usage_of_ref_method
  int get _watchGetter => ref.watch(aProvider);
  // using ref.read in getters is fine
  int get _readGetter => ref.read(aProvider);

  @override
  int build() {
    // using ref.watch in build is fine
    ref.watch(aProvider);
    // expect_lint: incorrect_usage_of_ref_method
    ref.read(aProvider);
    // using ref.listen in build is fine
    ref.listen(aProvider, (previous, next) {});
    return 0;
  }

  void someMethod() {
    // expect_lint: incorrect_usage_of_ref_method
    ref.watch(aProvider);
    // using ref.read in methods is fine
    ref.read(aProvider);
    // expect_lint: incorrect_usage_of_ref_method
    ref.listen(aProvider, (previous, next) {});
  }
}

@riverpod
int codeGenFunctionalProvider(CodeGenFunctionalProviderRef ref) {
  // using ref.watch in build is fine
  ref.watch(bProvider);
  // expect_lint: incorrect_usage_of_ref_method
  ref.read(bProvider);
  // using ref.listen in build is fine
  ref.listen(bProvider, (previous, next) {});
  return 0;
}

@riverpod
class CodeGenNotifier extends _$CodeGenNotifier {
  @override
  int build() {
    // using ref.watch in build is fine
    ref.watch(bProvider);
    // expect_lint: incorrect_usage_of_ref_method
    ref.read(bProvider);
    // using ref.listen in build is fine
    ref.listen(bProvider, (previous, next) {});
    return 0;
  }

  void someMethod() {
    // expect_lint: incorrect_usage_of_ref_method
    ref.watch(bProvider);
    // using ref.read in methods is fine
    ref.read(bProvider);
    // expect_lint: incorrect_usage_of_ref_method
    ref.listen(bProvider, (previous, next) {});
  }
}

class Example extends ConsumerStatefulWidget {
  const Example({super.key});

  @override
  ConsumerState<Example> createState() => _ExampleState();
}

class _ExampleState extends ConsumerState<Example> {
  @override
  void initState() {
    super.initState();
    // expect_lint: incorrect_usage_of_ref_method
    ref.watch(aProvider);
    // using ref.read in initState is fine
    ref.read(aProvider);
    // expect_lint: incorrect_usage_of_ref_method
    ref.listen(aProvider, (previous, next) {});
    // using listenManual in initState is fine
    ref.listenManual(aProvider, (previous, next) {});
  }

  void someMethod() {
    // expect_lint: incorrect_usage_of_ref_method
    ref.watch(aProvider);
    // using ref.read in methods is fine
    ref.read(aProvider);
    // expect_lint: incorrect_usage_of_ref_method
    ref.listen(aProvider, (previous, next) {});
    // using ref.listenManual in methods is fine
    ref.listenManual(aProvider, (previous, next) {});
  }

  @override
  Widget build(BuildContext context) {
    // using ref.watch in build is fine
    ref.watch(aProvider);
    // expect_lint: incorrect_usage_of_ref_method
    ref.read(aProvider);
    // using ref.listen in build is fine
    ref.listen(aProvider, (previous, next) {});
    // expect_lint: incorrect_usage_of_ref_method
    ref.listenManual(aProvider, (previous, next) {});

    return FilledButton(
      onPressed: () {
        // expect_lint: incorrect_usage_of_ref_method
        ref.watch(aProvider);
        // using ref.read in callbacks is fine
        ref.read(aProvider);
        // expect_lint: incorrect_usage_of_ref_method
        ref.listen(aProvider, (previous, next) {});
        // using ref.listenManual in callbacks is fine
        ref.listenManual(aProvider, (previous, next) {});
      },
      child: Placeholder(),
    );
  }
}
