// ignore_for_file: omit_local_variable_types, prefer_const_constructors, unused_local_variable, todo

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'activity.dart';
import 'provider.dart';

/* SNIPPET START */ // 我们扩展了 ConsumerStatefulWidget。
// 这等效于 "Consumer" + "StatefulWidget".
class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeState();
}

// 请注意，我们如何扩展“ConsumerState”而不是“State”。
// 这和 "ConsumerWidget" 与 "StatelessWidget" 是相同的原理。
class _HomeState extends ConsumerState<Home> {
  @override
  void initState() {
    super.initState();

    // 状态生命周期也可以访问“ref”。
    // 这使得在特定提供者程序上添加监听器，以便实现显示对话框/信息栏等功能。
    ref.listenManual(activityProvider, (previous, next) {
      // TODO 显示一个 snackbar/dialog
    });
  }

  @override
  Widget build(BuildContext context) {
    // "ref" is not passed as parameter anymore, but is instead a property of "ConsumerState".
    // We can therefore keep using "ref.watch" inside "build".
    // “ref”不再作为参数传递，而是作为“ConsumerState”的属性。
    // 因此，我们可以继续在“build”中使用“ref.watch”。
    final AsyncValue<Activity> activity = ref.watch(activityProvider);

    return Center(/* ... */);
  }
}
