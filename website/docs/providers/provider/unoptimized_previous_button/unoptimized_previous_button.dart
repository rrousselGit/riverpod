// A provider that controls the current page
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

/* SNIPPET START */

@riverpod
int pageIndex(PageIndexRef ref) {
  return 0;
}

class PreviousButton extends ConsumerWidget {
  const PreviousButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // if not on first page, the previous button is active
    final canGoToPreviousPage = ref.watch(pageIndexProvider) != 0;

    void goToPreviousPage() {
      ref.read(pageIndexProvider.notifier).update((state) => state - 1);
    }

    return ElevatedButton(
      onPressed: canGoToPreviousPage ? goToPreviousPage : null,
      child: const Text('previous'),
    );
  }
}
