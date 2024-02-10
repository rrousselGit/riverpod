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
    // 대신 문자열 목록을 허용하도록 activityProvider를 업데이트할 수 있습니다.
    // 그런 다음 watch를 호출하여 해당 목록을 직접 만들 수 있습니다.
    ref.watch(activityProvider(['recreational', 'cooking']));
/* SNIPPET END */

    return Container();
  }
}
