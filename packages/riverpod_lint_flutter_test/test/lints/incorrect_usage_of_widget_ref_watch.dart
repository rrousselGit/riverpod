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
    // expect_lint: incorrect_usage_of_widget_ref_watch
    ref.watch(provider);
  }

  void someMethod() {
    // expect_lint: incorrect_usage_of_widget_ref_watch
    ref.watch(provider);
  }

  @override
  Widget build(BuildContext context) {
    // using ref.watch in build is fine
    ref.watch(provider);

    return FilledButton(
      onPressed: () {
        // expect_lint: incorrect_usage_of_widget_ref_watch
        ref.watch(provider);
      },
      child: Placeholder(),
    );
  }
}
