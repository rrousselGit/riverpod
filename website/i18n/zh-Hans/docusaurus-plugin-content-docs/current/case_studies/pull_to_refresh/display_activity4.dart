// ignore_for_file: avoid_print, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'activity/codegen.dart';
import 'fetch_activity/codegen.dart';

/* SNIPPET START */
class ActivityView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activity = ref.watch(activityProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Pull to refresh')),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(activityProvider.future),
        child: ListView(
          children: [
            switch (activity) {
              // 如果有数据可用，我们就显示它。
              // 请注意，数据在重刷新时仍然可用。
              AsyncValue<Activity>(:final valueOrNull?) =>
                Text(valueOrNull.activity),
              // 有一个错误，因此我们将其呈现出来。
              AsyncValue(:final error?) => Text('Error: $error'),
              // 无数据/错误，因此我们处于加载状态。
              _ => const CircularProgressIndicator(),
            },
          ],
        ),
      ),
    );
  }
}
