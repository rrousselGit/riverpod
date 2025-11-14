// GENERATED CODE - DO NOT MODIFY BY HAND
// [riverpod.convert_to_statefulHookWidget?offset=94,109,100,133,287]

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MyWidget extends StatefulHookWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
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
    return ElevatedButton(
      onPressed: () => onSaved?.call(),
      child: const Placeholder(),
    );
  }
}

// Regression test for https://github.com/rrousselGit/riverpod/discussions/2168#discussioncomment-4957220
final provider = Provider((ref) {
  final VoidCallback? onSaved = null;
  onSaved?.call();
});
