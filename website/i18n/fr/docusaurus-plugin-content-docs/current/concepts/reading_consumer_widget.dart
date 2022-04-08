import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'reading_counter.dart';

/* DÉBUT DU SNIPPET */

class HomeView extends ConsumerWidget {
  const HomeView({Key? key}): super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // utiliser ref pour écouter un provider
    final counter = ref.watch(counterProvider);
    return Text('$counter');
  }
}
