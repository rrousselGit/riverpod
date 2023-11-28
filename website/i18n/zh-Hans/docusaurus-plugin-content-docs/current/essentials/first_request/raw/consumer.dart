// ignore_for_file: omit_local_variable_types

/* SNIPPET START */ import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'activity.dart';
import 'provider.dart';

/// 我们应用程序主页
class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        // 读取 activityProvider。如果没有准备开始，这将会开始一个网络请求。
        // 通过使用 ref.watch，小组件将会在 activityProvider 更新时重建。
        // 当下面的事情发生时，会更新小组件：
        // - 响应从“正在加载”变为“数据/错误”
        // - 请求重刷新
        // - 结果被本地修改（例如执行副作用时）
        // ...
        final AsyncValue<Activity> activity = ref.watch(activityProvider);

        return Center(
          /// 由于网络请求是异步的并且可能会失败，我们需要处理错误和加载的状态。
          /// 我们可以为此使用模式匹配。
          /// 我们也可以使用 `if (activity.isLoading) { ... } else if (...)`
          child: switch (activity) {
            AsyncData(:final value) => Text('Activity: ${value.activity}'),
            AsyncError() => const Text('Oops, something unexpected happened'),
            _ => const CircularProgressIndicator(),
          },
        );
      },
    );
  }
}
