// ignore_for_file: omit_local_variable_types, unused_local_variable, prefer_final_locals

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
    // {@template providers}
    // We could update activityProvider to accept a list of strings instead.
    // Then be tempted to create that list directly in the watch call.
    // {@endtemplate}
    ref.watch(activityProvider(['recreational', 'cooking']));
/* SNIPPET END */

    return Container();
  }
}
