// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'reading_counter.dart';

class HomeView extends HookConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(

      /* SNIPPET START */
      body: HookConsumer(
        builder: (context, ref, child) {
          // Comme HookConsumerWidget, on peut utiliser des hooks dans le builder.
          final state = useState(0);

          // On peut également utiliser le paramètre ref pour écouter les providers.
          final counter = ref.watch(counterProvider);
          return Text('$counter');
        },
      ),
    );
  }
    /* SNIPPET END */
}
