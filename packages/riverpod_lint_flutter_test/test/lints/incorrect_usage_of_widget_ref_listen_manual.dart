import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final provider = Provider<int>((ref) => 0);

class Example extends ConsumerStatefulWidget {
  const Example({super.key});

  @override
  ConsumerState<Example> createState() => _ExampleState();
}

class _ExampleState extends ConsumerState<Example> {
  @override
  void initState() {
    super.initState();
    // using listenManual in initState is fine
    ref.listenManual(provider, (previous, next) {});
  }

  void someMethod() {
    // using ref.listenManual in methods is fine
    ref.listenManual(provider, (previous, next) {});
  }

  @override
  Widget build(BuildContext context) {
    // expect_lint: incorrect_usage_of_widget_ref_listen_manual
    ref.listenManual(provider, (previous, next) {});

    return FilledButton(
      onPressed: () {
        // using ref.listenManual in callbacks is fine
        ref.listenManual(provider, (previous, next) {});
      },
      child: Placeholder(),
    );
  }
}
