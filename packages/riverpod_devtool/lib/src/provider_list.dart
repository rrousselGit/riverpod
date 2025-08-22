import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'elements.dart';
import 'ui.dart';

class ProviderListView extends HookConsumerWidget {
  const ProviderListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController();
    final providerElements = ref.watch(providerElementsProvider);

    return Panel(
      header: const Text('Providers'),
      child: Scrollbar(
        controller: scrollController,
        child: ListView.builder(
          controller: scrollController,
          itemCount: providerElements.value?.length ?? 0,
          itemBuilder: (context, index) {
            final element = providerElements.value!.values.elementAt(index);

            return ListTile(
              title: Text('Provider ${element.displayString}'),
              subtitle: Text('Details for provider $index'),
            );
          },
        ),
      ),
    );
  }
}
