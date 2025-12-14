// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
// [wrap_with_consumer?offset=715,729]
// ```
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
// -     return ElevatedButton(
// -       onPressed: () => onSaved?.call(),
// -       child: const Placeholder(),
// -     );
// +     return Consumer(builder: (context, ref, child) { return ElevatedButton(
// +       onPressed: () => onSaved?.call(),
// +       child: const Placeholder(),
// +     ); },);
//   }
// }
// ```
@TestFor.wrap_with_consumer
@TestFor.wrap_with_provider_scope
library;

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../test_annotation.dart';

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
