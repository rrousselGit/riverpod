// Un provider che controlla la pagina corrente
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/* SNIPPET START */

final pageIndexProvider = StateProvider<int>((ref) => 0);

// Un provider che calcola se l'utente è abilitato ad andare alla pagina precedente

/* highlight-start */
final canGoToPreviousPageProvider = Provider<bool>((ref) {
/* highlight-end */
  return ref.watch(pageIndexProvider) == 0;
});

class PreviousButton extends ConsumerWidget {
  const PreviousButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Ora osserviamo il nostro nuovo Provider
    // Il nostro widget non calcolerà più se possiamo andare alla pagina precedente.
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
