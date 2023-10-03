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
    // expect_lint: incorrect_usage_of_widget_ref_listen
    ref.listen(provider, (previous, next) {});
  }

  void someMethod() {
    // expect_lint: incorrect_usage_of_widget_ref_listen
    ref.listen(provider, (previous, next) {});
  }

  @override
  Widget build(BuildContext context) {
    // using ref.listen in build is fine
    ref.listen(provider, (previous, next) {});

    return FilledButton(
      onPressed: () {
        // expect_lint: incorrect_usage_of_widget_ref_listen
        ref.listen(provider, (previous, next) {});
      },
      child: Placeholder(),
    );
  }
}
