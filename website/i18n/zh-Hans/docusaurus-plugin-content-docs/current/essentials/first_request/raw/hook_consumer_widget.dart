// ignore_for_file: omit_local_variable_types, unused_local_variable, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'activity.dart';
import 'provider.dart';

/* SNIPPET START */ /// 我们子类化了 "HookConsumerWidget"。
/// 这同时组合了 "StatelessWidget"、"Consumer"、"HookWidget"。
class Home extends HookConsumerWidget {
  const Home({super.key});

  @override
  // 请注意“build”现在如何接收一个额外的参数：“ref”
  Widget build(BuildContext context, WidgetRef ref) {
    // 可以在我们的小部件中使用诸如“useState”之类的钩子
    final counter = useState(0);

    // 我们还可以使用读取提供者程序
    final AsyncValue<Activity> activity = ref.watch(activityProvider);

    return Center(/* ... */);
  }
}
