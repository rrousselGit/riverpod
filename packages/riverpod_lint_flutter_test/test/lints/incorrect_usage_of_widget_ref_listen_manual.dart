// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final provider = Provider<int>((ref) => 0);

class Example extends ConsumerStatefulWidget {
  const Example({super.key});

  @override
  ConsumerState<Example> createState() => _ExampleState();
}

class _ExampleState extends ConsumerState<Example> {
  ProviderSubscription<int>? _subA;
  ProviderSubscription<int>? _subB;
  ProviderSubscription<int>? _subC;

  @override
  void initState() {
    super.initState();
    ref.listenManual(provider, (previous, next) {});
  }

  void someMethod() {
    ref.listenManual(provider, (previous, next) {});
  }

  @override
  Widget build(BuildContext context) {
    // using ref.listenManual in build and properly closing the returned
    // subscription is fine
    _subA?.close();
    _subA = ref.listenManual(provider, (previous, next) {});

    // using ref.listenManual in build without closing the returned subscription
    // properly triggers the lint
    // expect_lint: incorrect_usage_of_widget_ref_listen_manual
    _subB = ref.listenManual(provider, (previous, next) {});
    _subB?.close();

    // expect_lint: incorrect_usage_of_widget_ref_listen_manual
    _subC = ref.listenManual(provider, (previous, next) {});

    // expect_lint: incorrect_usage_of_widget_ref_listen_manual
    ref.listenManual(provider, (previous, next) {});

    void nestedFunction() {
      ref.listenManual(provider, (previous, next) {});
    }

    return FilledButton(
      onPressed: () {
        ref.listenManual(provider, (previous, next) {});
        nestedFunction();
      },
      child: Placeholder(),
    );
  }
}
