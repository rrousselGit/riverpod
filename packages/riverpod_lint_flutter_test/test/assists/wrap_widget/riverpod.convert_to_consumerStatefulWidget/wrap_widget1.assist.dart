// GENERATED CODE - DO NOT MODIFY BY HAND
// [riverpod.convert_to_consumerStatefulWidget?offset=396,413,402,436,709]

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
class MyConsumer extends ConsumerStatefulWidget {
  const MyConsumer({super.key, this.onSaved});

  final VoidCallback? onSaved;

  @override
  ConsumerState<MyConsumer> createState() => _MyConsumerState();
}

class _MyConsumerState extends ConsumerState<MyConsumer> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => widget.onSaved?.call(),
      child: const Placeholder(),
    );
  }
}

// Regression test for https://github.com/rrousselGit/riverpod/discussions/2168#discussioncomment-4957220
final provider = Provider((ref) {
  final VoidCallback? onSaved = null;
  onSaved?.call();
});
