// Ein Provider, der die aktuelle Seite kontrolliert
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/* SNIPPET START */

final pageIndexProvider = StateProvider<int>((ref) => 0);

class PreviousButton extends ConsumerWidget {
  const PreviousButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Wenn nicht auf der ersten Seite, dann ist der previous Knopf aktiv
    final canGoToPreviousPage = ref.watch(pageIndexProvider) == 0;

    void goToPreviousPage() {
      ref.read(pageIndexProvider.notifier).update((state) => state - 1);
    }

    return ElevatedButton(
      onPressed: canGoToPreviousPage ? goToPreviousPage : null,
      child: const Text('previous'),
    );
  }
}
