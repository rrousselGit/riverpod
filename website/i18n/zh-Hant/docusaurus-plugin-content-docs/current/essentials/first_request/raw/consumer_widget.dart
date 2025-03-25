// ignore_for_file: omit_local_variable_types, prefer_const_constructors, unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'activity.dart';
import 'provider.dart';

/* SNIPPET START */ /// 我們將“ConsumerWidget”替代“StatelessWidget”進行子類化。
/// 這相當於使用“StatelessWidget”並返回“Consumer”小元件。
class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  // 請注意“build”現在如何接收一個額外的引數：“ref”
  Widget build(BuildContext context, WidgetRef ref) {
    // 我們可以像使用“Consumer”一樣，在小部件中使用“ref.watch”
    final AsyncValue<Activity> activity = ref.watch(activityProvider);

    // 渲染邏輯保持不變
    return Center(/* ... */);
  }
}
