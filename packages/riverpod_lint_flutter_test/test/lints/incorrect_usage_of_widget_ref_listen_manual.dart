import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final provider = Provider<int>((ref) => 0);

class Example extends ConsumerStatefulWidget {
  const Example({super.key});

  @override
  ConsumerState<Example> createState() => _ExampleState();
}

class _ExampleState extends ConsumerState<Example> {
  ProviderSubscription<int>? subA;
  ProviderSubscription<int>? subB;
  ProviderSubscription<int>? subC;

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
    // closing the subscription before ref.listenManual is fine
    subA?.close();
    subA = ref.listenManual(provider, (previous, next) {});

    // closing the subscription after ref.listenManual triggers the lint
    // expect_lint: incorrect_usage_of_widget_ref_listen_manual
    subB = ref.listenManual(provider, (previous, next) {});
    subB?.close();

    // not closing the subscription before ref.listenManual triggers the lint
    // expect_lint: incorrect_usage_of_widget_ref_listen_manual
    subC = ref.listenManual(provider, (previous, next) {});

    // expect_lint: incorrect_usage_of_widget_ref_listen_manual
    ref.listenManual(provider, (previous, next) {});

    return FilledButton(
      onPressed: () {
        ref.listenManual(provider, (previous, next) {});
      },
      child: Consumer(
        builder: (context, ref, child) {
          ref.listenManual(provider, (previous, next) {});
          return child!;
        },
        child: Placeholder(),
      ),
    );
  }
}
