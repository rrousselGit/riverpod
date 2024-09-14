// ignore_for_file: omit_local_variable_types, prefer_const_constructors, unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'activity.dart';
import 'provider.dart';

/* SNIPPET START */

// {@template note}
/// We subclassed "ConsumerWidget" instead of "StatelessWidget".
/// This is equivalent to making a "StatelessWidget" and retuning "Consumer".
// {@endtemplate}
class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  // {@template build}
  // Notice how "build" now receives an extra parameter: "ref"
  // {@endtemplate}
  Widget build(BuildContext context, WidgetRef ref) {
    // {@template watch}
    // We can use "ref.watch" inside our widget like we did using "Consumer"
    // {@endtemplate}
    final AsyncValue<Activity> activity = ref.watch(activityProvider);

    // {@template render}
    // The rendering logic stays the same
    // {@endtemplate}
    return Center(/* ... */);
  }
}
