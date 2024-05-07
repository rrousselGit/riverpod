// ignore_for_file: omit_local_variable_types

/* SNIPPET START */
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'activity.dart';
import 'provider.dart';

// {@template note}
/// The homepage of our application
// {@endtemplate}
class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        // {@template activity}
        // Read the activityProvider. This will start the network request
        // if it wasn't already started.
        // By using ref.watch, this widget will rebuild whenever the
        // the activityProvider updates. This can happen when:
        // - The response goes from "loading" to "data/error"
        // - The request was refreshed
        // - The result was modified locally (such as when performing side-effects)
        // ...
        // {@endtemplate}
        final AsyncValue<Activity> activity = ref.watch(activityProvider);

        return Center(
          // {@template states}
          /// Since network-requests are asynchronous and can fail, we need to
          /// handle both error and loading states. We can use pattern matching for this.
          /// We could alternatively use `if (activity.isLoading) { ... } else if (...)`
          // {@endtemplate}
          child: switch (activity) {
            AsyncData(:final value) => Text('Activity: ${value.activity}'),
            AsyncError() => const Text('Oops, something unexpected happened'),
            _ => const CircularProgressIndicator(),
          },
        );
      },
    );
  }
}
