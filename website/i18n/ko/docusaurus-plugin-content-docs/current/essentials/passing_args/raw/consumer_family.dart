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
      // 이제 provider는 액티비티 타입을 기대하는 함수입니다.
      // 단순화를 위해 지금은 상수 문자열을 전달하겠습니다.
      activityProvider('recreational'),
    );
/* SNIPPET END */

    return Container();
  }
}
