import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/* SNIPPET START */

final counterProvider = StateProvider<int>((ref) => 0);

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          /* highlight-start */
          ref.read(counterProvider.notifier).update((state) => state + 1);
          /* highlight-end */
        },
      ),
    );
  }
}