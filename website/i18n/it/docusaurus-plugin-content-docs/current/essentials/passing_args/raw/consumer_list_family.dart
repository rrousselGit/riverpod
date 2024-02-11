// ignore_for_file: omit_local_variable_types, unused_local_variable, prefer_final_locals, provider_parameters

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final activityProvider = Provider.family<Object, Object>((ref, id) {
  throw UnimplementedError();
});

class Example extends ConsumerWidget {
  const Example({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
/* SNIPPET START */
    // Potremmo aggiornare activityProvider per accettare direttamente una lista di stringhe.
    // Poi essere tentati di creare quella lista direttamente nella chiamata di watch.
    ref.watch(activityProvider(['recreational', 'cooking']));
/* SNIPPET END */

    return Container();
  }
}
