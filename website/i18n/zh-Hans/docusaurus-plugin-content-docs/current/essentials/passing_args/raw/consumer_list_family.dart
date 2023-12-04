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
    // 我们可以更新 ActivityProvider 接受字符串列表以替换之前的代码。
    // 然后尝试直接在 watch 调用中创建该列表。
    ref.watch(activityProvider(['recreational', 'cooking']));
/* SNIPPET END */

    return Container();
  }
}
