// ignore_for_file: omit_local_variable_types, prefer_final_locals

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/* SNIPPET START */

/// A counter that is being incremented by each [CounterDisplay]'s ElevatedButton
final counterProvider = StateProvider(
  (ref) => 0,
);

final adjustedCountProvider = Provider(
  (ref) => ref.watch(counterProvider) * 2,
  // Note that if a provider depends on a provider that is overridden for a subtree,
  // you must explicitly list that provider in your dependencies list.
  dependencies: [counterProvider],
);

class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        body: Column(
      children: [
        ProviderScope(
          /// Just specify which provider you want to have a copy of in the subtree
          ///
          /// Note that dependant providers such as [adjustedCountProvider] will
          /// also be copied for this subtree. If that is not the behavior you want,
          /// consider using families instead
          overrides: [counterProvider],
          child: const CounterDisplay(),
        ),
        ProviderScope(
          // You can change the provider's behavior in a particular subtree
          overrides: [counterProvider.overrideWith((ref) => 1)],
          child: const CounterDisplay(),
        ),
        ProviderScope(
          overrides: [
            counterProvider,
            // You can also change dependent provider's behaviors
            adjustedCountProvider.overrideWith(
              (ref) => ref.watch(counterProvider) * 3,
            ),
          ],
          child: const CounterDisplay(),
        ),
        // This particular display will use the provider state from the root ProviderScope
        const CounterDisplay(),
      ],
    ));
  }
}

class CounterDisplay extends ConsumerWidget {
  const CounterDisplay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('$count'),
        ElevatedButton(
          onPressed: () {
            ref.read(counterProvider.notifier).state++;
          },
          child: const Text('Increment Count'),
        ),
      ],
    );
  }
}
