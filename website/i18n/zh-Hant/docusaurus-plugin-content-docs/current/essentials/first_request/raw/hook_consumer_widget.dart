// ignore_for_file: omit_local_variable_types, unused_local_variable, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'activity.dart';
import 'provider.dart';

/* SNIPPET START */ /// 我們子類化了 "HookConsumerWidget"。
/// 這同時組合了 "StatelessWidget"、"Consumer"、"HookWidget"。
class Home extends HookConsumerWidget {
  const Home({super.key});

  @override
  // 請注意“build”現在如何接收一個額外的引數：“ref”
  Widget build(BuildContext context, WidgetRef ref) {
    // 可以在我們的小部件中使用諸如“useState”之類的鉤子
    final counter = useState(0);

    // 我們還可以使用讀取提供者程式
    final AsyncValue<Activity> activity = ref.watch(activityProvider);

    return Center(/* ... */);
  }
}
