// GENERATED CODE - DO NOT MODIFY BY HAND
// [riverpod.wrap_with_consumer?offset=608,622]

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Map();

    return Scaffold(body: Container());
  }
}

// Regression test for https://github.com/rrousselGit/riverpod/discussions/2168#discussioncomment-4957220
class MyConsumer extends ConsumerWidget {
  const MyConsumer({super.key, this.onSaved});

  final VoidCallback? onSaved;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Consumer(
      builder: (context, ref, child) {
        return ElevatedButton(
          onPressed: () => onSaved?.call(),
          child: const Placeholder(),
        );
      },
    );
  }
}

// Regression test for https://github.com/rrousselGit/riverpod/discussions/2168#discussioncomment-4957220
final provider = Provider((ref) {
  final VoidCallback? onSaved = null;
  onSaved?.call();
});
