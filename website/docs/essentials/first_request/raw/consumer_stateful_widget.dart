// ignore_for_file: omit_local_variable_types, prefer_const_constructors, unused_local_variable, todo

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'activity.dart';
import 'provider.dart';

/* SNIPPET START */

// {@template raw_homeWidget}
// We extend ConsumerStatefulWidget.
// This is the equivalent of "Consumer" + "StatefulWidget".
// {@endtemplate}
class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeState();
}

// {@template raw_homeState}
// Notice how instead of "State", we are extending "ConsumerState".
// This uses the same principle as "ConsumerWidget" vs "StatelessWidget".
// {@endtemplate}
class _HomeState extends ConsumerState<Home> {
  @override
  void initState() {
    super.initState();

    // {@template raw_listen}
    // State life-cycles have access to "ref" too.
    // This enables things such as adding a listener on a specific provider
    // to show dialogs/snackbars.
    // {@endtemplate}
    ref.listenManual(activityProvider, (previous, next) {
      // {@template raw_todo}
      // TODO show a snackbar/dialog
      // {@endtemplate}
    });
  }

  @override
  Widget build(BuildContext context) {
    // {@template raw_watch}
    // "ref" is not passed as parameter anymore, but is instead a property of "ConsumerState".
    // We can therefore keep using "ref.watch" inside "build".
    // {@endtemplate}
    final AsyncValue<Activity> activity = ref.watch(activityProvider);

    return Center(/* ... */);
  }
}
