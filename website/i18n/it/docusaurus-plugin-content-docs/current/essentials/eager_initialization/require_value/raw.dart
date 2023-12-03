// ignore_for_file: unused_local_variable, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/* SNIPPET START */
// Un provider inizializzato anticipatamente.
final exampleProvider = FutureProvider<String>((ref) async => 'Hello world');

class MyConsumer extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final result = ref.watch(exampleProvider);

    // Se il provider è stato correttamente inizializzato anticipatamente, allora puoi
    // direttamente leggere il dato con "requireValue".
    return Text(result.requireValue);
  }
}
/* SNIPPET END */
