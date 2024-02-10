// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// We can specify autoDispose to enable automatic state destruction.
final someProvider = Provider.autoDispose<int>((ref) {
  return 0;
});

/* SNIPPET START */
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () {
        // 点击后，处置提供者程序。
        ref.invalidate(someProvider);
      },
      child: const Text('dispose a provider'),
    );
  }
}
