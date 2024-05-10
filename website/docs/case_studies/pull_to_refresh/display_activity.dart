// ignore_for_file: use_key_in_widget_constructors

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
      body: Center(
        // {@template render}
        // If we have an activity, display it, otherwise wait
        // {@endtemplate}
        child: Text(activity.valueOrNull?.activity ?? ''),
      ),
    );
  }
}
