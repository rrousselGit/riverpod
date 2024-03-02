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
              // 일부 데이터를 사용할 수 있는 경우 해당 데이터를 표시합니다.
              // 새로 고침 중에도 데이터를 계속 사용할 수 있습니다.
              AsyncValue<Activity>(:final valueOrNull?) => Text(valueOrNull.activity),
              // 오류를 사용할 수 있으므로 렌더링합니다.
              AsyncValue(:final error?) => Text('Error: $error'),
              // 데이터/오류가 없으므로 로딩 상태입니다.
              _ => const CircularProgressIndicator(),
            },
          ],
        ),
      ),
    );
  }
}
