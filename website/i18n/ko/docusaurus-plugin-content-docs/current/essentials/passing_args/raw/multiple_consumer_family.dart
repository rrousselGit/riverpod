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
      // 이제 provider는 액티비티 타입을 기대하는 함수입니다.
      // 단순화를 위해 지금은 상수 문자열을 전달하겠습니다.
      activityProvider('recreational'),
    );
    /* SNIPPET START */
    return Consumer(
      builder: (context, ref, child) {
        final recreational = ref.watch(activityProvider('recreational'));
        final cooking = ref.watch(activityProvider('cooking'));

        // 그러면 두 활동을 모두 렌더링할 수 있습니다.
        // 두 요청이 모두 병렬로 발생하고 올바르게 캐시됩니다.
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
