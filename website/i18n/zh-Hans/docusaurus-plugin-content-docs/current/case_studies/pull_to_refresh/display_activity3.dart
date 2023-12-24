// ignore_for_file: avoid_print, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'fetch_activity/codegen.dart';

/* SNIPPET START */
class ActivityView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activity = ref.watch(activityProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Pull to refresh')),
      body: RefreshIndicator(
        // 通过重刷新调用 "activityProvider.future" 并返回结果，
        // 刷新指示器将一直显示，直到获取到新的活动。
        /* highlight-start */
        onRefresh: () => ref.refresh(activityProvider.future),
        /* highlight-end */
        child: ListView(
          children: [
            Text(activity.valueOrNull?.activity ?? ''),
          ],
        ),
      ),
    );
  }
}
