// ignore_for_file: omit_local_variable_types

/* SNIPPET START */
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'activity.dart';
import 'provider.dart';

/// The homepage of our application
class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final AsyncValue<Activity> activity = ref.watch(activityProvider);

        return switch (activity) {
          AsyncError() => const Text('Oops, something unexpected happened'),
          AsyncData(:final value) => Text('Activity: ${value.activity}'),
          _ => const Center(child: CircularProgressIndicator()),
        };
      },
    );
  }
}
