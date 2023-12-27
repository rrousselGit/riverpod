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
      // 提供者程序现在是一个需要活动类型的函数。
      // 为了简单起见，我们现在传递一个常量字符串。
      activityProvider('recreational'),
    );
/* SNIPPET END */

    return Container();
  }
}
