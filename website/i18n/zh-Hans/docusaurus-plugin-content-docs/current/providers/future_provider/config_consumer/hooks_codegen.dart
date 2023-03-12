import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../config_provider/codegen.dart';



/* SNIPPET START */

class MyConfigration extends HookConsumerWidget  {
  const MyConfigration({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(fetchConfigrationProvider);
    return Scaffold(
      body: config.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
      data: (config) {
        return Center(child: Text(config.host));
      },
    ));
  }
}