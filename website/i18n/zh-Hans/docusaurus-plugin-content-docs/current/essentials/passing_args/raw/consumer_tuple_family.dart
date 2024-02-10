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
      // 使用记录，我们可以传递参数。
      // 在 watch 调用中，可以实现直接创建带有覆盖 == 功能的记录。
      activityProvider((type: 'recreational', maxPrice: 40)),
    );
/* SNIPPET END */

    return Container();
  }
}
