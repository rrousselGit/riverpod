// ignore_for_file: omit_local_variable_types, prefer_const_constructors, unused_local_variable, todo

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'activity.dart';
import 'provider.dart';

/* SNIPPET START */

// We extend ConsumerStatefulWidget.
// This is the equivalent of "Consumer" + "StatefulWidget".
class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeState();
}

// Notice how instead of "State", we are extending "ConsumerState".
// This uses the same principle as "ConsumerWidget" vs "StatelessWidget".
class _HomeState extends ConsumerState<Home> {
  @override
  void initState() {
    super.initState();

    // State life-cycles have access to "ref" too.
    // This enables things such as adding a listener on a specific provider
    // to show dialogs/snackbars.
    ref.listenManual(activityProvider, (previous, next) {
      // TODO show a snackbar/dialog
    });
  }

  @override
  Widget build(BuildContext context) {
    // "ref" is not passed as parameter anymore, but is instead a property of "ConsumerState".
    // We can therefore keep using "ref.watch" inside "build".
    final AsyncValue<Activity> activity = ref.watch(activityProvider);

    return Center(/* ... */);
  }
}
