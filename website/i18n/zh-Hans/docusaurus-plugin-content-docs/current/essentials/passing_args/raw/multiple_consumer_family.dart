// ignore_for_file: omit_local_variable_types, unused_local_variable, prefer_final_locals

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../first_request/raw/activity.dart';
import 'family.dart';

class Example extends ConsumerWidget {
  const Example({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<Activity> activity = ref.watch(
      // The provider is now a function expecting the activity type.
      // Let's pass a constant string for now, for the sake of simplicity.
      activityProvider('recreational'),
    );
    /* SNIPPET START */
    return Consumer(
      builder: (context, ref, child) {
        final recreational = ref.watch(activityProvider('recreational'));
        final cooking = ref.watch(activityProvider('cooking'));

        // 然后我们可以同时渲染这两个活动。
        // 两个请求将并行发生并正确缓存。
        return Column(
          children: [
            Text(recreational.valueOrNull?.activity ?? ''),
            Text(cooking.valueOrNull?.activity ?? ''),
          ],
        );
      },
    );
    /* SNIPPET END */
  }
}
