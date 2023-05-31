// A provider that controls the current page
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/* SNIPPET START */

final pageIndexProvider = StateProvider<int>((ref) => 0);

// Ein Provider, der berechnet, ob der Benutzer zur vorherigen Seite wechseln darf
/* highlight-start */
final canGoToPreviousPageProvider = Provider<bool>((ref) {
/* highlight-end */
  return ref.watch(pageIndexProvider) == 0;
});

class PreviousButton extends ConsumerWidget {
  const PreviousButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Wir beobachten jetzt unseren neuen Provider.
    // Unser Widget berechnet nicht mehr, ob wir zur vorherigen Seite wechseln können.
/* highlight-start */
    final canGoToPreviousPage = ref.watch(canGoToPreviousPageProvider);
/* highlight-end */

    void goToPreviousPage() {
      ref.read(pageIndexProvider.notifier).update((state) => state - 1);
    }

    return ElevatedButton(
      onPressed: canGoToPreviousPage ? goToPreviousPage : null,
      child: const Text('previous'),
    );
  }
}
