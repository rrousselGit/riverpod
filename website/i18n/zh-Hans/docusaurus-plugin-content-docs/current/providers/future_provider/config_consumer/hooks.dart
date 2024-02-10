import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../config_provider/raw.dart';

/* SNIPPET START */

class MyConfiguration extends HookConsumerWidget {
  const MyConfiguration({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(configProvider);
    return Scaffold(
      body: switch (config) {
        AsyncError(:final error) => Center(child: Text('Error: $error')),
        AsyncData(:final value) => Center(child: Text(value.host)),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}
