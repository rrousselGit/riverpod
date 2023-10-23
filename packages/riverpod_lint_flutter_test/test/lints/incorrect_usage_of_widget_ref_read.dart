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
    // using ref.read in initState is fine
    ref.read(provider);
  }

  void method() {
    // using ref.read in methods is fine
    ref.read(provider);
  }

  @override
  Widget build(BuildContext context) {
    // expect_lint: incorrect_usage_of_widget_ref_read
    ref.read(provider);

    return FilledButton(
      onPressed: () {
        // using ref.read in callbacks is fine
        ref.read(provider);
      },
      child: Placeholder(),
    );
  }
}
