// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'reading_counter.dart';

/* SNIPPET START */

class HomeView extends HookConsumerWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // HookConsumerWidget consente l'uso degli hooks all'interno
    // del metodo build.
    final state = useState(0);

    // Possiamo anche usare il parametro ref per ascoltare i provider.
    final counter = ref.watch(counterProvider);
    return Text('$counter');
  }
}
