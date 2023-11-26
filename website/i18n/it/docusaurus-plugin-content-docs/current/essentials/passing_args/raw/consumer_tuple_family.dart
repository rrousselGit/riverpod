// ignore_for_file: omit_local_variable_types, unused_local_variable, prefer_final_locals

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'tuple_family.dart';

class Example extends ConsumerWidget {
  const Example({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
/* SNIPPET START */
    ref.watch(
      // Usando un Record possiamo passare i nostri parametri.
      // È possibile creare direttamente il record nella chiamata watch
      // poiché i record sovrascrivono ==.
      activityProvider((type: 'recreational', maxPrice: 40)),
    );
/* SNIPPET END */

    return Container();
  }
}
