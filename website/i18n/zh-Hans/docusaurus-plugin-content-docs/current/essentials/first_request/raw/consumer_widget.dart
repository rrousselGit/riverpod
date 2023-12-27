// ignore_for_file: omit_local_variable_types, prefer_const_constructors, unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'activity.dart';
import 'provider.dart';

/* SNIPPET START */ /// 我们将“ConsumerWidget”替代“StatelessWidget”进行子类化。
/// 这相当于使用“StatelessWidget”并返回“Consumer”小组件。
class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  // 请注意“build”现在如何接收一个额外的参数：“ref”
  Widget build(BuildContext context, WidgetRef ref) {
    // 我们可以像使用“Consumer”一样，在小部件中使用“ref.watch”
    final AsyncValue<Activity> activity = ref.watch(activityProvider);

    // 渲染逻辑保持不变
    return Center(/* ... */);
  }
}
