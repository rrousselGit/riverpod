// ignore_for_file: omit_local_variable_types, unused_local_variable, prefer_final_locals

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../first_request/raw/activity.dart';
import 'family.dart';

class Example extends ConsumerWidget {
  const Example({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
/* SNIPPET START */
    AsyncValue<Activity> activity = ref.watch(
      // Il provider è ora una funzione che si aspetta il tipo dell'attività
      // Passiamo una costante stringa per ora, per semplicità.
      activityProvider('recreational'),
    );
/* SNIPPET END */

    return Container();
  }
}
