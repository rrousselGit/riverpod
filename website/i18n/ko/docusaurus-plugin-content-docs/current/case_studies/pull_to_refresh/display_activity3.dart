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
        // "activityProvider.future"를 새로 고침으로, 해당 결과를 반환하면,
        // 새 액티비티를 가져올 때까지
        // 새로 고침 표시기(refresh indicator)가 계속 표시됩니다.
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
