// ignore_for_file: omit_local_variable_types, unused_local_variable, prefer_final_locals

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../first_request/raw/activity.dart';
import '../family/raw.dart';

class Example extends ConsumerWidget {
  const Example({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
/* SNIPPET START */
    AsyncValue<Activity> activity = ref.watch(
      // {@template provider}
      // The provider is now a function expecting the activity type.
      // Let's pass a constant string for now, for the sake of simplicity.
      // {@endtemplate}
      activityProvider('recreational'),
    );
/* SNIPPET END */

    return Container();
  }
}
