// GENERATED CODE - DO NOT MODIFY BY HAND
// [riverpod.convert_to_hookWidget?offset=396,413,402,436,709]

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
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
class MyConsumer extends HookWidget {
  const MyConsumer({super.key, this.onSaved});

  final VoidCallback? onSaved;

  @override
  Widget build(BuildContext context) {
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
