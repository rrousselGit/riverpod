// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Possiamo specificare autoDispose per abilitare la distruzione automatica dello stato.
final someProvider = Provider.autoDispose<int>((ref) {
  return 0;
});

/* SNIPPET START */
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () {
        // Sul click, distruggiamo il provider.
        ref.invalidate(someProvider);
      },
      child: const Text('dispose a provider'),
    );
  }
}
