// ignore_for_file: omit_local_variable_types, unused_local_variable, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'activity.dart';
import 'provider.dart';

/* SNIPPET START */

// {@template raw_homeWidget}
/// We subclassed "HookConsumerWidget".
/// This combines "StatelessWidget" + "Consumer" + "HookWidget" together.
// {@endtemplate}
class Home extends HookConsumerWidget {
  const Home({super.key});

  @override
  // {@template raw_build}
  // Notice how "build" now receives an extra parameter: "ref"
  // {@endtemplate}
  Widget build(BuildContext context, WidgetRef ref) {
    // {@template raw_useState}
    // It is possible to use hooks such as "useState" inside our widget
    // {@endtemplate}
    final counter = useState(0);

    // {@template raw_activity}
    // We can also use read providers
    // {@endtemplate}
    final AsyncValue<Activity> activity = ref.watch(activityProvider);

    return Center(/* ... */);
  }
}
