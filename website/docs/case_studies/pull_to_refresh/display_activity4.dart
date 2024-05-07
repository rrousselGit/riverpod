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
              // {@template data}
              // If some data is available, we display it.
              // Note that data will still be available during a refresh.
              // {@endtemplate}
              AsyncValue<Activity>(:final valueOrNull?) => Text(valueOrNull.activity),
              // {@template error}
              // An error is available, so we render it.
              // {@endtemplate}
              AsyncValue(:final error?) => Text('Error: $error'),
              // {@template loading}
              // No data/error, so we're in loading state.
              // {@endtemplate}
              _ => const CircularProgressIndicator(),
            },
          ],
        ),
      ),
    );
  }
}
