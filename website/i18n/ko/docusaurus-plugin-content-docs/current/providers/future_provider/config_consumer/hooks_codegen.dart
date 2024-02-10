import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../config_provider/codegen.dart';

/* SNIPPET START */

class MyConfiguration extends HookConsumerWidget {
  const MyConfiguration({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(fetchConfigurationProvider);
    return Scaffold(
      body: config.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (config) {
          return Center(child: Text(config.host));
        },
      ),
    );
  }
}
